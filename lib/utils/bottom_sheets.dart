import 'dart:async';

import 'package:flutter/material.dart';

import '../res/app_res.dart';

///A modal bottom sheet with fixed header, footer & scrollable body.
///[sheetStreamController] should not has any listeners pre-added.
///[sheetStreamController] management is on the caller (subject to change).
Future showEzModalBottomSheet(
  BuildContext context, {
  Widget? header,
  Widget? body,
  Widget? footer,
  void Function(Object?)? onPop,
}) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    isScrollControlled: true,
    builder: (context) => AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: EzBottomSheet(header: header, body: body, footer: footer),
    ),
  ).then((value) => (onPop != null) ? onPop(value) : null);
}

class EzBottomSheet extends StatelessWidget {
  final Widget? header;
  final Widget? body;
  final Widget? footer;
  final BorderRadius borderRadius;
  final ScrollController? scrollController;
  final VoidCallback? onHandleTap;
  final bool scrollable;
  final bool fixedSize;
  const EzBottomSheet({
    Key? key,
    this.header,
    this.body,
    this.footer,
    this.borderRadius = BorderRadius.zero,
    this.scrollController,
    this.onHandleTap,
    this.scrollable = true,
    this.fixedSize = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return ConstrainedBox(
      constraints: fixedSize
          ? BoxConstraints.loose(
              Size.fromHeight(mediaQuery.size.height *
                  (mediaQuery.orientation == Orientation.portrait
                      ? 0.45
                      : 0.60)),
            )
          : BoxConstraints.loose(mediaQuery.size),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //* Handle Bar
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                child: SizedBox(
                  height: 16.0,
                  child: Divider(
                    indent: mediaQuery.size.width * 0.35,
                    endIndent: mediaQuery.size.width * 0.35,
                    thickness: 3.0,
                    color: AppColors.gunGrey,
                    height: 0.0,
                  ),
                ),
                onTap: () {
                  if (onHandleTap != null) {
                    onHandleTap!();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              //* Header
              header ?? const SizedBox.shrink(),
              //* Scrollable Body
              Flexible(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: body ?? const SizedBox.shrink(),
                ),
              ),
              //* Footer
              footer ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
