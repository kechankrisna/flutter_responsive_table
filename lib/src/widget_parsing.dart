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
      return DeviceType.Smartphone;
    } else if (width >= kXsBreakPoint && width < kSmBreakPoint) {
      return DeviceType.MiniTablet;
    } else if (width >= kSmBreakPoint && width < kMdBreakPoint) {
      return DeviceType.Tablet;
    } else if (width >= kMdBreakPoint) {
      return DeviceType.Desktop;
    } else {
      return DeviceType.Unknown;
    }
  }

  DeviceSize get deviceSize {
    final double width = this.deviceWidth;
    if (width < kXsBreakPoint) {
      return DeviceSize.Xs;
    } else if (kXsBreakPoint <= width && width < kSmBreakPoint) {
      return DeviceSize.Sm;
    } else if (kSmBreakPoint <= width && width < kMdBreakPoint) {
      return DeviceSize.Md;
    } else if (kMdBreakPoint <= width && width < kLgBreakPoint) {
      return DeviceSize.Lg;
    } else {
      return DeviceSize.Xl;
    }
  }

  ScreenSize get screenSize {
    final double width = this.screenWidth;
    if (width < kXsBreakPoint) {
      return ScreenSize.Xs;
    } else if (kXsBreakPoint <= width && width < kSmBreakPoint) {
      return ScreenSize.Sm;
    } else if (kSmBreakPoint <= width && width < kMdBreakPoint) {
      return ScreenSize.Md;
    } else if (kMdBreakPoint <= width && width < kLgBreakPoint) {
      return ScreenSize.Lg;
    } else {
      return ScreenSize.Xl;
    }
  }

  double get defaultContainerRatio {
    double ratio = 1;
    switch (screenSize) {
      case ScreenSize.Xs:
        ratio = 1.45;
        break;
      case ScreenSize.Sm:
        ratio = 1.75;
        break;
      case ScreenSize.Md:
        ratio = 2;
        break;
      case ScreenSize.Lg:
        ratio = 2.5;
        break;
      case ScreenSize.Xl:
        ratio = 2.5;
        break;
      default:
        ratio = 1;
    }
    return ratio;
  }

  double get defaultContainerPadding {
    if (deviceSize == DeviceSize.Xs) {
      return 0;
    }
    return 10;
  }

  Orientation get orientation {
    final MediaQueryData mediaQueryData = MediaQuery.of(this);
    return mediaQueryData.orientation;
  }

  double get autoDrawerEdgeDragWidth {
    if (this.screenSize == ScreenSize.Xl ||
        this.screenSize == ScreenSize.Lg ||
        this.screenSize == ScreenSize.Md) {
      return 0;
    }
    return double.infinity;
  }
}

// refer to the type of device
enum DeviceType { Smartphone, MiniTablet, Tablet, Desktop, Unknown }
// refer to the device width
enum DeviceSize { Xs, Sm, Md, Lg, Xl }
// refer to the screen width
enum ScreenSize { Xs, Sm, Md, Lg, Xl }
//refer to the box width
enum BoxSize { Xs, Sm, Md, Lg, Xl }
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
