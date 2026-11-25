import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('Home page displays portfolio action cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    expect(find.text('Tambah Proyek'), findsOneWidget);
    expect(find.text('Tambah Experience'), findsOneWidget);
  });
}
