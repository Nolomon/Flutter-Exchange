import 'package:flutter/material.dart';

///Unfocus input fields when tapping out.
class ControlledFocus extends StatelessWidget {
  final Widget child;

  ///Unfocus input fields when tapping out.
  const ControlledFocus({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (currentFocus.focusedChild != null &&
            !currentFocus.hasPrimaryFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
