import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {

  const EmptyWidget({@required this.title, @required this.iconData});

  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
    );
  }
}
