/// Central route paths used by the application and feature UI.
abstract final class AppRoutes {
  static const dashboard = '/';
  static const permissions = '/permissions';
  static const focusedDisplay = '/display';
  static const settings = '/settings';
  static const privacyPolicy = '/settings/privacy-policy';
  static const termsAndConditions = '/settings/terms-and-conditions';
  static const fuel = '/fuel';
  static const loading = '/loading';
  static const history = '/trips';
  static const trips = history;
  static const tripDetailPattern = '/trips/:tripId';
  static String tripDetail(String id) => '/trips/${Uri.encodeComponent(id)}';
}
