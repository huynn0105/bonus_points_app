import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextFormField extends StatelessWidget {
  final String? lable;
  final controller;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final double? width;
  final int? maxLines;
  final bool readOnly;
  final bool isWithdraw;

  const MyTextFormField({
    Key? key,
    this.lable,
    this.controller,
    this.textInputType,
    this.inputFormatters,
    this.obscureText = false,
    this.validator,
    this.width,
    this.maxLines,
    this.readOnly = false,
    this.isWithdraw = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (lable != null)
          Text(
            lable!,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        SizedBox(height: 5),
        SizedBox(
          height: maxLines == null ? 60 : null,
          width: width ?? 450,
          child: TextFormField(
            readOnly: readOnly,
            keyboardType: textInputType,
            controller: controller,
            maxLines: maxLines,
            minLines: maxLines,
            validator: validator,
            obscureText: obscureText,
            style: TextStyle(
              decoration: isWithdraw ? TextDecoration.lineThrough : null,
            ),
            decoration: InputDecoration(
              hintText: lable,
              contentPadding: EdgeInsets.all(12.r),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            inputFormatters: inputFormatters,
          ),
        ),
      ],
    );
  }
}
