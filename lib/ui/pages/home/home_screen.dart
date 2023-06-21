import 'dart:math';

import 'package:flutter/material.dart';
import 'package:generated_color/utils/app_colors.dart';
import 'package:get/get.dart';

import '../../../repository/auth_service.dart';
import '../../../utils/routes.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class HomeController extends GetxController {
  final AuthService _authService = AuthService();
  RxBool isLoading = false.obs;
  RxInt colorIndex = Random().nextInt(Colors.primaries.length).obs;
  Rx<Color> generatedColor = const Color.fromRGBO(255, 255, 255, 1).obs;
  final Random random = Random();

  Future<void> logout() async {
    isLoading.value = true;
    try {
      Get.offAndToNamed(Routes.root);
      await _authService.logout();
    } on Exception catch (e) {
      print(e);
    }
    isLoading.value = false;
  }

  void changeColor() {
    generatedColor.value = Color.fromRGBO(
      random.nextInt(255),
      random.nextInt(255),
      random.nextInt(255),
      random.nextDouble(),
    );
  }

  void changeColorIndex() {
    colorIndex.value = Random().nextInt(Colors.primaries.length);
  }
}

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Obx(
        () => GestureDetector(
          onTap: () => controller.changeColor(),
          child: Scaffold(
            backgroundColor: controller.generatedColor.value,
            body: GestureDetector(
              onTap: () => controller.changeColorIndex(),
              child: Center(
                child: Text(
                  'Hello there',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.primaries[controller.colorIndex.value],
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async => !controller.isLoading.value
                  ? await controller.logout()
                  : null,
              label: Text(
                'log_out'.tr,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
