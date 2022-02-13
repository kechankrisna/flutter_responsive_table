import 'dart:io' as io;
import 'package:flutter/material.dart';

const double kXsBreakPoint = 600;
const double kSmBreakPoint = 768;
const double kMdBreakPoint = 992;
const double kLgBreakPoint = 1200;

extension BuildContextParsing on BuildContext {
  double get boxWidth {
    final MediaQueryData mediaQueryData = MediaQuery.of(this);
    final Size size = mediaQueryData.size;
    final double boxWidth = size.width;
    return boxWidth;
  }

  double get deviceWidth {
    final MediaQueryData mediaQueryData = MediaQuery.of(this);
    final Size size = mediaQueryData.size;

    final double deviceWidth = (io.Platform.isIOS || io.Platform.isAndroid) &&
            mediaQueryData.orientation == Orientation.landscape
        ? size.height
        : size.width;
    return deviceWidth;
  }

  double get screenWidth {
    final MediaQueryData mediaQueryData = MediaQuery.of(this);
    final Size size = mediaQueryData.size;
    final double deviceWidth = size.width;
    return deviceWidth;
  }

  double get deviceHeight {
    final MediaQueryData mediaQueryData = MediaQuery.of(this);
    final Size size = mediaQueryData.size;
    final double deviceHeight = (io.Platform.isIOS || io.Platform.isAndroid) &&
            mediaQueryData.orientation == Orientation.landscape
        ? size.width
        : size.height;
    return deviceHeight;
  }

  DeviceType get deviceType {
    final double width = this.deviceWidth;
    if (width > 0 && width < kXsBreakPoint) {
      return DeviceType.smartphone;
    } else if (width >= kXsBreakPoint && width < kSmBreakPoint) {
      return DeviceType.miniTablet;
    } else if (width >= kSmBreakPoint && width < kMdBreakPoint) {
      return DeviceType.tablet;
    } else if (width >= kMdBreakPoint) {
      return DeviceType.desktop;
    } else {
      return DeviceType.unknown;
    }
  }

  DeviceSize get deviceSize {
    final double width = this.deviceWidth;
    if (width < kXsBreakPoint) {
      return DeviceSize.xs;
    } else if (kXsBreakPoint <= width && width < kSmBreakPoint) {
      return DeviceSize.sm;
    } else if (kSmBreakPoint <= width && width < kMdBreakPoint) {
      return DeviceSize.md;
    } else if (kMdBreakPoint <= width && width < kLgBreakPoint) {
      return DeviceSize.lg;
    } else {
      return DeviceSize.xl;
    }
  }

  ScreenSize get screenSize {
    final double width = this.screenWidth;
    if (width < kXsBreakPoint) {
      return ScreenSize.xs;
    } else if (kXsBreakPoint <= width && width < kSmBreakPoint) {
      return ScreenSize.sm;
    } else if (kSmBreakPoint <= width && width < kMdBreakPoint) {
      return ScreenSize.md;
    } else if (kMdBreakPoint <= width && width < kLgBreakPoint) {
      return ScreenSize.lg;
    } else {
      return ScreenSize.xl;
    }
  }

  double get defaultContainerRatio {
    double ratio = 1;
    switch (screenSize) {
      case ScreenSize.xs:
        ratio = 1.45;
        break;
      case ScreenSize.sm:
        ratio = 1.75;
        break;
      case ScreenSize.md:
        ratio = 2;
        break;
      case ScreenSize.lg:
        ratio = 2.5;
        break;
      case ScreenSize.xl:
        ratio = 2.5;
        break;
      default:
        ratio = 1;
    }
    return ratio;
  }

  double get defaultContainerPadding {
    if (deviceSize == DeviceSize.xs) {
      return 0;
    }
    return 10;
  }

  Orientation get orientation {
    final MediaQueryData mediaQueryData = MediaQuery.of(this);
    return mediaQueryData.orientation;
  }

  double get autoDrawerEdgeDragWidth {
    if (this.screenSize == ScreenSize.xl ||
        this.screenSize == ScreenSize.lg ||
        this.screenSize == ScreenSize.md) {
      return 0;
    }
    return double.infinity;
  }
}

// refer to the type of device
enum DeviceType { smartphone, miniTablet, tablet, desktop, unknown }
// refer to the device width
enum DeviceSize { xs, sm, md, lg, xl }
// refer to the screen width
enum ScreenSize { xs, sm, md, lg, xl }
//refer to the box width
enum BoxSize { xs, sm, md, lg, xl }
/* Extra small devices (phones, 600px and down) */
// @media only screen and (max-width: 600px) {...}

/* Small devices (portrait tablets and large phones, 600px and up) */
// @media only screen and (min-width: 600px) {...}

/* Medium devices (landscape tablets, 768px and up) */
// @media only screen and (min-width: 768px) {...}

/* Large devices (laptops/desktops, 992px and up) */
// @media only screen and (min-width: 992px) {...}

/* Extra large devices (large laptops and desktops, 1200px and up) */
// @media only screen and (min-width: 1200px) {...}
