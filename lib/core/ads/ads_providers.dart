import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ads_service.dart';

/// App-wide [AdsService] singleton, kept alive for the app's lifetime.
final adsServiceProvider = Provider<AdsService>((ref) => AdsService());
