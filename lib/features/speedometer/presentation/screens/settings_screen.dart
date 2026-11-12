import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_metrics.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../activities/domain/entities/activity_mode.dart';
import '../../../activities/domain/usecases/estimate_activity_calories_use_case.dart';
import '../../domain/entities/display_preferences.dart';
import '../providers/speedometer_controller.dart';
import '../providers/tracking_status.dart';
import '../widgets/activity_mode_label.dart';
import '../widgets/failure_notice.dart';
import '../widgets/gauge_mode_control.dart';
import '../widgets/speedometer_format.dart';
import '../widgets/unit_selector.dart';

/// Local preferences, explicit permissions and controls over recorded data.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int? _section;
  final _scroll = ScrollController();
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sections = [
      l10n.activitySettings,
      l10n.displaySettings,
      l10n.hudContent,
      l10n.warningSettings,
      l10n.trackingSettings,
      l10n.overlaySettings,
      l10n.backupSettings,
      l10n.fuelCosts,
      l10n.privacySettings,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(_section == null ? l10n.settings : sections[_section ?? 0]),
        actions: [
          PopupMenuButton<int>(
            tooltip: l10n.settingsSections,
            icon: const Icon(Icons.segment_rounded),
            onSelected: (value) {
              setState(() => _section = value < 0 ? null : value);
              if (_scroll.hasClients) _scroll.jumpTo(0);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: -1, child: Text(l10n.allSettings)),
              for (var i = 0; i < sections.length; i++)
                PopupMenuItem(value: i, child: Text(sections[i])),
            ],
          ),
        ],
        leading: IconButton(
          tooltip: l10n.backToDashboard,
          onPressed: () => context.go(AppRoutes.dashboard),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppMetrics.compactMaxWidth,
          ),
          child: ListView(
            controller: _scroll,
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const FailureNotice(),
              if (_section == null || _section == 0) const _ActivitySettings(),
              if (_section == null) const SizedBox(height: AppSpacing.xl),
              if (_section == null || _section == 1) const _DisplaySettings(),
              if (_section == null) const SizedBox(height: AppSpacing.xl),
              if (_section == null || _section == 2) const _HudSettings(),
              if (_section == null) const SizedBox(height: AppSpacing.xl),
              if (_section == null || _section == 3) const _WarningSettings(),
              if (_section == null) const SizedBox(height: AppSpacing.xl),
              if (_section == null || _section == 4) const _TrackingSettings(),
              if (_section == null) const SizedBox(height: AppSpacing.xl),
              if (_section == null || _section == 5) const _OverlaySettings(),
              if (_section == null) const SizedBox(height: AppSpacing.xl),
              if (_section == null || _section == 6) const _DataSettings(),
              if (_section == null) const SizedBox(height: AppSpacing.xl),
              if (_section == null || _section == 7)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.local_gas_station_outlined),
                    title: Text(l10n.fuelCosts),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(AppRoutes.fuel),
                  ),
                ),
              if (_section == null) const SizedBox(height: AppSpacing.xl),
              if (_section == null || _section == 8)
                _SettingsSection(
                  title: l10n.privacySettings,
                  subtitle: l10n.privacySettingsDescription,
                  children: [
                    Text(l10n.foregroundDisclosure),
                    const Divider(),
                    Text(l10n.precisionDisclaimer),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.policy_outlined),
                      title: Text(l10n.privacyPolicy),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push(AppRoutes.privacyPolicy),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.description_outlined),
                      title: Text(l10n.termsAndConditions),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push(AppRoutes.termsAndConditions),
                    ),
                  ],
                ),
              if (_section == null) const SizedBox(height: AppSpacing.xl),
              Text(l10n.safeDriving, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivitySettings extends ConsumerWidget {
  const _ActivitySettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final (preferences, locked) = ref.watch(
      speedometerControllerProvider.select(
        (state) => (
          state.preferences,
          state.activeTripId != null ||
              state.isBusy ||
              state.isLoadingPreferences ||
              state.status == TrackingStatus.starting,
        ),
      ),
    );
    final controller = ref.read(speedometerControllerProvider.notifier);
    final weight = preferences.bodyWeightKilograms;
    return _SettingsSection(
      title: l10n.activitySettings,
      subtitle: l10n.activityDescription,
      children: [
        DropdownButtonFormField<ActivityMode>(
          key: ValueKey(preferences.activityMode),
          initialValue: preferences.activityMode,
          decoration: InputDecoration(labelText: l10n.activityMode),
          isExpanded: true,
          items: [
            for (final mode in ActivityMode.values)
              DropdownMenuItem(
                value: mode,
                child: Text(ActivityModeLabel.text(mode, l10n)),
              ),
          ],
          onChanged: locked
              ? null
              : (mode) async {
                  if (mode != null) await controller.setActivityMode(mode);
                },
        ),
        if (locked) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.activityLocked),
        ],
        const SizedBox(height: AppSpacing.sm),
        _PreferenceToggle(
          title: l10n.bodyWeightEnabled,
          subtitle: l10n.bodyWeightEnabledDescription,
          value: weight != null,
          onChanged: locked
              ? null
              : (enabled) => controller.setBodyWeight(enabled ? 70 : null),
        ),
        if (weight != null)
          _PreferenceSlider(
            title: l10n.bodyWeight,
            subtitle: l10n.bodyWeightDescription,
            value: weight,
            min: EstimateActivityCaloriesUseCase.minimumWeightKilograms,
            max: EstimateActivityCaloriesUseCase.maximumWeightKilograms,
            enabled: !locked,
            format: (value) => l10n.measurementValue(
              SpeedometerFormat.number(value, l10n, decimals: 1),
              l10n.kilograms,
            ),
            onChanged: controller.setBodyWeight,
          ),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.calorieEstimateDescription),
      ],
    );
  }
}

