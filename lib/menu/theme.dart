import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

// ── Shared theme colors ────────────────────────────────────────────────
// Put this file at lib/menu/theme.dart and import it from every screen
// as package:present_group2/menu/theme.dart.
// Previously each screen (main_screen.dart, older_sceen.dart,
// profile_screen.dart) declared its own copy of these same constants,
// and since those files import each other, Dart couldn't tell which
// "kBg" you meant — that's the compile error you were likely hitting.
const kBg = Color(0xFFF9F1EC); // soft cream background
const kTextDark = Color(0xFF1B1D28);
const kTextGrey = Color(0xFF8B8F9A);
const kGreen = Color(0xFF2FBF6E);
const kGreenDark = Color(0xFF1E9C57); // gradient partner for kGreen
const kPeach = Color(0xFFF5E3DA);
const kBadgePink = Color(0xFFE85D9B);
const kShadow = Color(0x14000000); // soft ~8% black shadow, use everywhere

/// Lets horizontal (and vertical) lists be scrolled by dragging with a
/// mouse, not just touch. Flutter's default only allows touch-drag to
/// scroll — on web or desktop, click-and-drag does nothing unless you
/// opt in like this. Apply it once, globally, in main.dart:
///
///   MaterialApp(
///     scrollBehavior: AppScrollBehavior(),
///     ...
///   )
///
/// After that every ListView/PageView/GridView in the app — including
/// horizontal ones like "Trending product" — can be dragged with a mouse.
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}
