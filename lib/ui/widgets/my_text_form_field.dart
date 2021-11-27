import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextFormField extends StatelessWidget {
  final Widget? lable;
  final controller;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  const MyTextFormField({
    Key? key,
    this.lable,
    this.controller,
    this.textInputType,
    this.inputFormatters,
    this.obscureText = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      controller: controller,
      validator: validator,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      obscureText: obscureText,
      decoration: InputDecoration(
        label: lable,
        contentPadding: EdgeInsets.all(20.r),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13.r),
        ),
        labelStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
      ),
      inputFormatters: inputFormatters,
    );
  }
}