class _DisplaySettings extends ConsumerWidget {
  const _DisplaySettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final preferences = ref.watch(
      speedometerControllerProvider.select((s) => s.preferences),
    );
    final controller = ref.read(speedometerControllerProvider.notifier);
    return _SettingsSection(
      title: l10n.displaySettings,
      subtitle: l10n.displaySettingsDescription,
      children: [
        const GaugeModeControl(),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [Text(l10n.speedUnit), const UnitSelector()],
        ),
        _PreferenceToggle(
          title: l10n.simpleView,
          subtitle: l10n.simpleViewSubtitle,
          value: preferences.simpleView,
          onChanged: controller.setSimpleView,
        ),
        _PreferenceToggle(
          title: l10n.darkMode,
          subtitle: l10n.darkModeSubtitle,
          value: preferences.darkMode,
          onChanged: controller.setDarkMode,
        ),
        _PreferenceToggle(
          title: l10n.leftHanded,
          subtitle: l10n.leftHandedDescription,
          value: preferences.leftHanded,
          onChanged: controller.setLeftHanded,
        ),
        _PreferenceToggle(
          title: l10n.keepAwake,
          subtitle: l10n.keepAwakeDescription,
          value: preferences.keepAwake,
          onChanged: controller.setKeepAwake,
        ),
        const Divider(),
        const _BrightnessSetting(),
        const Divider(),
        const _ColorSetting(),
        const SizedBox(height: AppSpacing.md),
        const _GaugeRangeSetting(),
        const Divider(),
        const _LanguageSetting(),
      ],
    );
  }
}

class _BrightnessSetting extends ConsumerWidget {
  const _BrightnessSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final brightness = ref.watch(
      speedometerControllerProvider.select((s) => s.preferences.brightness),
    );
    final controller = ref.read(speedometerControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PreferenceToggle(
          title: l10n.systemBrightness,
          subtitle: l10n.brightnessDescription,
          value: brightness == -1,
          onChanged: (system) => controller.setBrightness(system ? -1 : 0.7),
        ),
        if (brightness != -1)
          _PreferenceSlider(
            title: l10n.brightness,
            value: brightness,
            min: 0.05,
            max: 1,
            format: (value) =>
                NumberFormat.percentPattern(l10n.localeName).format(value),
            onChanged: controller.setBrightness,
          ),
      ],
    );
  }
}

class _ColorSetting extends ConsumerWidget {
  const _ColorSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(
      speedometerControllerProvider.select(
        (s) => s.preferences.accentColorIndex,
      ),
    );
    final labels = [
      l10n.colorLime,
      l10n.colorBlue,
      l10n.colorCyan,
      l10n.colorAmber,
      l10n.colorRose,
      l10n.colorLavender,
      l10n.colorMint,
      l10n.colorOrange,
      l10n.colorWhite,
      l10n.colorPink,
    ];
    return DropdownButtonFormField<int>(
      initialValue: selected,
      decoration: InputDecoration(labelText: l10n.accentColor),
      isExpanded: true,
      items: [
        for (var i = 0; i < labels.length; i++)
          DropdownMenuItem(value: i, child: Text(labels[i])),
      ],
      onChanged: (value) {
        if (value != null) {
          ref
              .read(speedometerControllerProvider.notifier)
              .setAccentColorIndex(value);
        }
      },
    );
  }
}

