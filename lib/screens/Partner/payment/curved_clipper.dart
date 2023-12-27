import 'package:flutter/material.dart';

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30); // Start at the top-left
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 30); // Create a quadratic bezier curve
    path.lineTo(size.width, 0); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}