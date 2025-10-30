import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  /// Returns true if the device is a tablet (width >= 600)
  bool get isTablet {
    final shortestSide = MediaQuery.of(this).size.shortestSide;
    return shortestSide >= 600;
  }

  /// Returns true if the device is in landscape mode
  bool get isLandscape {
    return MediaQuery.of(this).orientation == Orientation.landscape;
  }

  /// Returns true if the device is in portrait mode
  bool get isPortrait {
    return MediaQuery.of(this).orientation == Orientation.portrait;
  }

  /// Returns true if the device is a mobile phone
  bool get isMobile {
    final shortestSide = MediaQuery.of(this).size.shortestSide;
    return shortestSide < 600;
  }

  /// Returns true if the device is a desktop (width >= 1024)
  bool get isDesktop {
    final width = MediaQuery.of(this).size.width;
    return width >= 1024;
  }

  /// Returns the screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Returns the screen height
  double get screenHeight => MediaQuery.of(this).size.height;
}