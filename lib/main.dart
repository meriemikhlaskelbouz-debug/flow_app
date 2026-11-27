import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:material_ui/material_ui.dart';
import 'firebase_options.dart';
import 'screens/onboarding_screen.dart';
import 'screens/feature_walkthrough_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/profile_screen.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FlowApp());
}

class FlowApp extends StatelessWidget {
  const FlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return MaterialApp(
      title: 'Flow App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: StreamBuilder<User?>(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: AppColors.scaffoldBg,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }

          if (snapshot.hasData) {
            return const ProfileScreen();
          }

          return const AppNavigator();
        },
      ),
    );
  }
}

/// Full app navigation: Onboarding → Feature Walkthrough → Auth screens
enum AppPage { onboarding, walkthrough, signIn, signUp, resetPassword }

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  AppPage _currentPage = AppPage.onboarding;

  void _navigateTo(AppPage page) {
    setState(() => _currentPage = page);
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentPage) {
      case AppPage.onboarding:
        return OnboardingScreen(
          onGetStarted: () => _navigateTo(AppPage.walkthrough),
          onLogIn: () => _navigateTo(AppPage.signIn),
        );
      case AppPage.walkthrough:
        return FeatureWalkthroughScreen(
          onFinish: () => _navigateTo(AppPage.signUp),
        );
      case AppPage.signUp:
        return SignUpScreen(
          onSwitchToLogin: () => _navigateTo(AppPage.signIn),
        );
      case AppPage.resetPassword:
        return ResetPasswordScreen(
          onBackToLogin: () => _navigateTo(AppPage.signIn),
        );
      case AppPage.signIn:
        return SignInScreen(
          onSwitchToSignUp: () => _navigateTo(AppPage.signUp),
          onForgotPassword: () => _navigateTo(AppPage.resetPassword),
        );
    }
  }
}
