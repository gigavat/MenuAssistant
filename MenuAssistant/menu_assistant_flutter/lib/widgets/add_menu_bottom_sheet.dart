import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';

import '../core/app_state.dart';
import '../core/service_locator.dart';
import '../l10n/app_localizations.dart';
import '../repositories/restaurant_repository.dart';
import '../screens/match_confirmation_dialog.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'accent_button.dart';
import 'ghost_button.dart';
import 'photo_placeholder.dart';

/// Multi-page capable upload sheet.
///
/// The first tap adds a page via camera / gallery / PDF / URL; subsequent
/// pages can be appended ("Add page"), reordered or removed from the
/// preview strip. "Done → Parse" sends everything as one RPC so the
/// server feeds Claude a single multi-image request.
class AddMenuBottomSheet extends StatefulWidget {
  const AddMenuBottomSheet({super.key});

  @override
  State<AddMenuBottomSheet> createState() => _AddMenuBottomSheetState();
}

class _MenuPageDraft {
  final String fileName;
  final Uint8List bytes;
  final String? mediaType;

  const _MenuPageDraft({
    required this.fileName,
    required this.bytes,
    this.mediaType,
  });
}

class _AddMenuBottomSheetState extends State<AddMenuBottomSheet> {
  final _repo = getIt<RestaurantRepository>();
  final _appState = getIt<AppState>();
  final _picker = ImagePicker();

  final List<_MenuPageDraft> _pages = [];
  bool _processing = false;
  String? _error;

  // ─── Page sources ────────────────────────────────────────────────────────

  Future<void> _pickFromCamera() async {
    final x = await _picker.pickImage(source: ImageSource.camera);
    if (x == null) return;
    final bytes = await x.readAsBytes();
    setState(() {
      _pages.add(_MenuPageDraft(fileName: x.name, bytes: bytes));
    });
  }

  Future<void> _pickFromGallery() async {
    final x = await _picker.pickImage(source: ImageSource.gallery);
    if (x == null) return;
    final bytes = await x.readAsBytes();
    setState(() {
      _pages.add(_MenuPageDraft(fileName: x.name, bytes: bytes));
    });
  }

  Future<void> _pickPdf() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    final f = picked?.files.firstOrNull;
    if (f == null || f.bytes == null) return;
    setState(() {
      _pages.add(_MenuPageDraft(
        fileName: f.name,
        bytes: f.bytes!,
        mediaType: 'application/pdf',
      ));
    });
  }

  Future<void> _pickUrl() async {
    final url = await showDialog<String>(
      context: context,
      builder: (ctx) => _UrlDialog(),
    );
    if (url == null || url.isEmpty) return;
    setState(() {
      _pages.add(_MenuPageDraft(
        fileName: url,
        bytes: Uint8List(0),
      ));
    });
  }

  // ─── Upload ──────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (_pages.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _processing = true;
      _error = null;
    });
    try {
      final payload = _pages
          .map((p) => (
                fileName: p.fileName,
                bytes: p.bytes,
                mediaType: p.mediaType,
              ))
          .toList();
      final result = await _repo.processMultiPageMenu(payload);
      if (!mounted) return;

      await _appState.loadData();
      if (!mounted) return;

      if (result.requiresConfirmation && (result.candidates?.isNotEmpty ?? false)) {
        final merged = await showMatchConfirmationDialog(
          context: context,
          pendingRestaurantId: result.restaurantId,
          candidate: result.candidates!.first,
        );
        if (!mounted) return;
        Navigator.of(context).pop(merged ?? true);
      } else {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _processing = false;
        _error = l10n.errorUpload;
      });
    }
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.fromLTRB(AppSpacing.s20, AppSpacing.s10,
            AppSpacing.s20, AppSpacing.s24),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheet),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDragHandle(colors),
            const SizedBox(height: AppSpacing.s16),
            _buildHeader(context, l10n),
            const SizedBox(height: AppSpacing.s16),
            if (_processing)
              _buildProcessing(context, l10n)
            else if (_pages.isEmpty)
              _buildSourcePicker(context, l10n)
            else
              _buildPreviewAndActions(context, l10n),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.s14),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.error, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle(ColorScheme colors) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: colors.outline,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.addMenuEyebrow.toUpperCase(),
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 10,
            letterSpacing: 1.5,
            color: colors.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: serifFamily(l10n.addMenuTitlePlain),
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: colors.onSurface,
            ),
            children: [
              TextSpan(text: '${l10n.addMenuTitlePlain} '),
              TextSpan(
                text: l10n.addMenuTitleAccent,
                style: serifItalic(
                  text: l10n.addMenuTitleAccent,
                  size: 24,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.addMenuProcessingHint,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 11,
            color: colors.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessing(BuildContext context, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
      child: Column(
        children: [
          const SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: AppSpacing.s20),
          Text(
            l10n.addMenuProcessing,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourcePicker(BuildContext context, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Primary: camera, as full-width accent card
        InkWell(
          borderRadius: BorderRadius.circular(AppRadii.card),
          onTap: _pickFromCamera,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.s16),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(AppRadii.card),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                  child: const Icon(Icons.photo_camera,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: AppSpacing.s14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.addMenuPrimary,
                        style: TextStyle(
                          fontFamily: serifFamily(l10n.addMenuPrimary),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.addMenuProcessingHint,
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        // Secondary tiles: gallery / pdf / url
        Row(
          children: [
            Expanded(
              child: _SourceTile(
                icon: Icons.image_outlined,
                label: l10n.addMenuGallery,
                onTap: _pickFromGallery,
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: _SourceTile(
                icon: Icons.picture_as_pdf_outlined,
                label: l10n.addMenuPdf,
                onTap: _pickPdf,
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: _SourceTile(
                icon: Icons.link,
                label: l10n.addMenuLink,
                onTap: _pickUrl,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreviewAndActions(BuildContext context, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            itemCount: _pages.length,
            controller: PageController(viewportFraction: 0.9),
            itemBuilder: (_, i) {
              final page = _pages[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: page.bytes.isEmpty
                            ? const PhotoPlaceholder(
                                radius: AppRadii.lg, label: 'URL')
                            : Image.memory(page.bytes, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 8,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l10n.addMenuPageN(i + 1, _pages.length),
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 10,
                        child: Material(
                          color: Colors.black54,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () =>
                                setState(() => _pages.removeAt(i)),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.close,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.s14),
        GhostButton(
          label: l10n.addMenuAddPage,
          icon: Icons.add,
          onPressed: _pickFromCamera,
        ),
        const SizedBox(height: AppSpacing.s10),
        AccentButton(
          label: l10n.addMenuParse,
          icon: Icons.auto_awesome,
          onPressed: _submit,
        ),
        const SizedBox(height: AppSpacing.s4),
        Text(
          '${_pages.length} × ~${(_pages.fold<int>(0, (a, p) => a + p.bytes.length) / 1024 / 1024).toStringAsFixed(1)} MB',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 10,
            color: colors.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s10, vertical: AppSpacing.s16),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: colors.onSurface),
            const SizedBox(height: AppSpacing.s6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UrlDialog extends StatefulWidget {
  @override
  State<_UrlDialog> createState() => _UrlDialogState();
}

class _UrlDialogState extends State<_UrlDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(hintText: l10n.addMenuLink),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: Text(l10n.commonDone),
        ),
      ],
    );
  }
}
