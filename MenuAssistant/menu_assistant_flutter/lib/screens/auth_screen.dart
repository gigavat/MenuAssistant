import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../core/service_locator.dart';
import '../core/app_state.dart';

enum AuthView {
  emailPassword,
  verifyCode,
}

class AuthScreen extends StatefulWidget {
  final bool showBackButton;
  const AuthScreen({super.key, this.showBackButton = true});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _client = getIt<Client>();
  final _appState = getIt<AppState>();

  late final EmailAuthController _emailAuth;
  late final GoogleAuthController _googleAuth;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();

  final _codeFocusNode = FocusNode();

  AuthView _currentView = AuthView.emailPassword;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailAuth = EmailAuthController(
      client: _client,
      onAuthenticated: () {
        _appState.refreshAuth();
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.pop(context, true);
        }
      },
      onError: (e) {
        if (mounted && !_isLoading) setState(() => _errorMessage = e.toString());
      },
    );
    _googleAuth = GoogleAuthController(
      client: _client,
      onAuthenticated: () {
        _appState.refreshAuth();
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.pop(context, true);
        }
      },
      onError: (e) {
        if (mounted && !_isLoading) setState(() => _errorMessage = e.toString());
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    _codeFocusNode.dispose();
    _emailAuth.dispose();
    _googleAuth.dispose();
    super.dispose();
  }

  // ─── Actions ────────────────────────────────────────────────────

  Future<void> _handleEmailSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMessage = 'Введите корректный email');
      return;
    }
    if (password.isEmpty) {
      setState(() => _errorMessage = 'Введите пароль');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _emailAuth.emailController.text = email;
    _emailAuth.passwordController.text = password;

    await _emailAuth.login();

    if (!mounted) return;

    if (_emailAuth.state == EmailAuthState.error) {
      setState(() => _errorMessage = null);

      try {
        final exists = await _client.userAccount.checkEmailExists(email);

        if (!mounted) return;

        if (exists) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Неверный пароль. Пожалуйста, попробуйте еще раз.';
          });
          return;
        }

        await _emailAuth.startRegistration();

        if (!mounted) return;

        if (_emailAuth.state == EmailAuthState.error) {
          setState(() {
            _isLoading = false;
            _errorMessage = _emailAuth.errorMessage;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = null;
            _currentView = AuthView.verifyCode;
          });
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) _codeFocusNode.requestFocus();
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Ошибка при проверке пользователя: $e';
          });
        }
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });
    }
  }

  Future<void> _handleVerifyCodeAndFinish() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      setState(() => _errorMessage = 'Введите 6-значный код');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _emailAuth.verificationCodeController.text = code;

    await _emailAuth.verifyRegistrationCode();

    if (!mounted) return;

    if (_emailAuth.state == EmailAuthState.error) {
      setState(() {
        _isLoading = false;
        _errorMessage = _emailAuth.errorMessage ?? 'Неверный код';
      });
      return;
    }

    _emailAuth.passwordController.text = _passwordController.text;
    await _emailAuth.finishRegistration();

    if (mounted) {
      if (_emailAuth.state == EmailAuthState.error) {
        setState(() {
          _isLoading = false;
          _errorMessage = _emailAuth.errorMessage ?? 'Ошибка при завершении регистрации';
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ─── UI Helpers ─────────────────────────────────────────────────

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: readOnly,
        fillColor: readOnly ? Theme.of(context).colorScheme.surfaceContainerHighest : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: _isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget _buildPinDisplay(TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final filled = controller.text.length > index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            width: 45,
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(
                color: filled
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outlineVariant,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                filled ? controller.text[index] : '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPinEntry(TextEditingController controller) {
    return GestureDetector(
      onTap: () => _codeFocusNode.requestFocus(),
      child: Stack(
        children: [
          _buildPinDisplay(controller),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: controller,
                focusNode: _codeFocusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                onChanged: (value) {
                  setState(() {});
                  if (value.length == 6) _handleVerifyCodeAndFinish();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    if (_errorMessage == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _errorMessage = null),
            child: const Icon(Icons.close, color: Colors.red, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('или', style: TextStyle(color: Colors.grey)),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: GoogleSignInWidget(
            controller: _googleAuth,
            size: GSIButtonSize.large,
            buttonWrapper: ({required style, required child, required onPressed}) {
              return InkWell(
                onTap: onPressed,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                child: child,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmailPasswordView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          _emailController,
          'Email',
          Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          _passwordController,
          'Пароль',
          Icons.lock_outline,
          obscure: true,
        ),
        const SizedBox(height: 24),
        _buildActionButton('Войти / Создать', _handleEmailSubmit),
        _buildGoogleSection(),
      ],
    );
  }

  Widget _buildVerifyCodeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Введите 6-значный код, отправленный на почту:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 8),
        Text(
          _emailController.text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 32),
        _buildPinEntry(_codeController),
        const SizedBox(height: 40),
        _buildActionButton('Завершить', _handleVerifyCodeAndFinish),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (!widget.showBackButton && _currentView == AuthView.emailPassword)
            ? const SizedBox.shrink()
            : (_currentView == AuthView.emailPassword)
                ? null
                : IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _errorMessage = null;
                        _currentView = AuthView.emailPassword;
                        _codeController.clear();
                      });
                    },
                  ),
        automaticallyImplyLeading: widget.showBackButton || _currentView != AuthView.emailPassword,
        title: const Text('Авторизация'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentView == AuthView.emailPassword) _buildEmailPasswordView(),
                if (_currentView == AuthView.verifyCode) _buildVerifyCodeView(),
                const SizedBox(height: 16),
                _buildErrorBanner(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
