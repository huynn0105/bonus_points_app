import 'package:bonus_points_app/global/router.dart';
import 'package:bonus_points_app/ui/screen/home_screen/home_screen.dart';
import 'package:bonus_points_app/ui/widgets/my_button.dart';
import 'package:bonus_points_app/ui/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextFormField(
              lable: Text('Tên đăng nhập'),
              controller: usernameController,
            ),
            SizedBox(height: 16.h),
            MyTextFormField(
              lable: Text('Mật khẩu'),
              controller: passwordController,
              obscureText: true,
            ),
            SizedBox(height: 20.h),
            MyButton(
              onPressed: () {
                if (usernameController.text == 'admin' &&
                    passwordController.text == 'admin') {
                  Get.offAllNamed(MyRouter.splash);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Tên đăng nhập hoặc mật khẩu không chính xác!',
                        style: TextStyle(fontSize: 15.sp),
                      ),
                      actions: [
                        MyButton(
                          child: Text(
                            'Xác nhận',
                            style: TextStyle(
                              fontSize: 15.sp,
                            ),
                          ),
                          width: 50.w,
                          height: 44.h,
                          onPressed: () {
                            Get.back();
                          },
                          color: Color(0xFFEA2027).withOpacity(0.86),
                        ),
                      ],
                    ),
                  );
                }
              },
              height: 44.h,
              child: Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
