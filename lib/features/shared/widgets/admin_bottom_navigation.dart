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
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final bottomPadding = mediaQuery.padding.bottom;
    
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
          constraints: BoxConstraints(
            minHeight: _getMinNavigationHeight(context),
            maxHeight: _getMaxNavigationHeight(context),
          ),
          padding: EdgeInsets.only(
            left: _getHorizontalPadding(context),
            right: _getHorizontalPadding(context),
            top: _getTopPadding(context),
            bottom: _getBottomPadding(context, bottomPadding),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
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
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 2 : 4),
          constraints: BoxConstraints(
            minHeight: _getItemMinHeight(context),
          ),
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

              // Spacing - only add if not in landscape on small screens
              if (!isLandscape || screenWidth >= 768)
                SizedBox(height: _getLabelSpacing(context)),

              // Label - make it flexible
              if (!isLandscape || screenWidth >= 768)
                Flexible(
                  child: AnimatedDefaultTextStyle(
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
                ),

              // Selection Indicator - smaller in landscape
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                width: isSelected ? (isLandscape ? 12 : 20) : 0,
                height: isLandscape ? 1.5 : 2,
                margin: EdgeInsets.only(top: isLandscape ? 2 : 4),
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

  // Responsive dimension getters with better constraints
  double _getMinNavigationHeight(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    
    if (isLandscape) {
      return isTablet ? 50 : 45;
    }
    
    return isTablet ? 65 : 55;
  }

  double _getMaxNavigationHeight(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    
    if (isLandscape) {
      return isTablet ? 65 : 55;
    }
    
    return isTablet ? 85 : 75;
  }

  double _getItemMinHeight(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (isLandscape) {
      return screenWidth >= 768 ? 40 : 35;
    }
    
    return screenWidth >= 768 ? 50 : 45;
  }

  double _getHorizontalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth >= 768) {
      return 24; // Tablet
    } else if (screenWidth >= 375) {
      return 16; // Regular phone
    } else {
      return 12; // Small phone
    }
  }

  double _getTopPadding(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (isLandscape) {
      return screenWidth >= 768 ? 8 : 6;
    }
    
    return screenWidth >= 768 ? 12 : 8;
  }

  double _getBottomPadding(BuildContext context, double bottomSafeArea) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Base padding
    double basePadding;
    if (isLandscape) {
      basePadding = screenWidth >= 768 ? 8 : 6;
    } else {
      basePadding = screenWidth >= 768 ? 12 : 8;
    }
    
    // Add extra padding if there's no bottom safe area (for devices without home indicator)
    if (bottomSafeArea < 10) {
      basePadding += 8;
    }
    
    return basePadding;
  }

  double _getIconSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    if (isLandscape) {
      return screenWidth >= 768 ? 20 : 18;
    }
    
    if (screenWidth >= 768) {
      return 24; // Tablet
    } else if (screenWidth >= 375) {
      return 20; // Regular phone
    } else {
      return 18; // Small phone
    }
  }

  double _getIconPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    if (isLandscape) {
      return screenWidth >= 768 ? 6 : 5;
    }
    
    if (screenWidth >= 768) {
      return 8; // Tablet
    } else if (screenWidth >= 375) {
      return 6; // Regular phone
    } else {
      return 5; // Small phone
    }
  }

  double _getLabelFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    if (isLandscape) {
      return screenWidth >= 768 ? 11 : 10;
    }
    
    if (screenWidth >= 768) {
      return 13; // Tablet
    } else if (screenWidth >= 375) {
      return 11; // Regular phone
    } else {
      return 10; // Small phone
    }
  }

  double _getLabelSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    if (isLandscape) {
      return 1;
    }
    
    return screenWidth >= 375 ? 3 : 2;
  }
}