import 'package:flutter/material.dart';

import '../../../res/app_res.dart';

class RoundedModalBottomSheet extends StatelessWidget {
  final Widget? content;
  final double? radius;

  const RoundedModalBottomSheet({Key? key, this.content, this.radius})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff737373),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(radius ?? 15),
            topLeft: Radius.circular(radius ?? 15),
          ),
        ),
        child: content ?? const SizedBox(),
      ),
    );
  }
}

class CenteredCircularProgressIndicator extends StatelessWidget {
  const CenteredCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  final double? width, height;
  const AppLogo({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.logo,
      width: width,
      height: height,
    );
  }
}
