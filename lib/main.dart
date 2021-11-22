import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bonus_points_app/core/view_model/implements/customer_view_model.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/global/locator.dart';
import 'package:bonus_points_app/ui/screen/sign_in_screen/sign_in_screen.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'global/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firestore.initialize('accumulatepoints-49382');
  await setupLocator();
  runApp(MyApp());

  if (Platform.isWindows) {
    doWhenWindowReady(() {
      const initialSize = Size(1024, 768);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.topCenter;
      appWindow.show();
    });
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ICustomerViewModel>(
          create: (_) => CustomerViewModel(),
        ),
      ],
      child: ScreenUtilInit(
        builder: () => GetMaterialApp(
          title: 'Điểm tích luỹ',
          onGenerateRoute: (settings) => MyRouter.generateRoute(settings),
          initialRoute: MyRouter.signin,
          color: Color(0xFF0A7AFF),
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'BeVietnam',
          ),
        ),
      ),
    );
  }
}
