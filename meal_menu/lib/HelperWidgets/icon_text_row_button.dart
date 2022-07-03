import 'package:flutter/material.dart';

class IconTextRowButton extends StatelessWidget {
  final IconData icon;
  final String buttonText;

  const IconTextRowButton({
    key,
    required this.icon,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(Object context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(icon),
        const SizedBox(
          width: 10,
        ),
        Text(buttonText),
      ],
    );
  }
}
