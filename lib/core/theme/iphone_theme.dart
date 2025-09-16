import 'package:flutter/material.dart';

class iPhoneTheme {
  // Colors
  static const Color primaryBlue = Color(0xFF007AFF);
  static const Color primaryGreen = Color(0xFF34C759);
  static const Color primaryRed = Color(0xFFFF3B30);
  static const Color primaryOrange = Color(0xFFFF9500);
  static const Color primaryPurple = Color(0xFFAF52DE);
  static const Color primaryYellow = Color(0xFFFFCC00);
  
  // Grays
  static const Color gray1 = Color(0xFF8E8E93);
  static const Color gray2 = Color(0xFFAEAEB2);
  static const Color gray3 = Color(0xFFC7C7CC);
  static const Color gray4 = Color(0xFFD1D1D6);
  static const Color gray5 = Color(0xFFE5E5EA);
  static const Color gray6 = Color(0xFFF2F2F7);
  
  // Background colors
  static const Color systemBackground = Color(0xFFFFFFFF);
  static const Color secondarySystemBackground = Color(0xFFF2F2F7);
  static const Color tertiarySystemBackground = Color(0xFFFFFFFF);
  static const Color groupedBackground = Color(0xFFF2F2F7);
  static const Color secondaryGroupedBackground = Color(0xFFFFFFFF);
  
  // Text colors
  static const Color primaryText = Color(0xFF000000);
  static const Color secondaryText = Color(0xFF3C3C43);
  static const Color tertiaryText = Color(0xFF3C3C43);
  
  // Border radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 20.0;
  static const double superLargeRadius = 24.0;
  
  // Shadows
  static List<BoxShadow> get smallShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 15,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get largeShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
  
  // Text styles
  static const TextStyle largeTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: primaryText,
  );
  
  static const TextStyle title1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: primaryText,
  );
  
  static const TextStyle title2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: primaryText,
  );
  
  static const TextStyle title3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: primaryText,
  );
  
  static const TextStyle headline = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: primaryText,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: primaryText,
  );
  
  static const TextStyle callout = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: primaryText,
  );
  
  static const TextStyle subheadline = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: primaryText,
  );
  
  static const TextStyle footnote = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: secondaryText,
  );
  
  static const TextStyle caption1 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: secondaryText,
  );
  
  static const TextStyle caption2 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: secondaryText,
  );
  
  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  
  // Animation durations
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  
  // Button heights
  static const double smallButtonHeight = 36.0;
  static const double mediumButtonHeight = 44.0;
  static const double largeButtonHeight = 50.0;
  static const double extraLargeButtonHeight = 56.0;
}