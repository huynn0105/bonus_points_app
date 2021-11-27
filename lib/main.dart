import 'package:bonus_points_app/core/view_model/implements/customer_view_model.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'global/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCcQaNsbUSUesVnJ5QSEgSrss5t5BXu7j8",
      authDomain: "accumulatepoints-49382.firebaseapp.com",
      databaseURL: "accumulatepoints-49382.firebaseio.com",
      projectId: "accumulatepoints-49382",
      storageBucket: "accumulatepoints-49382.appspot.com",
      messagingSenderId: "376016726467",
      appId: "1:376016726467:web:dbb7493c41ae76637b3576",
      measurementId: "G-XZTBM793NJ",
    ),
  );

  runApp(MyApp());
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
