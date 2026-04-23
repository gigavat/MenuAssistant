import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';

import '../core/app_state.dart';
import '../core/service_locator.dart';
import '../l10n/app_localizations.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/accent_button.dart';
import '../widgets/app_input.dart';
import 'home_screen.dart';

/// Post-registration wizard: collects full name + birth date and posts
/// them to `userAccount.saveProfile`. Shown once right after
/// `finishRegistration` succeeds; on success pushes HomeScreen.
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _client = getIt<Client>();
  final _appState = getIt<AppState>();
  final _nameController = TextEditingController();
  DateTime? _birthDate;
  bool _saving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: AppLocalizations.of(context)!.profileSetupBirthDateLabel,
    );
    if (picked != null && mounted) {
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = l10n.profileSetupNameRequired);
      return;
    }
    setState(() {
      _saving = true;
      _errorMessage = null;
    });
    try {
      final saved = await _client.userAccount.saveProfile(
        fullName: name,
        birthDate: _birthDate,
      );
      if (!mounted) return;
      _appState.setProfile(saved);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      debugPrint('[ProfileSetupScreen] saveProfile failed: $e');
      if (mounted) {
        setState(() {
          _saving = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    const titleSize = 30.0;
    final romanFamily = serifFamily(l10n.profileSetupTitlePlain);

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s24, AppSpacing.s40, AppSpacing.s24, AppSpacing.s24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.profileSetupEyebrow.toUpperCase(),
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
                        fontFamily: romanFamily,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w500,
                        height: 1.05,
                        letterSpacing: -0.02 * titleSize,
                        color: colors.onSurface,
                      ),
                      children: [
                        TextSpan(text: '${l10n.profileSetupTitlePlain} '),
                        TextSpan(
                          text: l10n.profileSetupTitleAccent,
                          style: serifItalic(
                            text: l10n.profileSetupTitleAccent,
                            size: titleSize,
                            color: colors.primary,
                            height: 1.05,
                            letterSpacing: -0.02 * titleSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text(
                    l10n.profileSetupBody,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      height: 1.5,
                      color: colors.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  AppInput(
                    controller: _nameController,
                    placeholder: l10n.profileSetupNamePlaceholder,
                    icon: Icons.person_outline,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      if (!_saving) _submit();
                    },
                    onWhite: true,
                    autofocus: true,
                  ),
                  const SizedBox(height: AppSpacing.s14),
                  _buildBirthDateField(context, l10n),
                  const SizedBox(height: AppSpacing.s20),
                  AccentButton(
                    label: _saving ? '…' : l10n.profileSetupSubmit,
                    onPressed: _saving ? null : _submit,
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.s16),
                    _buildErrorBanner(context, _errorMessage!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBirthDateField(BuildContext context, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    final label = _birthDate == null
        ? l10n.profileSetupBirthDateLabel
        : _formatDate(_birthDate!);
    final hasValue = _birthDate != null;

    return InkWell(
      onTap: _saving ? null : _pickBirthDate,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s14),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.outline, width: 1),
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        child: Row(
          children: [
            Icon(
              Icons.cake_outlined,
              size: 16,
              color: colors.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: hasValue
                      ? colors.onSurface
                      : colors.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: colors.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  Widget _buildErrorBanner(BuildContext context, String message) {
    final colors = Theme.of(context).colorScheme;
    return Container(
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
        ],
      ),
    );
  }
}
