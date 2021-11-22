import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyButton extends StatelessWidget {
  final Color? color;
  final Widget child;
  final Function() onPressed;
  final double? width;
  final double? height;

  const MyButton({
    Key? key,
    this.color,
    this.width,
    this.height,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? double.infinity, height ?? 44.h),
        primary: color,
        elevation: 1,
      ),
    );
  }
}
