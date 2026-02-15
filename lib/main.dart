import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/dashboard_with_packages_screen.dart';
import 'screens/create_package_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_dashboard_screen.dart';

void main() {
  runApp(const AgentraAgentPortal());
}

class AgentraAgentPortal extends StatelessWidget {
  const AgentraAgentPortal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agentra - Agent Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.orange,
          surface: AppColors.background,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.interTextTheme(),
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardWithPackagesScreen(),
        '/dashboard-packages': (context) => const DashboardWithPackagesScreen(),
        '/create-package': (context) => const CreatePackageScreen(),
        '/edit-package': (context) => const CreatePackageScreen(),
        '/admin-login': (context) => const AdminLoginScreen(),
        '/admin-dashboard': (context) => const AdminDashboardScreen(),
      },
    );
  }
}