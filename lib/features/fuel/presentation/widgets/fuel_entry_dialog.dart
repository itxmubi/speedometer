import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_kind.dart';
import '../../domain/entities/fuel_distance_unit.dart';
import '../../domain/entities/fuel_entry.dart';
import '../../domain/entities/fuel_volume_unit.dart';
import '../providers/fuel_providers.dart';
import 'fuel_format.dart';

/// Localized entry boundary; business validation is performed by the use case.
class FuelEntryDialog extends ConsumerStatefulWidget {
  const FuelEntryDialog({required this.distanceUnit, this.entry, super.key});

  final FuelDistanceUnit distanceUnit;
  final FuelEntry? entry;

  @override
  ConsumerState<FuelEntryDialog> createState() => _FuelEntryDialogState();
}

class _FuelEntryDialogState extends ConsumerState<FuelEntryDialog> {
  final _distance = TextEditingController();
  final _volume = TextEditingController();
  final _fuelCost = TextEditingController();
  final _otherCost = TextEditingController();
  final _currency = TextEditingController();
  final _note = TextEditingController();
  late DateTime _date;
  late FuelDistanceUnit _distanceUnit;
  var _volumeUnit = FuelVolumeUnit.liters;
  var _initialized = false;
  var _invalid = false;

  @override
  void initState() {
    super.initState();
    _date = widget.entry?.occurredAt.toLocal() ?? ref.read(fuelNowProvider)();
    _distanceUnit = widget.distanceUnit;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final l10n = AppLocalizations.of(context);
    final entry = widget.entry;
    if (entry != null) {
      _distance.text = FuelFormat.inputNumber(
        _distanceUnit.fromMeters(entry.distanceMeters),
        l10n,
      );
      _volume.text = FuelFormat.inputNumber(entry.fuelLiters, l10n);
      _fuelCost.text = FuelFormat.inputNumber(entry.fuelCost, l10n);
      _otherCost.text = FuelFormat.inputNumber(entry.otherCost, l10n);
      _currency.text = entry.currencyCode;
      _note.text = entry.note;
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _distance,
      _volume,
      _fuelCost,
      _otherCost,
      _currency,
      _note,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final entry = FuelEntry(
      id: widget.entry?.id,
      occurredAt: _date,
      distanceMeters: _distanceUnit.toMeters(
        FuelFormat.parse(_distance.text, l10n),
      ),
      fuelLiters: _volumeUnit.toLiters(FuelFormat.parse(_volume.text, l10n)),
      fuelCost: FuelFormat.parse(_fuelCost.text, l10n),
      otherCost: FuelFormat.parse(_otherCost.text, l10n),
      currencyCode: _currency.text.trim().toUpperCase(),
      note: _note.text.trim(),
    );
    final saved = await ref
        .read(fuelActionControllerProvider.notifier)
        .save(entry);
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _invalid = true);
    }
  }

  Future<void> _chooseDate() async {
    final today = ref.read(fuelNowProvider)();
    final firstDate = DateTime(1970);
    final initialDate = _date.isBefore(firstDate)
        ? firstDate
        : _date.isAfter(today)
        ? today
        : _date;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: today,
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final action = ref.watch(fuelActionControllerProvider);
    return AlertDialog(
      title: Text(
        widget.entry == null ? l10n.fuelAddEntry : l10n.fuelEditEntry,
      ),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            onPressed: action.isLoading ? null : _chooseDate,
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(
              l10n.measurementValue(
                l10n.fuelEntryDate,
                FuelFormat.date(_date, l10n),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<FuelDistanceUnit>(
            isExpanded: true,
            initialValue: _distanceUnit,
            decoration: InputDecoration(labelText: l10n.fuelDistanceUnit),
            items: [
              for (final unit in FuelDistanceUnit.values)
                DropdownMenuItem(
                  value: unit,
                  child: Text(
                    FuelFormat.distanceUnit(unit, l10n),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: action.isLoading
                ? null
                : (value) {
                    if (value == null) return;
                    final meters = _distanceUnit.toMeters(
                      FuelFormat.parse(_distance.text, l10n),
                    );
                    setState(() {
                      _distanceUnit = value;
                      if (meters.isFinite) {
                        _distance.text = FuelFormat.inputNumber(
                          value.fromMeters(meters),
                          l10n,
                        );
                      }
                    });
                  },
          ),
          _NumberField(
            controller: _distance,
            label: l10n.measurementValue(
              l10n.fuelDistance,
              FuelFormat.distanceUnit(_distanceUnit, l10n),
            ),
            enabled: !action.isLoading,
          ),
          DropdownButtonFormField<FuelVolumeUnit>(
            isExpanded: true,
            initialValue: _volumeUnit,
            decoration: InputDecoration(labelText: l10n.fuelVolumeUnit),
            items: [
              for (final unit in FuelVolumeUnit.values)
                DropdownMenuItem(
                  value: unit,
                  child: Text(
                    FuelFormat.volumeUnit(unit, l10n),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: action.isLoading
                ? null
                : (value) {
                    if (value == null) return;
                    final liters = _volumeUnit.toLiters(
                      FuelFormat.parse(_volume.text, l10n),
                    );
                    setState(() {
                      _volumeUnit = value;
                      if (liters.isFinite) {
                        _volume.text = FuelFormat.inputNumber(
                          value.fromLiters(liters),
                          l10n,
                        );
                      }
                    });
                  },
          ),
          _NumberField(
            controller: _volume,
            label: l10n.measurementValue(
              l10n.fuelVolume,
              FuelFormat.volumeUnit(_volumeUnit, l10n),
            ),
            enabled: !action.isLoading,
          ),
          TextField(
            controller: _currency,
            enabled: !action.isLoading,
            textCapitalization: TextCapitalization.characters,
            maxLength: 3,
            decoration: InputDecoration(
              labelText: l10n.fuelCurrency,
              helperText: l10n.fuelCurrencyHint,
            ),
          ),
          _NumberField(
            controller: _fuelCost,
            label: l10n.fuelCost,
            enabled: !action.isLoading,
          ),
          _NumberField(
            controller: _otherCost,
            label: l10n.fuelOtherCost,
            enabled: !action.isLoading,
          ),
          TextField(
            controller: _note,
            enabled: !action.isLoading,
            maxLength: 500,
            decoration: InputDecoration(labelText: l10n.fuelNote),
          ),
          if (_invalid)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(switch (action.error) {
                Failure(kind: FailureKind.storage) => l10n.failureStorage,
                _ => l10n.fuelValidation,
              }, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: action.isLoading
              ? null
              : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: action.isLoading ? null : _save,
          child: action.isLoading
              ? const CircularProgressIndicator()
              : Text(l10n.fuelSaveEntry),
        ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    required this.enabled,
  });
  final TextEditingController controller;
  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
    ),
  );
}
