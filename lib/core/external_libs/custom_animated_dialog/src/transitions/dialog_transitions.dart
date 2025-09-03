import 'package:flutter/material.dart';
import '../enums/dialog_transition_type.dart';

class DialogTransitions {
  static Widget buildTransition({
    required DialogTransitionType animationType,
    required Animation<double> animation,
    required Curve curve,
    required Alignment alignment,
    Axis? axis,
    required Widget child,
  }) {
    switch (animationType) {
      case DialogTransitionType.fade:
        return FadeTransition(opacity: animation, child: child);

      case DialogTransitionType.slideFromRight:
        return SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation),
          child: child,
        );

      case DialogTransitionType.slideFromLeft:
        return SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation),
          child: child,
        );

      case DialogTransitionType.slideFromRightFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );

      case DialogTransitionType.slideFromLeftFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );

      case DialogTransitionType.slideFromTop:
        return SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation),
          child: child,
        );

      case DialogTransitionType.slideFromTopFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );

      case DialogTransitionType.slideFromBottom:
        return SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation),
          child: child,
        );

      case DialogTransitionType.slideFromBottomFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );

      case DialogTransitionType.scale:
        return ScaleTransition(
          alignment: alignment,
          scale: CurvedAnimation(
            parent: animation,
            curve: Interval(0, 0.50, curve: curve),
          ),
          child: child,
        );

      case DialogTransitionType.fadeScale:
        return ScaleTransition(
          alignment: alignment,
          scale: CurvedAnimation(
            parent: animation,
            curve: Interval(0, 0.50, curve: curve),
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: curve),
            child: child,
          ),
        );

      case DialogTransitionType.size:
        return Align(
          alignment: alignment,
          child: SizeTransition(
            sizeFactor: CurvedAnimation(parent: animation, curve: curve),
            axis: axis ?? Axis.vertical,
            child: child,
          ),
        );

      case DialogTransitionType.sizeFade:
        return Align(
          alignment: alignment,
          child: SizeTransition(
            sizeFactor: CurvedAnimation(parent: animation, curve: curve),
            child: FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: curve),
              child: child,
            ),
          ),
        );

      case DialogTransitionType.none:
        return child;
    }
  }
}