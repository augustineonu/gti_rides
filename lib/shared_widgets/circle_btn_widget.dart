import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuicklydropCircleButton extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final double size;

  const QuicklydropCircleButton({
    Key? key,
    required this.icon,
    required this.onTap,
    required this.color,
    required this.iconColor,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          onTapDown: (_) => HapticFeedback.lightImpact(),
          splashColor: color.withOpacity(0.5),
          onTap: () => onTap(),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
