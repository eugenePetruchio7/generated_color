import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_colors.dart';

Widget socialContainer(String icon) {
  return Container(
    padding: icon == 'assets/icons/facebook_icon.svg'
        ? const EdgeInsets.only(left: 28, right: 28, bottom: 22, top: 22)
        : const EdgeInsets.only(left: 24, right: 24, bottom: 22, top: 22),
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border.all(color: AppColors.borderColor),
    ),
    child: SvgPicture.asset(
      icon,
    ),
  );
}
