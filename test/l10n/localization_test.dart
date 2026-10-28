import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

void main() {
  final english = _readArb('en');
  final messageKeys = english.keys.where((key) => !key.startsWith('@')).toSet();
  final expectedDashboards = {
    'en': 'Live dashboard',
    'es': 'Panel en directo',
    'fr': 'Tableau de bord en direct',
    'de': 'Live-Anzeige',
    'ar': 'لوحة القيادة المباشرة',
  };

  test('advertises exactly the five fully translated languages', () {
    expect(
      AppLocalizations.supportedLocales
          .map((locale) => locale.languageCode)
          .toSet(),
      expectedDashboards.keys.toSet(),
    );
  });

  for (final language in ['es', 'fr', 'de', 'ar']) {
    test(
      '$language includes every message and preserves placeholder contracts',
      () {
        final messages = _readArb(language);
        expect(messages['@@locale'], language);
        expect(
          messages.keys.where((key) => !key.startsWith('@')).toSet(),
          messageKeys,
        );
        for (final key in messageKeys) {
          final translated = messages[key];
          expect(translated, isA<String>(), reason: key);
          if (translated is String) {
            expect(translated.trim(), isNotEmpty, reason: key);
            expect(
              _placeholders(translated),
              _placeholders(english[key] as String),
              reason: key,
            );
          }
          expect(
            messages['@$key'],
            english['@$key'],
            reason: 'Metadata for $key',
          );
        }
      },
    );

    test(
      '$language generates localized dashboard, disclosure and trip text',
      () {
        final localized = lookupAppLocalizations(Locale(language));
        final source = lookupAppLocalizations(const Locale('en'));
        expect(localized.dashboardTitle, expectedDashboards[language]);
        expect(
          localized.foregroundDisclosure,
          isNot(source.foregroundDisclosure),
        );
        expect(
          localized.tripExportDisclosure,
          isNot(source.tripExportDisclosure),
        );
        expect(localized.warningSpoken, isNot(source.warningSpoken));
        expect(
          localized.tripSummaryText(
            'DATE',
            'DISTANCE',
            'DURATION',
            'AVERAGE',
            'MAXIMUM',
          ),
          allOf(
            contains('DATE'),
            contains('DISTANCE'),
            contains('DURATION'),
            contains('AVERAGE'),
            contains('MAXIMUM'),
          ),
        );
      },
    );
  }
}

Map<String, Object?> _readArb(String language) {
  final Object? decoded = jsonDecode(
    File('lib/l10n/app_$language.arb').readAsStringSync(),
  );
  if (decoded is! Map<String, Object?>) {
    throw const FormatException('Expected ARB object');
  }
  return decoded;
}

Set<String> _placeholders(String message) => RegExp(
  r'\{(\w+)\}',
).allMatches(message).map((match) => match.group(1) ?? '').toSet();
