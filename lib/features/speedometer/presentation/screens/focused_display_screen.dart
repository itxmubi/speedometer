import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../providers/speedometer_controller.dart';
import '../widgets/gauge_panel.dart';
import '../widgets/gps_status_badge.dart';
import '../widgets/trip_controls.dart';

/// An uncluttered instrument with persistent controls outside the scrolling gauge.
class FocusedDisplayScreen extends ConsumerWidget {
  const FocusedDisplayScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(
      speedometerControllerProvider.select((s) => s.preferences),
    );
    final l10n = AppLocalizations.of(context);
    final theme = preferences.nightHud
        ? AppTheme.forPreferences(
            dark: true,
            accentIndex: preferences.accentColorIndex,
            nightHud: true,
          )
        : Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          leading: IconButton(
            tooltip: l10n.exitFocusedDisplay,
            onPressed: () => context.canPop()
                ? context.pop()
                : context.go(AppRoutes.dashboard),
            icon: const Icon(Icons.fullscreen_exit_rounded),
          ),
          title: const GpsStatusBadge(),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: GaugePanel(focused: true),
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: const SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: TripControls(compact: true),
          ),
        ),
      ),
    );
  }
}
