import 'package:flutter/material.dart';
import '../enums/dialog_transition_type.dart';
import '../transitions/dialog_transitions.dart';

Future<T?> showAnimatedDialog<T extends Object?>({
  required BuildContext context,
  bool barrierDismissible = false,
  required WidgetBuilder builder,
  DialogTransitionType animationType = DialogTransitionType.scale,
  Curve curve = Curves.fastOutSlowIn,
  Duration? duration,
  Alignment alignment = Alignment.center,
  Color? barrierColor,
  Axis? axis = Axis.horizontal,
}) {
  final ThemeData theme = Theme.of(context);

  return showGeneralDialog(
    context: context,
    pageBuilder: (
      BuildContext buildContext,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        top: false,
        child: Builder(
          builder: (BuildContext context) {
            return Theme(data: theme, child: pageChild);
          },
        ),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Close dialog',
    barrierColor: barrierColor ?? Colors.black54,
    transitionDuration: duration ?? const Duration(milliseconds: 400),
    transitionBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return DialogTransitions.buildTransition(
        animationType: animationType,
        animation: animation,
        curve: curve,
        alignment: alignment,
        axis: axis,
        child: child,
      );
    },
  );
}