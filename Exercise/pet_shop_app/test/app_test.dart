import 'package:flutter_test/flutter_test.dart';
import 'package:pet_shop_app/main.dart';
import 'package:pet_shop_app/providers/auth_provider.dart';
import 'package:pet_shop_app/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final authProvider = AuthProvider();
    await authProvider.init();
    final router = createRouter(authProvider);

    await tester.pumpWidget(PetShopApp(authProvider: authProvider, router: router));
    await tester.pumpAndSettle();
  });
}