class _GaugeRangeSetting extends ConsumerWidget {
  const _GaugeRangeSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final preferences = ref.watch(
      speedometerControllerProvider.select((s) => s.preferences),
    );
    final unit = SpeedometerFormat.unit(preferences.unit, l10n);
    return _PreferenceSlider(
      title: l10n.gaugeRange,
      value: preferences.unit.fromMetersPerSecond(
        preferences.gaugeRangeMetersPerSecond,
      ),
      min: preferences.unit.fromMetersPerSecond(
        DisplayPreferences.minimumGaugeRangeMetersPerSecond,
      ),
      max: preferences.unit.fromMetersPerSecond(
        DisplayPreferences.maximumSpeedLimitMetersPerSecond,
      ),
      format: (value) =>
          l10n.measurementValue(SpeedometerFormat.number(value, l10n), unit),
      onChanged: ref.read(speedometerControllerProvider.notifier).setGaugeRange,
    );
  }
}

class _LanguageSetting extends ConsumerWidget {
  const _LanguageSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final language = ref.watch(
      speedometerControllerProvider.select((s) => s.preferences.localeCode),
    );
    return DropdownButtonFormField<String>(
      initialValue: language ?? '',
      decoration: InputDecoration(labelText: l10n.language),
      isExpanded: true,
      items: [
        DropdownMenuItem(value: '', child: Text(l10n.systemLanguage)),
        DropdownMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
        DropdownMenuItem(value: 'es', child: Text(l10n.languageSpanish)),
        DropdownMenuItem(value: 'fr', child: Text(l10n.languageFrench)),
        DropdownMenuItem(value: 'de', child: Text(l10n.languageGerman)),
        DropdownMenuItem(value: 'ar', child: Text(l10n.languageArabic)),
      ],
      onChanged: (value) => ref
          .read(speedometerControllerProvider.notifier)
          .setLocaleCode(value == '' ? null : value),
    );
  }
}

class _HudSettings extends ConsumerWidget {
  const _HudSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = ref.watch(
      speedometerControllerProvider.select((s) => s.preferences),
    );
    final controller = ref.read(speedometerControllerProvider.notifier);
    return _SettingsSection(
      title: l10n.hudContent,
      subtitle: l10n.hudHint,
      children: [
        _PreferenceToggle(
          title: l10n.mirrorHud,
          subtitle: l10n.mirrorHudSubtitle,
          value: p.mirroredHud,
          onChanged: controller.setMirrored,
        ),
        _PreferenceToggle(
          title: l10n.nightHud,
          subtitle: l10n.nightHudDescription,
          value: p.nightHud,
          onChanged: controller.setNightHud,
        ),
        _PreferenceToggle(
          title: l10n.hudTime,
          value: p.hudShowTime,
          onChanged: (value) => controller.setHudContent(showTime: value),
        ),
        _PreferenceToggle(
          title: l10n.hudCompass,
          value: p.hudShowCompass,
          onChanged: (value) => controller.setHudContent(showCompass: value),
        ),
        _PreferenceToggle(
          title: l10n.hudTrip,
          value: p.hudShowTrip,
          onChanged: (value) => controller.setHudContent(showTrip: value),
        ),
      ],
    );
  }
}

