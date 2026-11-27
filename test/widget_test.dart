import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flow_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('onboarding flows through walkthrough to account creation',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: AppNavigator()));

    expect(find.textContaining('Reach your goals with gentle'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Create, manage, and track your daily tasks'),
        findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Join live group study sessions with friends'),
        findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Use timed focus sessions with built-in breaks'),
        findsOneWidget);

    await tester.tap(find.text("Let's go!"));
    await tester.pumpAndSettle();
    expect(find.text('Start your learning journey today'), findsOneWidget);
  });

  testWidgets('login and password reset links navigate correctly',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: AppNavigator()));

    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in to continue your progress'), findsOneWidget);

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No worries'), findsOneWidget);

    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in to continue your progress'), findsOneWidget);

    await tester.tap(find.text('Create one'));
    await tester.pumpAndSettle();
    expect(find.text('Start your learning journey today'), findsOneWidget);

    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in to continue your progress'), findsOneWidget);
  });
}
