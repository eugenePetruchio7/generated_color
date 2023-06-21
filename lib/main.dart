import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'repository/auth_service.dart';
import 'ui/application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initServices();

  runApp(const Application());
}

Future initServices() async {
  debugPrint('main:  initialize services ...');

  await Get.putAsync(() => AuthService().init());

  debugPrint('main:  all services is started ...');
}
