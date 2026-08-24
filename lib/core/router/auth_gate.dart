import 'package:flutter/foundation.dart';

import 'authentication_status.dart';

/// Cross-cutting auth seam shared by the router guard and (later) the
/// admin AuthCubit. The cubit pushes status updates here; [GoRouter]
/// listens to this object via `refreshListenable`.
class AuthGate extends ChangeNotifier {
  AuthenticationStatus _status = AuthenticationStatus.unauthenticated;

  AuthenticationStatus get status => _status;

  void update(AuthenticationStatus status) {
    if (_status == status) return;
    _status = status;
    notifyListeners();
  }
}
