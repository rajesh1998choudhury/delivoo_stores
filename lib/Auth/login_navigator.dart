// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'MobileNumber/UI/phone_number.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
LoginProvider loginProvider = LoginProvider();

class LoginRoutes {
  static const String loginRoot = 'login/';
  static const String registration = 'login/registration';
  static const String verification = 'login/verification';
}

class LoginData {
  final String phoneNumber;
  final String name;
  final String email;

  LoginData(this.phoneNumber, this.name, this.email);
}

class LoginNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var canPop = navigatorKey.currentState?.canPop();
        if (canPop!) {
          navigatorKey.currentState!.pop();
        }
        return !canPop;
      },
      child: Navigator(
        key: navigatorKey,
        initialRoute: LoginRoutes.loginRoot,
        onGenerateRoute: (RouteSettings settings) {
          late WidgetBuilder builder;
          switch (settings.name) {
            case LoginRoutes.loginRoot:
              builder = (BuildContext _) => PhoneNumber();
              break;
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
        onPopPage: (Route<dynamic> route, dynamic result) {
          return route.didPop(result);
        },
      ),
    );
  }
}
