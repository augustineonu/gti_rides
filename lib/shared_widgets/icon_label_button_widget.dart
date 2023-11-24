import 'package:flutter/material.dart';

import '../styles/styles.dart';

class IconLabelButton extends StatelessWidget {
  final String? label;
  final Function onTap;
  final IconData icon;
  final Color color;

  const IconLabelButton({
    super.key,
    required this.color,
    required this.icon,
    this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            SizedBox(width: 3),
            Text(
              label ?? '',
              style: getBoldStyle(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
