import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../repository/auth_service.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/routes.dart';
import '../../widgets/filled_button.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RxBool signInMode = true.obs;
  RxBool obscurePassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;
  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs;

  void toggleLoginMode() {
    passwordController.clear();
    confirmPasswordController.clear();
    errorMessage.value = '';
    signInMode.toggle();
  }

  Future<void> login() async {
    if (isLoading.value) {
      return;
    }
    isLoading.value = true;
    if (userNameController.text.isEmpty) {
      errorMessage.value = 'login_or_password_empty'.tr;
      isLoading.value = false;
      return;
    }
    if (passwordController.text.isEmpty) {
      errorMessage.value = 'login_or_password_empty'.tr;
      isLoading.value = false;
      return;
    }
    if (!signInMode.value &&
        passwordController.text != confirmPasswordController.text) {
      errorMessage.value = 'password_mismatch'.tr;
      isLoading.value = false;
      return;
    }
    if (signInMode.value) {
      errorMessage.value = await _authService.login(
          email: userNameController.text, password: passwordController.text);
    } else {
      errorMessage.value = await _authService.register(
          email: userNameController.text, password: passwordController.text);
    }
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Get.offAndToNamed(Routes.home);
    }
    isLoading.value = false;
  }
}

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          titleSpacing: 0,
          leading: Obx(
            () => !controller.signInMode.value
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.titleColor,
                    ),
                    onPressed: () => controller.toggleLoginMode(),
                  )
                : const SizedBox.shrink(),
          ),
          title: Obx(
            () => Text(
              controller.signInMode.value ? 'sign_in'.tr : 'sign_up'.tr,
              style: const TextStyle(
                color: AppColors.titleColor,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: InkWell(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/icons/menu_icon.svg',
                ),
              ),
            )
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            height: Get.height,
            width: Get.width,
            color: AppColors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Obx(
                    () => Image(
                      image: AssetImage(
                        controller.signInMode.value
                            ? 'assets/images/sign_in_img.png'
                            : 'assets/images/sign_up_img.png',
                      ),
                      height: 145,
                      width: controller.signInMode.value ? 100 : 145,
                    ),
                  ),
                  SizedBox(
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 50.0, left: 30.0, right: 30.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            child: Obx(
                              () => TextFormField(
                                controller: controller.userNameController,
                                keyboardType: TextInputType.emailAddress,
                                enableSuggestions: false,
                                autocorrect: false,
                                cursorColor: Colors.blueGrey[800],
                                onChanged: (username) {},
                                decoration: InputDecoration(
                                  hintText: controller.signInMode.value
                                      ? 'username_title'.tr
                                      : 'enter_email_title'.tr,
                                  hintStyle: const TextStyle(
                                    color: AppColors.inputTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                  fillColor: AppColors.inputFillColor,
                                  filled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 22, top: 15, bottom: 15, right: 22),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, left: 30.0, right: 30.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            child: Obx(
                              () => TextFormField(
                                controller: controller.passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                enableSuggestions: false,
                                autocorrect: false,
                                obscureText: controller.obscurePassword.value,
                                cursorColor: Colors.blueGrey[800],
                                onChanged: (password) {},
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 22, top: 15, bottom: 15, right: 22),
                                  border: InputBorder.none,
                                  fillColor: AppColors.inputFillColor,
                                  filled: true,
                                  hintText: controller.signInMode.value
                                      ? 'password_title'.tr
                                      : 'enter_password_title'.tr,
                                  hintStyle: const TextStyle(
                                    color: AppColors.inputTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        controller.obscurePassword.toggle(),
                                    icon: controller.obscurePassword.value
                                        ? SvgPicture.asset(
                                            'assets/icons/obscure_password.svg')
                                        : const Icon(
                                            Icons.remove_red_eye_sharp,
                                            color: AppColors.passwordEyeColor,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => !controller.signInMode.value
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, left: 30.0, right: 30.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50.0,
                                    child: TextFormField(
                                      controller:
                                          controller.confirmPasswordController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      obscureText: controller
                                          .obscureConfirmPassword.value,
                                      cursorColor: Colors.blueGrey[800],
                                      onChanged: (password) {},
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 22,
                                            top: 15,
                                            bottom: 15,
                                            right: 22),
                                        border: InputBorder.none,
                                        fillColor: AppColors.inputFillColor,
                                        filled: true,
                                        hintText:
                                            'enter_password_confirm_title'.tr,
                                        hintStyle: const TextStyle(
                                          color: AppColors.inputTextColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () => controller
                                              .obscureConfirmPassword
                                              .toggle(),
                                          icon: controller
                                                  .obscureConfirmPassword.value
                                              ? SvgPicture.asset(
                                                  'assets/icons/obscure_password.svg')
                                              : const Icon(
                                                  Icons.remove_red_eye_sharp,
                                                  color: AppColors
                                                      .passwordEyeColor,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        Obx(
                          () => controller.signInMode.value
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 14.0, right: 30.0),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Text(
                                        'forgot_password_title'.tr,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        Obx(
                          () {
                            if (controller.errorMessage.value.isNotEmpty) {
                              return Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30.0, right: 30.0, top: 8.0),
                                  child: Text(
                                    controller.errorMessage.value,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        Obx(
                          () => filledButton(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              await controller.login();
                            },
                            title: controller.signInMode.value
                                ? 'login_title'.tr
                                : 'sign_up'.tr,
                            isLoading: controller.isLoading.value,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'or'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.signInMode.value
                                    ? 'account_not_exist'.tr
                                    : 'account_exist'.tr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor,
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.toggleLoginMode(),
                                child: Text(
                                  controller.signInMode.value
                                      ? 'sign_up'.tr
                                      : 'sign_in'.tr,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.linkColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
