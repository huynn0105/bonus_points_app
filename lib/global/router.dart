import 'package:bonus_points_app/core/ui_model/customer_ui_model.dart';
import 'package:bonus_points_app/ui/screen/add_customer_screen/add_customer_screen.dart';
import 'package:bonus_points_app/ui/screen/customer_detail_screen/customer_detail_screen.dart';
import 'package:bonus_points_app/ui/screen/home_screen/home_screen.dart';
import 'package:bonus_points_app/ui/screen/sign_in_screen/sign_in_screen.dart';
import 'package:bonus_points_app/ui/screen/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

class MyRouter {
  static const String splash = '/splash';
  static const String signin = '/signin';
  static const String home = '/home';
  static const String addCustomer = '/addCustomer';
  static const String detail = '/detail';

  static PageRouteBuilder _buildRouteNavigation(
      RouteSettings settings, Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => widget,
      settings: settings,
    );
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRouteNavigation(
          settings,
          SplashScreen(),
        );
      case signin:
        return _buildRouteNavigation(
          settings,
          SignInScreen(),
        );
      case home:
        return _buildRouteNavigation(
          settings,
          HomeScreen(),
        );
      case addCustomer:
        return _buildRouteNavigation(
          settings,
          AddCustomerScreen(
            customer: settings.arguments != null
                ? settings.arguments as CustomerUIModel
                : null,
          ),
        );
      case detail:
        return _buildRouteNavigation(
          settings,
          CustomerDetailScreen(
            customer: settings.arguments as CustomerUIModel,
          ),
        );
    }
  }
}