class _WarningSettings extends ConsumerWidget {
  const _WarningSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = ref.watch(
      speedometerControllerProvider.select((s) => s.preferences),
    );
    final controller = ref.read(speedometerControllerProvider.notifier);
    final unit = SpeedometerFormat.unit(p.unit, l10n);
    return _SettingsSection(
      title: l10n.warningSettings,
      subtitle: l10n.warningSettingsDescription,
      children: [
        _PreferenceToggle(
          title: l10n.enableWarning,
          subtitle: l10n.enableWarningSubtitle,
          value: p.limitEnabled,
          onChanged: controller.setLimitEnabled,
        ),
        const _SpeedLimitControl(),
        _PreferenceSlider(
          title: l10n.alertOffset,
          subtitle: l10n.alertOffsetDescription,
          value: p.unit.fromMetersPerSecond(p.alertOffsetMetersPerSecond),
          min: 0,
          max: p.unit.fromMetersPerSecond(
            DisplayPreferences.maximumSpeedLimitMetersPerSecond,
          ),
          format: (value) => l10n.measurementValue(
            SpeedometerFormat.number(value, l10n),
            unit,
          ),
          onChanged: controller.setAlertOffset,
        ),
        _PreferenceToggle(
          title: l10n.soundAlert,
          value: p.soundAlert,
          onChanged: controller.setSoundAlert,
        ),
        _PreferenceToggle(
          title: l10n.vibrationAlert,
          value: p.vibrationAlert,
          onChanged: controller.setVibrationAlert,
        ),
        _PreferenceToggle(
          title: l10n.voiceAlert,
          value: p.voiceAlert,
          onChanged: controller.setVoiceAlert,
        ),
        _PreferenceSlider(
          title: l10n.alertVolume,
          value: p.alertVolume,
          min: 0,
          max: 1,
          format: (value) =>
              NumberFormat.percentPattern(l10n.localeName).format(value),
          onChanged: controller.setAlertVolume,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.warningScope, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _TrackingSettings extends ConsumerWidget {
  const _TrackingSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = ref.watch(
      speedometerControllerProvider.select((s) => s.preferences),
    );
    final controller = ref.read(speedometerControllerProvider.notifier);
    return _SettingsSection(
      title: l10n.trackingSettings,
      children: [
        _PreferenceToggle(
          title: l10n.autoRecordTrips,
          subtitle: l10n.autoRecordTripsDescription,
          value: p.autoRecordTrips,
          onChanged: controller.setAutoRecordTrips,
        ),
        _PreferenceToggle(
          title: l10n.recordRoute,
          subtitle: l10n.recordRouteDescription,
          value: p.recordRoute,
          onChanged: controller.setRecordRoute,
        ),
        _PreferenceToggle(
          title: l10n.backgroundTracking,
          subtitle: l10n.backgroundTrackingDescription,
          value: p.backgroundTracking,
          onChanged: controller.setBackgroundTracking,
        ),
        _PreferenceToggle(
          title: l10n.economyGps,
          subtitle: l10n.economyGpsDescription,
          value: p.economyGps,
          onChanged: controller.setEconomyGps,
        ),
        const Divider(),
        _PreferenceSlider(
          title: l10n.calibration,
          subtitle: l10n.calibrationDescription,
          value: p.calibrationFactor,
          min: 0.5,
          max: 1.5,
          format: (value) => SpeedometerFormat.number(value, l10n, decimals: 2),
          onChanged: controller.setCalibrationFactor,
        ),
      ],
    );
  }
}

class _OverlaySettings extends ConsumerWidget {
  const _OverlaySettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final (enabled, permissionRequired) = ref.watch(
      speedometerControllerProvider.select(
        (s) => (s.overlayEnabled, s.overlayPermissionRequired),
      ),
    );
    final controller = ref.read(speedometerControllerProvider.notifier);
    return _SettingsSection(
      title: l10n.overlaySettings,
      subtitle: l10n.overlayDescription,
      children: [
        OutlinedButton.icon(
          icon: Icon(
            enabled
                ? Icons.close_fullscreen_rounded
                : Icons.open_in_new_rounded,
          ),
          label: Text(enabled ? l10n.disableOverlay : l10n.enableOverlay),
          onPressed: enabled
              ? controller.disableOverlay
              : () async {
                  final accepted = await _confirm(
                    context,
                    title: l10n.overlayPermissionTitle,
                    message: l10n.overlayPermissionBody,
                    action: l10n.continueAction,
                  );
                  if (accepted && context.mounted) {
                    await controller.enableOverlay();
                  }
                },
        ),
        if (permissionRequired) ...[
          const SizedBox(height: AppSpacing.sm),
          FilledButton.tonal(
            onPressed: controller.openOverlaySettings,
            child: Text(l10n.openOverlaySettings),
          ),
        ],
      ],
    );
  }
}

class _DataSettings extends ConsumerWidget {
  const _DataSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final (busy, activeTrip) = ref.watch(
      speedometerControllerProvider.select(
        (s) => (s.isBusy, s.activeTripId != null),
      ),
    );
    final controller = ref.read(speedometerControllerProvider.notifier);
    return _SettingsSection(
      title: l10n.backupSettings,
      subtitle: l10n.backupDescription,
      children: [
        if (busy) const LinearProgressIndicator(),
        OutlinedButton.icon(
          onPressed: busy ? null : controller.exportBackup,
          icon: const Icon(Icons.save_alt_rounded),
          label: Text(l10n.exportBackup),
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: busy
              ? null
              : () async {
                  final accepted = await _confirm(
                    context,
                    title: l10n.restoreBackupTitle,
                    message: l10n.restoreBackupMessage,
                    action: l10n.restoreBackup,
                  );
                  if (accepted && context.mounted) {
                    await controller.restoreBackup();
                  }
                },
          icon: const Icon(Icons.restore_rounded),
          label: Text(l10n.restoreBackup),
        ),
        const Divider(),
        TextButton(
          onPressed: busy || activeTrip
              ? null
              : () async {
                  final accepted = await _confirm(
                    context,
                    title: l10n.resetPreferencesTitle,
                    message: l10n.resetPreferencesMessage,
                    action: l10n.reset,
                  );
                  if (accepted && context.mounted) {
                    await controller.resetPreferences();
                  }
                },
          child: Text(l10n.resetPreferences),
        ),
        if (activeTrip) Text(l10n.activityLocked),
        TextButton.icon(
          onPressed: busy
              ? null
              : () async {
                  final accepted = await _confirm(
                    context,
                    title: l10n.deleteAllDataTitle,
                    message: l10n.deleteAllDataMessage,
                    action: l10n.deleteAction,
                  );
                  if (accepted && context.mounted) {
                    await controller.deleteAllData();
                  }
                },
          icon: const Icon(Icons.delete_forever_rounded),
          label: Text(l10n.deleteAllData),
        ),
      ],
    );
  }
}

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String message,
  required String action,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(message)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(action),
          ),
        ],
      ),
    ) ??
    false;

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      if (subtitle case final subtitle?) ...[
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
      const SizedBox(height: AppSpacing.md),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    ],
  );
}

