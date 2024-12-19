import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  const ThemeButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current theme brightness to adjust button's background color
    Color buttonBackgroundColor = backgroundColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.red // Dark mode background color
            : Colors.redAccent); // Light mode background color

    return SizedBox(
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackgroundColor,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
