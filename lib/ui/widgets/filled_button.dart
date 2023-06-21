import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

Widget filledButton(
    {required Function onTap,
    required String title,
    bool isLoading = false,
    double margin = 24}) {
  return InkWell(
    onTap: !isLoading ? () async => await onTap() : null,
    child: Container(
      width: Get.width,
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 80.0),
      margin: EdgeInsets.only(left: margin, right: margin),
      decoration: const BoxDecoration(
        color: AppColors.mainColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading
              ? const SizedBox(
                  width: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 1,
                  ),
                )
              : Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
        ],
      ),
    ),
  );
}
