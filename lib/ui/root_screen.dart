import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/auth_service.dart';
import 'pages/home/home_screen.dart';
import 'pages/login/login_screen.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<AuthService>(
      builder: (api) {
        switch (api.appState.value) {
          case AppState.initial:
            return const LoginScreen();
          case AppState.authenticated:
            return const HomeScreen();
        }
      },
    );
  }
}
