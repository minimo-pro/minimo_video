// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:collection/collection.dart' as _i8;
import 'package:flutter/material.dart' as _i6;
import 'package:minimo_video/screens/compress_screen.dart' as _i1;
import 'package:minimo_video/screens/info_screen.dart' as _i2;
import 'package:minimo_video/screens/settings_screen.dart' as _i3;
import 'package:minimo_video/screens/start_page.dart' as _i4;
import 'package:minimo_video/services/file_service.dart' as _i7;

/// generated route for
/// [_i1.CompressScreen]
class CompressRoute extends _i5.PageRouteInfo<CompressRouteArgs> {
  CompressRoute({
    _i6.Key? key,
    List<_i7.PickedVideo> initialVideos = const [],
    List<_i5.PageRouteInfo>? children,
  }) : super(
         CompressRoute.name,
         args: CompressRouteArgs(key: key, initialVideos: initialVideos),
         initialChildren: children,
       );

  static const String name = 'CompressRoute';

  static _i5.PageInfo page = _i5.PageInfo(
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

  final _i6.Key? key;

  final List<_i7.PickedVideo> initialVideos;

  @override
  String toString() {
    return 'CompressRouteArgs{key: $key, initialVideos: $initialVideos}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CompressRouteArgs) return false;
    return key == other.key &&
        const _i8.ListEquality<_i7.PickedVideo>().equals(
          initialVideos,
          other.initialVideos,
        );
  }

  @override
  int get hashCode =>
      key.hashCode ^
      const _i8.ListEquality<_i7.PickedVideo>().hash(initialVideos);
}

/// generated route for
/// [_i2.InfoScreen]
class InfoRoute extends _i5.PageRouteInfo<void> {
  const InfoRoute({List<_i5.PageRouteInfo>? children})
    : super(InfoRoute.name, initialChildren: children);

  static const String name = 'InfoRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.InfoScreen();
    },
  );
}

/// generated route for
/// [_i3.SettingsScreen]
class SettingsRoute extends _i5.PageRouteInfo<void> {
  const SettingsRoute({List<_i5.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i3.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i4.StartPage]
class StartRoute extends _i5.PageRouteInfo<void> {
  const StartRoute({List<_i5.PageRouteInfo>? children})
    : super(StartRoute.name, initialChildren: children);

  static const String name = 'StartRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i4.StartPage();
    },
  );
}
