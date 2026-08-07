import 'package:flutter/material.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

/// Presents [child] in a [StupidSimpleSheetRoute] so a downward swipe at the
/// top of any nested scrollable dismisses the sheet (native sheet behavior).
///
/// Do not wrap sheet content in a custom [ScrollConfiguration] — the package
/// needs Flutter's default scroll behavior to detect the scroll top edge.
Future<T?> showAppSheet<T>({
  required BuildContext context,
  required Widget child,
  double heightFraction = 0.9,
  bool showDragHandle = true,
  Color? backgroundColor,
  ShapeBorder shape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
}) {
  assert(
    heightFraction > 0 && heightFraction <= 1,
    'heightFraction must be in (0, 1]',
  );

  return Navigator.of(context).push<T>(
    StupidSimpleSheetRoute<T>(
      child: _SheetMediaQuery(
        child: Builder(
          builder: (context) {
            final theme = Theme.of(context);
            final height = MediaQuery.sizeOf(context).height * heightFraction;
            final surface = backgroundColor ?? theme.colorScheme.surface;

            return SizedBox(
              height: height,
              child: SheetBackground(
                backgroundColor: surface,
                shape: shape,
                clipBehavior: Clip.antiAlias,
                // Needed: this route has no Scaffold, so text/chips miss app styles.
                child: Material(
                  type: MaterialType.transparency,
                  child: Column(
                    children: [
                      if (showDragHandle) const _SheetDragHandle(),
                      Expanded(child: child),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

/// Content-sized sheet with scroll-to-dismiss handoff.
Future<T?> showAppContentSheet<T>({
  required BuildContext context,
  required Widget child,
  bool showDragHandle = true,
  Color? backgroundColor,
  ShapeBorder shape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
}) {
  return Navigator.of(context).push<T>(
    StupidSimpleSheetRoute<T>(
      child: _SheetMediaQuery(
        child: Builder(
          builder: (context) {
            final surface =
                backgroundColor ?? Theme.of(context).colorScheme.surface;

            return SheetBackground(
              backgroundColor: surface,
              shape: shape,
              clipBehavior: Clip.antiAlias,
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showDragHandle) const _SheetDragHandle(),
                    child,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

/// Sheet routes cover the full screen, but content sits in the bottom panel.
/// Strip top safe-area padding so nested [SafeArea] widgets don't add a second
/// inset below the drag handle (unlike [showModalBottomSheet] which adjusts
/// [MediaQuery] for you).
class _SheetMediaQuery extends StatelessWidget {
  const _SheetMediaQuery({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: child,
    );
  }
}

class _SheetDragHandle extends StatelessWidget {
  const _SheetDragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
