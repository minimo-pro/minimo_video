// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:collection/collection.dart' as _i10;
import 'package:flutter/material.dart' as _i8;
import 'package:minimo_video/features/compression/domain/picked_video.dart'
    as _i9;
import 'package:minimo_video/features/compression/presentation/compress_screen.dart'
    as _i1;
import 'package:minimo_video/screens/info_screen.dart' as _i2;
import 'package:minimo_video/screens/onboarding_screen.dart' as _i3;
import 'package:minimo_video/screens/settings_screen.dart' as _i4;
import 'package:minimo_video/screens/splash_screen.dart' as _i5;
import 'package:minimo_video/screens/start_page.dart' as _i6;

/// generated route for
/// [_i1.CompressScreen]
class CompressRoute extends _i7.PageRouteInfo<CompressRouteArgs> {
  CompressRoute({
    _i8.Key? key,
    List<_i9.PickedVideo> initialVideos = const [],
    List<_i7.PageRouteInfo>? children,
  }) : super(
         CompressRoute.name,
         args: CompressRouteArgs(key: key, initialVideos: initialVideos),
         initialChildren: children,
       );

  static const String name = 'CompressRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CompressRouteArgs>(
        orElse: () => const CompressRouteArgs(),
      );
      return _i1.CompressScreen(
        key: args.key,
        initialVideos: args.initialVideos,
      );
    },
  );
}

class CompressRouteArgs {
  const CompressRouteArgs({this.key, this.initialVideos = const []});

  final _i8.Key? key;

  final List<_i9.PickedVideo> initialVideos;

  @override
  String toString() {
    return 'CompressRouteArgs{key: $key, initialVideos: $initialVideos}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CompressRouteArgs) return false;
    return key == other.key &&
        const _i10.ListEquality<_i9.PickedVideo>().equals(
          initialVideos,
          other.initialVideos,
        );
  }

  @override
  int get hashCode =>
      key.hashCode ^
      const _i10.ListEquality<_i9.PickedVideo>().hash(initialVideos);
}

/// generated route for
/// [_i2.InfoScreen]
class InfoRoute extends _i7.PageRouteInfo<void> {
  const InfoRoute({List<_i7.PageRouteInfo>? children})
    : super(InfoRoute.name, initialChildren: children);

  static const String name = 'InfoRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.InfoScreen();
    },
  );
}

/// generated route for
/// [_i3.OnboardingScreen]
class OnboardingRoute extends _i7.PageRouteInfo<void> {
  const OnboardingRoute({List<_i7.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i4.SettingsScreen]
class SettingsRoute extends _i7.PageRouteInfo<void> {
  const SettingsRoute({List<_i7.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i5.SplashScreen]
class SplashRoute extends _i7.PageRouteInfo<void> {
  const SplashRoute({List<_i7.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.SplashScreen();
    },
  );
}

/// generated route for
/// [_i6.StartPage]
class StartRoute extends _i7.PageRouteInfo<void> {
  const StartRoute({List<_i7.PageRouteInfo>? children})
    : super(StartRoute.name, initialChildren: children);

  static const String name = 'StartRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.StartPage();
    },
  );
}
