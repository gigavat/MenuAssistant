import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../core/service_locator.dart';

class SignInScreen extends StatefulWidget {
  final Widget child;
  const SignInScreen({super.key, required this.child});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _client = getIt<Client>();
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _client.auth.authInfoListenable.addListener(_updateSignedInState);
    _isSignedIn = _client.auth.isAuthenticated;
  }

  @override
  void dispose() {
    _client.auth.authInfoListenable.removeListener(_updateSignedInState);
    super.dispose();
  }

  void _updateSignedInState() {
    setState(() {
      _isSignedIn = _client.auth.isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSignedIn
        ? widget.child
        : Center(
            child: SignInWidget(
              client: _client,
              onAuthenticated: () {
                context.showSnackBar(
                  message: 'User authenticated.',
                  backgroundColor: Colors.green,
                );
              },
              onError: (error) {
                context.showSnackBar(
                  message: 'Authentication failed: $error',
                  backgroundColor: Colors.red,
                );
              },
            ),
          );
  }
}

extension on BuildContext {
  void showSnackBar({
    required String message,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
