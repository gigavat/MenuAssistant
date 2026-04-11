import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

class UserAccountEndpoint extends Endpoint {
  /// Checks if an email is already registered in the system.
  Future<bool> checkEmailExists(Session session, String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    
    // Check EmailAccount table from serverpod_auth_idp_server
    final emailAccount = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.email.ilike(normalizedEmail),
    );
    
    return emailAccount != null;
  }
}

