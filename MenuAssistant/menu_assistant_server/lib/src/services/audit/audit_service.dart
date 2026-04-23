import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Записывает mutation события модераторов в `audit_log`. Immutable
/// append-only. IP приходит из `Cf-Connecting-IP` (production) или из
/// connection info (dev). Retention 24 мес — не форсится на уровне БД,
/// будем архивировать в Glacier когда таблица начнёт давить (Sprint 6+).
class AuditService {
  const AuditService();

  Future<void> logAction(
    Session session, {
    required String actorEmail,
    required String action,
    required String objectType,
    required String objectId,
    required String diff,
  }) async {
    await AuditLog.db.insertRow(
      session,
      AuditLog(
        timestamp: DateTime.now(),
        actorEmail: actorEmail,
        action: action,
        objectType: objectType,
        objectId: objectId,
        diff: diff,
        ipAddress: _extractClientIp(session),
      ),
    );
  }

  String? _extractClientIp(Session session) {
    if (session is! MethodCallSession) return null;
    final req = session.request;
    final cf = req.headers['cf-connecting-ip']?.firstOrNull;
    if (cf != null && cf.isNotEmpty) return cf;
    final xf = req.headers['x-forwarded-for']?.firstOrNull;
    if (xf != null && xf.isNotEmpty) return xf.split(',').first.trim();
    return req.connectionInfo.remote.address.toString();
  }
}
