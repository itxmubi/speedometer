import 'package:integration_test/integration_test.dart';

import '../test/support/register_tracking_flows.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  registerTrackingFlows();
}
