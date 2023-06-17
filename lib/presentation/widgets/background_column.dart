import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../res/app_res.dart';

class BackgroundColumn extends StatelessWidget {
  final double? topIndent;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  const BackgroundColumn({
    super.key,
    required this.children,
    this.topIndent,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //* Background Curve
        Positioned(
          child: SizedBox(
            width: 1.sw,
            height: 0.3262.sh,
            child: SvgPicture.asset(
              AppImages.backgroundCurved,
              fit: BoxFit.fill,
            ),
          ),
        ),
        //* Logo
        Positioned(
          top: 52.h,
          left: 18.04.w,
          right: 18.2.w,
          child: Image.asset(
            AppImages.logo,
            width: 378.76,
            height: 37.0,
          ),
        ),
        //* Contents
        Positioned.fill(
          top: topIndent ?? 0.1272.sh,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}
