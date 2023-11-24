import 'package:flutter/material.dart';

class ModalWidget extends ModalRoute<void> {
  final Widget child;

  ModalWidget({required this.child});

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.card,
      child: _buildOverlayContent(context),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return child;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    // return FadeTransition(
    //   opacity: animation,
    //   child: ScaleTransition(
    //     scale: animation,
    //     child: child,
    //   ),
    // );
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1, 0), // You can adjust the starting position
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
