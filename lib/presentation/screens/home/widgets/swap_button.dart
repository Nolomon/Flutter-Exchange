import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../res/app_res.dart';

class SwapButton extends StatefulWidget {
  final void Function(bool canSwap) onPressed;
  const SwapButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<SwapButton> createState() => _SwapButtonState();
}

class _SwapButtonState extends State<SwapButton> {
  bool canSwap = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        radius: 10,
        child: Container(
          width: 42.h,
          height: 42.h,
          clipBehavior: Clip.hardEdge,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.tertiary
                : null,
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(AppImages.swap),
        ),
        onTap: () {
          setState(() => canSwap = !canSwap);
          widget.onPressed(canSwap);
        },
      ),
    )
        .animate(
          target: canSwap ? 1 : 0,
        )
        .flip(
          begin: 0,
          end: 1,
          duration: 500.ms,
        )
        .scaleXY(end: 1.35, duration: 250.ms)
        .then()
        .scaleXY(end: 1 / 1.35);
  }
}
