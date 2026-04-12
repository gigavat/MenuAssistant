import 'package:flutter/material.dart';
import '../core/service_locator.dart';
import '../repositories/restaurant_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class AddMenuBottomSheet extends StatelessWidget {
  const AddMenuBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Добавить меню',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAddOption(
                context,
                icon: Icons.camera_alt_outlined,
                label: 'Снимок',
                onTap: () async {
                  final picker = ImagePicker();
                  final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    final bytes = await photo.readAsBytes();
                    if (context.mounted) {
                      await _processFile(context, photo.name, bytes);
                    }
                  }
                },
              ),
              _buildAddOption(
                context,
                icon: Icons.image_outlined,
                label: 'Фото',
                onTap: () async {
                  final picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    final bytes = await image.readAsBytes();
                    if (context.mounted) {
                      await _processFile(context, image.name, bytes);
                    }
                  }
                },
              ),
              _buildAddOption(
                context,
                icon: Icons.description_outlined,
                label: 'Документ',
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
                    withData: true,
                  );
                  if (result != null && result.files.single.bytes != null && context.mounted) {
                     var file = result.files.single;
                     await _processFile(context, file.name, file.bytes!);
                  }
                },
              ),
              _buildAddOption(
                context,
                icon: Icons.link,
                label: 'Ссылка',
                onTap: () async {
                  final result = await _showLinkDialog(context);
                  if (result == true) {
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAddOption(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showLinkDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        final textController = TextEditingController();
        return AlertDialog(
          title: const Text('Ввод ссылки'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'https://...',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Отмена'),
            ),
              ElevatedButton(
                onPressed: () async {
                  final url = textController.text;
                  if (url.isEmpty) return;

                  await _processFile(ctx, url, []);
                },
                child: const Text('Добавить'),
              ),
          ],
        );
      },
    );
  }

  Future<void> _processFile(BuildContext context, String fileName, List<int> bytes) async {
    final repo = getIt<RestaurantRepository>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await repo.processMenuUpload(fileName, bytes);

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        Navigator.pop(context, true); // Close bottom sheet / link dialog
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }
}
