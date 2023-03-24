import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Color? color;
  final Widget child;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double? borderRadius;

  const MyButton({
    Key? key,
    this.color,
    this.width,
    this.height,
    this.borderRadius,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? 140, height ?? 49),
        primary: color,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
        ),
      ),
    );
  }
}
