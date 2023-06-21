import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_colors.dart';

Widget userInfoItem(
    {required String icon, required String label, required String info}) {
  return Container(
    padding: const EdgeInsets.only(left: 24, right: 0, bottom: 22, top: 22),
    margin: const EdgeInsets.only(left: 30, right: 30),
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: AppColors.borderColor),
    ),
    child: Row(
      children: [
        SvgPicture.asset(
          icon,
        ),
        const SizedBox(width: 15),
        Container(
          height: 40,
          width: 1,
          color: AppColors.borderColor,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.whiteOpacity,
                ),
              ),
              Text(
                info,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
