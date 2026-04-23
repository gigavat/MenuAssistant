import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Modal sheet used by AddMenu and MatchConfirmation. 28px top corners,
/// a 40×4 drag handle in `colors.outline`, inner padding matching the
/// prototype (24/20).
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: isScrollControlled,
    useRootNavigator: true,
    builder: (ctx) => AppBottomSheet(child: builder(ctx)),
  );
}

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheet),
          ),
          boxShadow: AppShadows.card,
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s20,
          AppSpacing.s10,
          AppSpacing.s20,
          AppSpacing.s24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.s16),
              decoration: BoxDecoration(
                color: colors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
