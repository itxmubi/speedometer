import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/ads/banner_ad_widget.dart';
import '../../../../core/theme/app_metrics.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/speedometer_controller.dart';
import '../widgets/gauge_panel.dart';
import '../widgets/trip_controls.dart';
import '../widgets/trip_stats_panel.dart';

/// Responsive GPS dashboard with controls distinct from the live instruments.
class SpeedometerScreen extends ConsumerWidget {
  const SpeedometerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simpleView = ref.watch(
      speedometerControllerProvider.select(
        (state) => state.preferences.simpleView,
      ),
    );
    final leftHanded = ref.watch(
      speedometerControllerProvider.select((s) => s.preferences.leftHanded),
    );
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _confirmExit(context, l10n);
        if (shouldExit) {
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppMetrics.contentMaxWidth,
              ),
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  const _DashboardHeader(),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    l10n.dashboardTitle,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    l10n.dashboardSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton.icon(
                      onPressed: () => context.push(AppRoutes.focusedDisplay),
                      icon: const Icon(Icons.fullscreen_rounded),
                      label: Text(l10n.focusedDisplay),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide =
                          constraints.maxWidth >= AppMetrics.wideBreakpoint;
                      const instrument = Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GaugePanel(),
                          SizedBox(height: AppSpacing.lg),
                          TripControls(),
                        ],
                      );
                      if (wide && !simpleView) {
                        final sections = <Widget>[
                          const Expanded(child: instrument),
                          const SizedBox(width: AppSpacing.lg),
                          const Expanded(child: TripStatsPanel()),
                        ];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textDirection: TextDirection.ltr,
                          children: leftHanded
                              ? sections
                              : sections.reversed.toList(),
                        );
                      }
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: AppMetrics.compactMaxWidth,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              instrument,
                              if (!simpleView) ...[
                                const SizedBox(height: AppSpacing.xl),
                                const TripStatsPanel(),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _PrivacyFooter(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const BannerAdWidget(),
      ),
    );
  }

  Future<bool> _confirmExit(BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.exitAppTitle),
        content: Text(l10n.exitAppMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.no),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(AppRadii.small),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Icon(
              Icons.speed_rounded,
              color: theme.colorScheme.onPrimary,
              size: AppMetrics.heroIconSize,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.appTitle, style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                l10n.appTagline,
                style: AppTypography.eyebrow.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: l10n.tripHistory,
          onPressed: () => context.push(AppRoutes.history),
          icon: const Icon(Icons.history_rounded),
        ),
        IconButton.filledTonal(
          tooltip: l10n.settings,
          onPressed: () => context.push(AppRoutes.settings),
          icon: const Icon(Icons.tune_rounded),
        ),
      ],
    );
  }
}

class _PrivacyFooter extends StatelessWidget {
  const _PrivacyFooter();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      children: [
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.shield_outlined,
              color: theme.colorScheme.onSurfaceVariant,
              size: AppMetrics.smallIconSize,
            ),
            Text(
              l10n.privacyFooter,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.safeDriving,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
