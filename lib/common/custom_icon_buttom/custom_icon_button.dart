import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {@required this.iconData,
      @required this.color,
      @required this.onTap,
      this.size});

  final Color color;
  final IconData iconData;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              iconData,
              color: onTap != null ? color : color.withAlpha(300),
              size: size ?? 24,
            ),
          ),
        ),
      ),
    );
  }
}
