import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_list_shmr/utility/logger/logging.dart';
import 'test_main.dart' as test_app;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await rootBundle.loadString('l10n/ru.json');
  await rootBundle.loadString('l10n/en.json');

  setUp(() => logger(WidgetTester).i('Next test is running...'));

  testWidgets('App launch test', (WidgetTester tester) async {
    test_app.main();
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
    expect(find.byType(FloatingActionButton), findsWidgets);
  });

  testWidgets('Opening and closing task form', (WidgetTester tester) async {
    test_app.main();
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(seconds: 2));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.delete, skipOffstage: false), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
  });

  testWidgets('Save some task', (WidgetTester tester) async {
    test_app.main();
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.delete, skipOffstage: false), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'blablabla');

    await tester.tap(find.byType(TextButton).first);
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(seconds: 2));
    expect(find.text('blablabla'), findsOneWidget);
  });
}
