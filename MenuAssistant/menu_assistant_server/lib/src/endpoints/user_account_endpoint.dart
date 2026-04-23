import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// `UserAccountEndpoint` mixes a PUBLIC method (`checkEmailExists` —
/// called during the registration-vs-login branch in the merged Auth
/// screen, before any session exists) with AUTHENTICATED methods
/// (`getProfile`, `saveProfile`). Serverpod's `requireLogin` override
/// applies to the whole class, so we can't gate only the profile
/// methods that way. Instead we leave `requireLogin = false` (default)
/// and assert `session.authenticated` manually inside the protected
/// methods. See gotcha #22 for the rationale.
class UserAccountEndpoint extends Endpoint {
  /// Checks if an email is already registered. Public by design —
  /// invoked when the client has no session yet (deciding whether
  /// Submit should attempt login or start registration).
  Future<bool> checkEmailExists(Session session, String email) async {
    final normalizedEmail = email.trim().toLowerCase();

    // Check EmailAccount table from serverpod_auth_idp_server
    final emailAccount = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.email.ilike(normalizedEmail),
    );

    return emailAccount != null;
  }

  /// Returns the caller's profile (full name + birth date captured in
  /// the post-registration wizard). Returns null if the profile wasn't
  /// set up yet — the client routes through ProfileSetupScreen in that
  /// case. Requires authentication.
  Future<AppUserProfile?> getProfile(Session session) async {
    final userId = _requireUserId(session);
    return AppUserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
  }

  /// Upserts the caller's profile. Creates the row on first call (post-
  /// registration), overwrites the fields on subsequent calls (edit flow).
  /// Requires authentication.
  Future<AppUserProfile> saveProfile(
    Session session, {
    required String fullName,
    DateTime? birthDate,
  }) async {
    final userId = _requireUserId(session);
    final now = DateTime.now();
    final trimmedName = fullName.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError.value(fullName, 'fullName', 'must not be empty');
    }

    final existing = await AppUserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
    if (existing == null) {
      return AppUserProfile.db.insertRow(
        session,
        AppUserProfile(
          userId: userId,
          fullName: trimmedName,
          birthDate: birthDate,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
    return AppUserProfile.db.updateRow(
      session,
      existing.copyWith(
        fullName: trimmedName,
        birthDate: birthDate,
        updatedAt: now,
      ),
    );
  }

  String _requireUserId(Session session) {
    final auth = session.authenticated;
    if (auth == null) {
      throw StateError(
        'This endpoint method requires authentication. Ensure the client '
        'has a valid session before calling profile methods.',
      );
    }
    return auth.userIdentifier;
  }
}

