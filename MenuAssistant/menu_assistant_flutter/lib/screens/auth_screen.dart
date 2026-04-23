import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../core/app_state.dart';
import '../core/service_locator.dart';
import '../l10n/app_localizations.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/accent_button.dart';
import '../widgets/app_input.dart';
import '../widgets/ghost_button.dart';
import 'home_screen.dart';
import 'profile_setup_screen.dart';
import 'terms_screen.dart';

enum _AuthView { emailPassword, verifyCode }

/// Merged auth screen. Single form → backend determines sign-in vs
/// sign-up; PIN verification shows inline as a second pane when a new
/// account needs confirmation.
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
  final _passwordFocusNode = FocusNode();

  _AuthView _view = _AuthView.emailPassword;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailAuth = EmailAuthController(
      client: _client,
      onAuthenticated: _handleAuthenticated,
      onError: (e) {
        if (mounted && !_isLoading) {
          setState(() => _errorMessage = e.toString());
        }
      },
    );
    _googleAuth = GoogleAuthController(
      client: _client,
      onAuthenticated: _handleAuthenticated,
      onError: (e) {
        if (mounted && !_isLoading) {
          setState(() => _errorMessage = e.toString());
        }
      },
    );
  }

  /// Shared post-auth flow for both email + Google controllers.
  ///
  /// Notifies AppState so listeners higher up can refresh, then navigates.
  /// Declarative `home: appState.isAuthenticated ? HomeScreen : AuthScreen`
  /// in MaterialApp is unreliable on its own — Navigator holds the already
  /// mounted AuthScreen route and ignores a swap of MaterialApp.home at
  /// runtime. An imperative `pushReplacement` guarantees the transition.
  ///
  /// Branch on `_view`: if we're in the verify-code pane the caller was
  /// registering a fresh account (finishRegistration fires onAuthenticated),
  /// so we route to ProfileSetupScreen to collect name + birth date before
  /// Home. Plain login keeps the existing path to HomeScreen.
  void _handleAuthenticated() {
    _appState.refreshAuth();
    if (!mounted) return;
    final isNewRegistration = _view == _AuthView.verifyCode;
    debugPrint('[AuthScreen] authenticated, '
        'client.auth.isAuthenticated=${_client.auth.isAuthenticated}, '
        'newRegistration=$isNewRegistration');
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      // Entered AuthScreen from a push (e.g. re-auth after sign-out).
      nav.pop(true);
      return;
    }
    final next = isNewRegistration
        ? const ProfileSetupScreen()
        : const HomeScreen();
    nav.pushReplacement(MaterialPageRoute(builder: (_) => next));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    _codeFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailAuth.dispose();
    _googleAuth.dispose();
    super.dispose();
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  Future<void> _handleEmailSubmit() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || !email.contains('@') || password.isEmpty) {
      setState(() => _errorMessage = l10n.errorGeneric);
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

    // Success: EmailAuthController fires onAuthenticated internally,
    // AppState.refreshAuth() triggers MaterialApp rebuild → HomeScreen.
    if (_emailAuth.state == EmailAuthState.authenticated) {
      setState(() => _isLoading = false);
      return;
    }

    // Login failed — surface the real underlying cause rather than a
    // generic "Something went wrong" (which hid server-side errors like
    // DB schema issues in earlier versions). If the account exists it's
    // a wrong password; otherwise assume new user → start registration.
    final loginError = _emailAuth.error;
    debugPrint('[AuthScreen] login failed for $email: $loginError '
        '(errorMessage=${_emailAuth.errorMessage})');

    try {
      final exists = await _client.userAccount.checkEmailExists(email);
      if (!mounted) return;
      if (exists) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              _emailAuth.errorMessage ?? loginError?.toString() ?? l10n.errorGeneric;
        });
        return;
      }
      await _emailAuth.startRegistration();
      if (!mounted) return;
      if (_emailAuth.state == EmailAuthState.error) {
        setState(() {
          _isLoading = false;
          _errorMessage = _emailAuth.errorMessage ?? l10n.errorGeneric;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = null;
          _view = _AuthView.verifyCode;
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _codeFocusNode.requestFocus();
        });
      }
    } catch (e) {
      debugPrint('[AuthScreen] checkEmailExists/registration failed: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _handleVerifyCode() async {
    final l10n = AppLocalizations.of(context)!;
    final code = _codeController.text.trim();
    if (code.length != 6) {
      setState(() => _errorMessage = l10n.errorGeneric);
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
        _errorMessage = _emailAuth.errorMessage ?? l10n.errorGeneric;
      });
      return;
    }

    _emailAuth.passwordController.text = _passwordController.text;
    await _emailAuth.finishRegistration();

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (_emailAuth.state == EmailAuthState.error) {
        _errorMessage = _emailAuth.errorMessage ?? l10n.errorGeneric;
      }
    });
  }

  // ─── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: widget.showBackButton || _view == _AuthView.verifyCode
          ? AppBar(
              elevation: 0,
              backgroundColor: colors.surface,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, size: 20),
                onPressed: () {
                  if (_view == _AuthView.verifyCode) {
                    setState(() {
                      _view = _AuthView.emailPassword;
                      _codeController.clear();
                      _errorMessage = null;
                    });
                  } else {
                    Navigator.of(context).maybePop();
                  }
                },
              ),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s24, AppSpacing.s40, AppSpacing.s24, AppSpacing.s24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _view == _AuthView.emailPassword
                  ? _buildEmailView(context, l10n)
                  : _buildVerifyView(context, l10n),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailView(BuildContext context, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.authEyebrow.toUpperCase(),
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 10,
            letterSpacing: 1.5,
            color: colors.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: AppSpacing.s14),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: serifFamily(l10n.authTitlePlain),
              fontSize: 34,
              fontWeight: FontWeight.w500,
              height: 1.05,
              color: colors.onSurface,
            ),
            children: [
              TextSpan(text: '${l10n.authTitlePlain} '),
              TextSpan(
                text: l10n.authTitleAccent,
                style: serifItalic(
                  text: l10n.authTitleAccent,
                  size: 34,
                  color: colors.primary,
                  height: 1.05,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        Text(
          l10n.authBody,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            height: 1.5,
            color: colors.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.s32),
        AppInput(
          controller: _emailController,
          placeholder: l10n.authEmailPlaceholder,
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _passwordFocusNode.requestFocus(),
          onWhite: true,
        ),
        const SizedBox(height: AppSpacing.s14),
        AppInput(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          placeholder: l10n.authPasswordPlaceholder,
          icon: Icons.lock_outline,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            if (!_isLoading) _handleEmailSubmit();
          },
          onWhite: true,
        ),
        const SizedBox(height: AppSpacing.s20),
        AccentButton(
          label: _isLoading ? '…' : l10n.authSubmit,
          onPressed: _isLoading ? null : _handleEmailSubmit,
        ),
        const SizedBox(height: AppSpacing.s24),
        _buildDivider(context, l10n.authDividerOr),
        const SizedBox(height: AppSpacing.s20),
        GhostButton(
          label: l10n.authGoogle,
          icon: Icons.g_mobiledata,
          onPressed: _isLoading ? null : _googleAuth.signIn,
        ),
        const SizedBox(height: AppSpacing.s24),
        if (_errorMessage != null) _buildErrorBanner(context, _errorMessage!),
        _buildTosLine(context, l10n),
      ],
    );
  }

  Widget _buildVerifyView(BuildContext context, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.authPinPrompt,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1.5,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          _emailController.text,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.s32),
        _buildPinEntry(context),
        const SizedBox(height: AppSpacing.s32),
        AccentButton(
          label: _isLoading ? '…' : l10n.commonDone,
          onPressed: _isLoading ? null : _handleVerifyCode,
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: AppSpacing.s16),
          _buildErrorBanner(context, _errorMessage!),
        ],
      ],
    );
  }

  Widget _buildDivider(BuildContext context, String label) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Divider(color: colors.outline)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s14),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              color: colors.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
        Expanded(child: Divider(color: colors.outline)),
      ],
    );
  }

  Widget _buildPinEntry(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _codeFocusNode.requestFocus(),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              final filled = _codeController.text.length > index;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: 42,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    border: Border.all(
                      color: filled ? colors.primary : colors.outline,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    filled ? _codeController.text[index] : '',
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _codeController,
                focusNode: _codeFocusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                onChanged: (v) {
                  setState(() {});
                  if (v.length == 6) _handleVerifyCode();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Footer "By continuing you agree to …" line. The `authTosLink`
  /// substring inside `authTos` is rendered as an underlined accent
  /// span and opens [TermsScreen] on tap.
  Widget _buildTosLine(BuildContext context, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    final baseStyle = TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 10,
      height: 1.6,
      color: colors.onSurface.withValues(alpha: 0.4),
    );
    final linkStyle = baseStyle.copyWith(
      color: colors.onSurface.withValues(alpha: 0.7),
      decoration: TextDecoration.underline,
      decorationColor: colors.onSurface.withValues(alpha: 0.4),
    );

    final full = l10n.authTos;
    final link = l10n.authTosLink;
    final start = full.indexOf(link);

    void openTerms() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const TermsScreen()),
      );
    }

    if (start < 0) {
      // Defensive fallback — if a translation diverged from the template
      // and the link substring isn't found, keep the whole line tappable
      // so the page stays reachable.
      return GestureDetector(
        onTap: openTerms,
        child: Text(full, textAlign: TextAlign.center, style: baseStyle),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: full.substring(0, start)),
          TextSpan(
            text: link,
            style: linkStyle,
            recognizer: TapGestureRecognizer()..onTap = openTerms,
          ),
          TextSpan(text: full.substring(start + link.length)),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, String message) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s16),
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: colors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colors.error, size: 18),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colors.error, fontSize: 13),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _errorMessage = null),
            child: Icon(Icons.close, color: colors.error, size: 16),
          ),
        ],
      ),
    );
  }
}
