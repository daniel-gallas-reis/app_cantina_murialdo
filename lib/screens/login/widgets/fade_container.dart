import 'package:flutter/material.dart';

class FadeContainer extends StatelessWidget {

  final Animation<Color> fadeAnimation;
  const FadeContainer({@required this.fadeAnimation});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'fadeScreen',
      child: Container(
        decoration: BoxDecoration(
            color: fadeAnimation.value
        ),
      ),
    );
  }
}