class _PreferenceToggle extends StatelessWidget {
  const _PreferenceToggle({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });
  final String title;
  final String? subtitle;
  final bool value;
  final Future<void> Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title),
    subtitle: subtitle == null ? null : Text(subtitle ?? ''),
    value: value,
    onChanged: onChanged,
  );
}

class _PreferenceSlider extends StatefulWidget {
  const _PreferenceSlider({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.format,
    required this.onChanged,
    this.subtitle,
    this.enabled = true,
  });
  final String title;
  final String? subtitle;
  final bool enabled;
  final double value;
  final double min;
  final double max;
  final String Function(double) format;
  final Future<void> Function(double) onChanged;

  @override
  State<_PreferenceSlider> createState() => _PreferenceSliderState();
}

class _PreferenceSliderState extends State<_PreferenceSlider> {
  double? _preview;

  @override
  void didUpdateWidget(covariant _PreferenceSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.min != widget.min ||
        oldWidget.max != widget.max) {
      _preview = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = (_preview ?? widget.value).clamp(widget.min, widget.max);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: AppSpacing.sm,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleSmall),
            Text(widget.format(value)),
          ],
        ),
        if (widget.subtitle case final subtitle?)
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        Slider(
          value: value,
          min: widget.min,
          max: widget.max,
          label: widget.format(value),
          semanticFormatterCallback: widget.format,
          onChanged: widget.enabled
              ? (value) => setState(() => _preview = value)
              : null,
          onChangeEnd: !widget.enabled
              ? null
              : (value) async {
                  await widget.onChanged(value);
                  if (mounted) setState(() => _preview = null);
                },
        ),
      ],
    );
  }
}

class _SpeedLimitControl extends ConsumerWidget {
  const _SpeedLimitControl();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = ref.watch(
      speedometerControllerProvider.select((s) => s.preferences),
    );
    final unit = SpeedometerFormat.unit(p.unit, l10n);
    return _PreferenceSlider(
      title: l10n.speedLimit,
      value: p.unit.fromMetersPerSecond(p.speedLimitMetersPerSecond),
      min: p.unit.fromMetersPerSecond(
        DisplayPreferences.minimumGaugeRangeMetersPerSecond,
      ),
      max: p.unit.fromMetersPerSecond(
        DisplayPreferences.maximumSpeedLimitMetersPerSecond,
      ),
      format: (value) =>
          l10n.measurementValue(SpeedometerFormat.number(value, l10n), unit),
      onChanged: ref.read(speedometerControllerProvider.notifier).setSpeedLimit,
    );
  }
}
