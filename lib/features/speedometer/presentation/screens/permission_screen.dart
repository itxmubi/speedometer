import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_metrics.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/speedometer_controller.dart';
import '../widgets/failure_notice.dart';

/// Explains foreground location use before any operating-system permission.
class PermissionScreen extends ConsumerStatefulWidget {
  const PermissionScreen({super.key});

  @override
  ConsumerState<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends ConsumerState<PermissionScreen> {
  bool _continuing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppMetrics.compactMaxWidth,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(AppRadii.medium),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Icon(
                          Icons.explore_outlined,
                          size: AppMetrics.introIconSize,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    l10n.permissionEyebrow,
                    style: AppTypography.eyebrow.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.permissionTitle,
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.permissionDescription,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _DisclosureCard(
                    icon: Icons.my_location_rounded,
                    title: l10n.permissionLocationTitle,
                    body: l10n.permissionLocationBody,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _DisclosureCard(
                    icon: Icons.shield_outlined,
                    title: l10n.permissionOfflineTitle,
                    body: l10n.permissionOfflineBody,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _DisclosureCard(
                    icon: Icons.touch_app_outlined,
                    title: l10n.permissionControlTitle,
                    body: l10n.permissionControlBody,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const FailureNotice(),
                  FilledButton.icon(
                    onPressed: _continuing ? null : _continue,
                    icon: _continuing
                        ? const SizedBox.square(
                            dimension: AppSpacing.lg,
                            child: CircularProgressIndicator(
                              strokeWidth: AppMetrics.gaugeTickStroke,
                            ),
                          )
                        : const Icon(Icons.arrow_forward_rounded),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      child: Text(l10n.permissionContinue),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.permissionRequestHint,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    l10n.safeDriving,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _continue() async {
    setState(() => _continuing = true);
    await ref.read(speedometerControllerProvider.notifier).acceptDisclosure();
    if (mounted) setState(() => _continuing = false);
  }
}

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
