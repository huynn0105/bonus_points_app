import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextFormField extends StatelessWidget {
  final Widget? lable;
  final controller;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  const MyTextFormField({
    Key? key,
    this.lable,
    this.controller,
    this.textInputType,
    this.inputFormatters,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      controller: controller,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 15.sp,
      ),
      obscureText: obscureText,
      decoration: InputDecoration(
        label: lable,
        contentPadding: EdgeInsets.all(16.r),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        labelStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w300,
        ),
      ),
      inputFormatters: inputFormatters,
    );
  }
}
