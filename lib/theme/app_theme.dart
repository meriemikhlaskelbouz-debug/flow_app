import 'package:material_ui/material_ui.dart';

class AppColors {
  AppColors._();

  // Primary sage/olive greens from the design
  static const Color primary = Color(0xFF5B7A5E);
  static const Color primaryDark = Color(0xFF3D5A40);
  static const Color primaryLight = Color(0xFF8FBC8F);

  // Backgrounds
  static const Color scaffoldBg = Color(0xFFF5F0E8);
  static const Color cardBg = Color(0xFFF9F6F0);
  static const Color inputBg = Color(0xFFFAF8F4);
  static const Color inputBorder = Color(0xFFD4CEBC);

  // Text
  static const Color textPrimary = Color(0xFF2D3A2E);
  static const Color textSecondary = Color(0xFF6B7D6C);
  static const Color textHint = Color(0xFF9EA89F);

  // Button
  static const Color buttonBg = Color(0xFF5B7A5E);
  static const Color buttonText = Color(0xFFFFFDF8);

  // Social button
  static const Color socialBorder = Color(0xFFD4CEBC);
  static const Color socialBg = Color(0xFFFAF8F4);

  // Accent
  static const Color linkText = Color(0xFF5B7A5E);

  // Status bar / nav bar green scallop
  static const Color navBarGreen = Color(0xFF5B7A5E);
}

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle heading = TextStyle(
    fontFamily: 'Courier',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  static const TextStyle headingItalic = TextStyle(
    fontFamily: 'Courier',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
    color: AppColors.primaryDark,
    height: 1.1,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle inputLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.buttonText,
    letterSpacing: 0.3,
  );

  static const TextStyle socialButtonLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle linkBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle dividerText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: AppColors.buttonText,
        surface: AppColors.scaffoldBg,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.scaffoldBg,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        hintStyle: AppTextStyles.inputLabel,
        labelStyle: AppTextStyles.inputLabel,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonBg,
          foregroundColor: AppColors.buttonText,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTextStyles.buttonLabel,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.socialBorder, width: 1),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTextStyles.socialButtonLabel,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.linkText,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryDark,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
