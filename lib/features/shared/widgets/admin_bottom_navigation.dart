// lib/features/shared/widgets/admin_bottom_navigation.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AdminBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: _getNavigationHeight(context),
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(context),
            vertical: _getVerticalPadding(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.analytics_rounded,
                label: 'Reports',
                index: 0,
                color: Colors.green,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.school_rounded,
                label: 'Branches',
                index: 1,
                color: Colors.indigo,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.people_rounded,
                label: 'Users',
                index: 2,
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required Color color,
  }) {
    final isSelected = currentIndex == index;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 2 : 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Container
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                padding: EdgeInsets.all(_getIconPadding(context)),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(_getIconPadding(context) + 4),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  icon,
                  size: _getIconSize(context),
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
              ),

              // Spacing
              SizedBox(height: _getLabelSpacing(context)),

              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                style: TextStyle(
                  fontSize: _getLabelFontSize(context),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? color : Colors.grey[600],
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Selection Indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                width: isSelected ? 20 : 0,
                height: 2,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Responsive dimension getters
  double _getNavigationHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    if (isLandscape) {
      return isTablet ? 65 : 55;
    }
    
    if (isTablet) {
      return 80;
    }
    
    // For phones, use a percentage of screen height with min/max constraints
    final dynamicHeight = screenHeight * 0.09;
    return dynamicHeight.clamp(65.0, 85.0);
  }

  double _getHorizontalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth >= 768) {
      return 32; // Tablet
    } else if (screenWidth >= 375) {
      return 20; // Regular phone
    } else {
      return 12; // Small phone
    }
  }

  double _getVerticalPadding(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    
    if (isLandscape) {
      return isTablet ? 8 : 6;
    }
    
    return isTablet ? 12 : 8;
  }

  double _getIconSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    if (isLandscape) {
      return screenWidth >= 768 ? 22 : 18;
    }
    
    if (screenWidth >= 768) {
      return 26; // Tablet
    } else if (screenWidth >= 375) {
      return 22; // Regular phone
    } else {
      return 20; // Small phone
    }
  }

  double _getIconPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    if (isLandscape) {
      return screenWidth >= 768 ? 8 : 6;
    }
    
    if (screenWidth >= 768) {
      return 10; // Tablet
    } else if (screenWidth >= 375) {
      return 8; // Regular phone
    } else {
      return 6; // Small phone
    }
  }

  double _getLabelFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    if (isLandscape) {
      return screenWidth >= 768 ? 12 : 10;
    }
    
    if (screenWidth >= 768) {
      return 14; // Tablet
    } else if (screenWidth >= 375) {
      return 12; // Regular phone
    } else {
      return 11; // Small phone
    }
  }

  double _getLabelSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    if (isLandscape) {
      return 2;
    }
    
    return screenWidth >= 375 ? 4 : 3;
  }
}