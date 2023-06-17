
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';


class Helpers {
  Helpers._();
  static bool isRTL(BuildContext context) {
    return Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);
  }

  /// How many children can a row contain in respect to passed parameters.
  static int getResponsiveRowLength({
    required double screenWidth,
    required double singleChildWidth,
    required double interCardSpacing,
    required double totalHorizontalPadding,
  }) {
    return (screenWidth - totalHorizontalPadding + interCardSpacing) ~/
        (singleChildWidth + interCardSpacing);
  }
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}
