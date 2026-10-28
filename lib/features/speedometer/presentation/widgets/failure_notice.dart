import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/error/failure_kind.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/speedometer_controller.dart';

/// Localized recovery guidance for expected tracking and preference failures.
class FailureNotice extends ConsumerWidget {
  const FailureNotice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kind = ref.watch(
      speedometerControllerProvider.select((state) => state.failure?.kind),
    );
    if (kind == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final message = switch (kind) {
      FailureKind.permissionDenied => l10n.failurePermissionDenied,
      FailureKind.permissionDeniedForever =>
        l10n.failurePermissionDeniedForever,
      FailureKind.locationDisabled => l10n.failureLocationDisabled,
      FailureKind.locationUnavailable => l10n.failureLocationUnavailable,
      FailureKind.unsupported => l10n.failureUnsupported,
      FailureKind.storage => l10n.failureStorage,
      FailureKind.unexpected => l10n.failureUnexpected,
    };
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Card(
          color: theme.colorScheme.errorContainer,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.xs,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xs,
                        ),
                        child: Text(
                          message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.dismissError,
                      color: theme.colorScheme.onErrorContainer,
                      onPressed: () {
                        ref
                            .read(speedometerControllerProvider.notifier)
                            .clearFailure();
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                if (kind == FailureKind.permissionDeniedForever)
                  TextButton(
                    onPressed: () {
                      ref
                          .read(speedometerControllerProvider.notifier)
                          .openAppSettings();
                    },
                    child: Text(l10n.openAppSettings),
                  ),
                if (kind == FailureKind.locationDisabled)
                  TextButton(
                    onPressed: () {
                      ref
                          .read(speedometerControllerProvider.notifier)
                          .openLocationSettings();
                    },
                    child: Text(l10n.openLocationSettings),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
