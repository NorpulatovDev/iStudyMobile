import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

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
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final orientation = mediaQuery.orientation;
    final viewInsets = mediaQuery.viewInsets;
    final padding = mediaQuery.padding;
    
    // Determine device characteristics
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = screenWidth >= 600;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;
    final hasNotch = padding.bottom > 20; // Detect devices with home indicator
    
    // Calculate safe dimensions to prevent overflow
    final availableHeight = screenHeight - viewInsets.bottom - padding.top;
    final maxNavigationHeight = availableHeight * 0.12; // Max 12% of screen height
    
    // Adaptive dimensions with overflow prevention
    final navigationHeight = _getSafeNavigationHeight(
      isTablet: isTablet,
      isSmallDevice: isSmallDevice,
      isLandscape: isLandscape,
      hasNotch: hasNotch,
      maxHeight: maxNavigationHeight,
    );
    
    final borderRadius = isTablet ? 20.0 : (isLandscape ? 16.0 : 20.0);
    final horizontalPadding = _getHorizontalPadding(screenWidth, isTablet);
    final verticalPadding = _getVerticalPadding(isSmallDevice, isLandscape);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: navigationHeight,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCompactNavItem(
                icon: Icons.analytics_rounded,
                label: 'Reports',
                index: 0,
                color: Colors.green,
                isTablet: isTablet,
                isSmallDevice: isSmallDevice,
                isLandscape: isLandscape,
              ),
              _buildCompactNavItem(
                icon: Icons.business_rounded,
                label: 'Branches',
                index: 1,
                color: AppTheme.primaryColor,
                isTablet: isTablet,
                isSmallDevice: isSmallDevice,
                isLandscape: isLandscape,
              ),
              _buildCompactNavItem(
                icon: Icons.people_rounded,
                label: 'Users',
                index: 2,
                color: Colors.purple,
                isTablet: isTablet,
                isSmallDevice: isSmallDevice,
                isLandscape: isLandscape,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getSafeNavigationHeight({
    required bool isTablet,
    required bool isSmallDevice,
    required bool isLandscape,
    required bool hasNotch,
    required double maxHeight,
  }) {
    double baseHeight;
    
    if (isLandscape) {
      baseHeight = isTablet ? 60 : (isSmallDevice ? 50 : 55);
    } else {
      baseHeight = isTablet ? 75 : (isSmallDevice ? 60 : 70);
    }
    
    // Add extra space for devices with home indicator
    if (hasNotch && !isLandscape) {
      baseHeight += 5;
    }
    
    // Ensure we don't exceed the maximum allowed height
    return baseHeight.clamp(45, maxHeight);
  }

  double _getHorizontalPadding(double screenWidth, bool isTablet) {
    if (isTablet) return 24;
    if (screenWidth < 320) return 8;
    if (screenWidth < 360) return 12;
    return 16;
  }

  double _getVerticalPadding(bool isSmallDevice, bool isLandscape) {
    if (isLandscape) return 4;
    return isSmallDevice ? 6 : 8;
  }

  Widget _buildCompactNavItem({
    required IconData icon,
    required String label,
    required int index,
    required Color color,
    required bool isTablet,
    required bool isSmallDevice,
    required bool isLandscape,
  }) {
    final isSelected = currentIndex == index;
    
    // Compact dimensions to prevent overflow
    final iconSize = _getCompactIconSize(isTablet, isSmallDevice, isLandscape);
    final fontSize = _getCompactFontSize(isTablet, isSmallDevice, isLandscape);
    final iconPadding = _getCompactIconPadding(isTablet, isSmallDevice, isLandscape);
    final itemPadding = _getCompactItemPadding(isSmallDevice, isLandscape);
    final borderRadius = isTablet ? 14.0 : 12.0;
    final spacing = isLandscape || isSmallDevice ? 2.0 : 3.0;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: isSmallDevice ? 2 : 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            // padding: EdgeInsets.symmetric(
            //   horizontal: itemPadding.horizontal,
            //   vertical: itemPadding.vertical,
            // ),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(borderRadius),
              border: isSelected 
                  ? Border.all(color: color.withOpacity(0.2), width: 1)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(iconPadding),
                  decoration: BoxDecoration(
                    color: isSelected ? color : Colors.transparent,
                    borderRadius: BorderRadius.circular(iconPadding + 2),
                    boxShadow: isSelected && !isLandscape
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : Colors.grey[600],
                    size: iconSize,
                  ),
                ),
                
                // Spacing
                SizedBox(height: spacing),
                
                // Label
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: isSelected ? color : Colors.grey[600],
                    fontSize: fontSize,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    height: 1.1, // Tight line height to save space
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getCompactIconSize(bool isTablet, bool isSmallDevice, bool isLandscape) {
    if (isLandscape) {
      return isTablet ? 20 : (isSmallDevice ? 16 : 18);
    }
    return isTablet ? 22 : (isSmallDevice ? 18 : 20);
  }

  double _getCompactFontSize(bool isTablet, bool isSmallDevice, bool isLandscape) {
    if (isLandscape) {
      return isTablet ? 11 : (isSmallDevice ? 9 : 10);
    }
    return isTablet ? 12 : (isSmallDevice ? 9 : 11);
  }

  double _getCompactIconPadding(bool isTablet, bool isSmallDevice, bool isLandscape) {
    if (isLandscape) {
      return isTablet ? 6 : (isSmallDevice ? 4 : 5);
    }
    return isTablet ? 8 : (isSmallDevice ? 5 : 6);
  }

  ({double horizontal, double vertical}) _getCompactItemPadding(bool isSmallDevice, bool isLandscape) {
    if (isLandscape) {
      return (horizontal: isSmallDevice ? 4.0 : 6.0, vertical: 2.0);
    }
    return (horizontal: isSmallDevice ? 6.0 : 8.0, vertical: isSmallDevice ? 3.0 : 4.0);
  }
}