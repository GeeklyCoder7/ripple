import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom color palette for ShareWave - Ocean & Wave inspired theme
class AppColors {
  AppColors._(); // Private constructor

// 🌊 PRIMARY WAVE COLORS
  static const Color deepOcean = Color(0xFF0D3B66);      // AppBars, primary buttons
  static const Color waveBlue = Color(0xFF1976D2);       // Main brand accents, highlighted buttons
  static const Color surfBlue = Color(0xFF64B5F6);       // Secondary buttons, selected states
  static const Color foamBlue = Color(0xFFE3F2FD);       // App background, card backgrounds

// 🌀 ACCENT WAVE COLORS
  static const Color tealWave = Color(0xFF0097A7);       // Floating action button, accent highlights
  static const Color cyanSplash = Color(0xFF00BCD4);     // Icons, secondary highlights
  static const Color aquaMist = Color(0xFF4DD0E1);       // Borders, subtle accents

// ⚡ COMPLEMENTARY COLORS
  static const Color coralWave = Color(0xFF7E57C2);      // Call-to-action buttons, special highlights
  static const Color seafoamGreen = Color(0xFF26A69A);   // Success messages, confirmation states
  static const Color stormGray = Color(0xFF546E7A);      // Secondary text, icons

// 🌈 NEUTRAL WAVE COLORS
  static const Color white = Color(0xFFFFFFFF);          // Text on dark, card backgrounds
  static const Color lightFoam = Color(0xFFF9FBFF);      // Screen background, light surfaces
  static const Color mistGray = Color(0xFFCFD8DC);       // Dividers, disabled states
  static const Color deepGray = Color(0xFF37474F);       // Body text, subtitles
  static const Color abyssal = Color(0xFF1C2833);        // Primary text, dark backgrounds

// ✅ SUCCESS WAVE COLORS
  static const Color successWave = Color(0xFF26A69A);    // Success banners, success buttons
  static const Color successLight = Color(0xFF80CBC4);   // Background for success states

// ❌ ERROR WAVE COLORS
  static const Color errorCoral = Color(0xFF1565C0);     // Error messages, error icons
  static const Color errorLight = Color(0xFF42A5F5);     // Background for error states

// ⚠️ WARNING WAVE COLORS
  static const Color warningAmber = Color(0xFF5C6BC0);   // Warning messages, alert icons
  static const Color warningLight = Color(0xFF9FA8DA);   // Background for warning states

// 🗂️ FILE TYPE WAVE COLORS
  static const Color fileDocument = Color(0xFF00695C);   // Document file icons
  static const Color fileImage = Color(0xFF00838F);      // Image file icons
  static const Color fileVideo = Color(0xFF5E35B1);      // Video file icons
  static const Color fileAudio = Color(0xFF3949AB);      // Audio file icons
  static const Color fileApk = Color(0xFF0277BD);        // APK file icons
  static const Color fileOther = Color(0xFF546E7A);      // Other/unknown file icons

// 🎨 GRADIENT WAVE COLORS
  static const List<Color> oceanGradient = [deepOcean, waveBlue];   // AppBar gradients, splash screen
  static const List<Color> surfGradient = [waveBlue, surfBlue];     // Button gradients
  static const List<Color> mistGradient = [surfBlue, foamBlue];     // Background gradients
  static const List<Color> coralGradient = [coralWave, Color(0xFFB39DDB)]; // CTA gradients

  // BUTTON GRADIENT COLORS
  static const sendButtonGradient = LinearGradient(colors: [cyanSplash, waveBlue], begin: Alignment.topRight, end: Alignment.topLeft);
  static const receiveButtonGradient = LinearGradient(colors: [aquaMist, successWave], begin: Alignment.topRight, end: Alignment.topLeft);

  // OTHER CUSTOM COLORS
  static const utilityButtonsBackground = Color(0xFFECEFF1);
  static const List<Color> appNameTextColor = [AppColors.aquaMist, AppColors.abyssal];
  static const surfaceLightBackgroundColor = white; //Color(0xFFEFF6FF)
  static const surfaceDarkBackgroundColor = Color(0xFF26323A);


  /// Get color based on file extension
  static Color getFileTypeColor(String extension) {
    switch (extension.toLowerCase()) {
      case '.pdf':
      case '.doc':
      case '.docx':
      case '.txt':
      case '.rtf':
      case '.odt':
        return fileDocument;
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
      case '.bmp':
      case '.webp':
      case '.svg':
        return fileImage;
      case '.mp4':
      case '.avi':
      case '.mov':
      case '.mkv':
      case '.flv':
      case '.wmv':
        return fileVideo;
      case '.mp3':
      case '.wav':
      case '.aac':
      case '.flac':
      case '.ogg':
      case '.m4a':
        return fileAudio;
      case '.apk':
        return fileApk;
      default:
        return fileOther;
    }
  }

  /// Get gradient based on context
  static LinearGradient getWaveGradient({
    required String type,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    List<Color> colors;
    switch (type.toLowerCase()) {
      case 'ocean':
        colors = oceanGradient;
        break;
      case 'surf':
        colors = surfGradient;
        break;
      case 'mist':
        colors = mistGradient;
        break;
      case 'coral':
        colors = coralGradient;
        break;
      default:
        colors = oceanGradient;
    }

    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
    );
  }

  /// Material Theme with ShareWave colors
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.quicksand().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: waveBlue,
        primary: waveBlue,
        onPrimary: white,
        primaryContainer: surfBlue,
        onPrimaryContainer: deepOcean,
        secondary: tealWave,
        onSecondary: white,
        secondaryContainer: cyanSplash,
        onSecondaryContainer: deepOcean,
        tertiary: coralWave,
        onTertiary: white,
        error: errorCoral,
        onError: white,
        background: lightFoam,
        onBackground: deepGray,
        surface: surfaceLightBackgroundColor,
        onSurface: deepGray,
        surfaceVariant: mistGray,
        onSurfaceVariant: stormGray,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cyanSplash,
        foregroundColor: white,
        centerTitle: true,
        elevation: 2,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: waveBlue,
          foregroundColor: white,
          elevation: 3,
          shadowColor: waveBlue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: deepOcean.withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: coralWave,
        foregroundColor: white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: deepOcean, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: deepOcean, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: deepOcean, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: deepOcean, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: deepOcean, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: deepOcean, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: deepGray, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(color: deepGray, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: stormGray, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: deepGray),
        bodyMedium: TextStyle(color: deepGray),
        bodySmall: TextStyle(color: stormGray),
      ),
    );
  }

  /// Dark theme for ShareWave
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: waveBlue,
        brightness: Brightness.dark,
        primary: surfBlue,
        onPrimary: abyssal,
        primaryContainer: deepOcean,
        onPrimaryContainer: surfBlue,
        secondary: aquaMist,
        onSecondary: abyssal,
        secondaryContainer: tealWave,
        onSecondaryContainer: white,
        tertiary: coralWave,
        onTertiary: abyssal,
        error: errorLight,
        onError: abyssal,
        background: abyssal,
        onBackground: white,
        surface: surfaceDarkBackgroundColor,
        onSurface: white,
        surfaceVariant: stormGray,
        onSurfaceVariant: mistGray,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: abyssal,
        foregroundColor: white,
        centerTitle: true,
        elevation: 2,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}