part of app_res;

class AppColors {
  AppColors._();
  // Primaries
  static Color primary = purple;

  // Swatches
  static MaterialColor primarySwatch =
      MaterialColor(primary.value, <int, Color>{
    50: hexColor('#eeeaf1'),
    100: hexColor('#c9bfd3'),
    200: hexColor('#afa0bd'),
    300: hexColor('#8a749f'),
    400: hexColor('#74598d'),
    500: hexColor('#513070'),
    600: hexColor('#4a2c66'),
    700: hexColor('#3a2250'),
    800: hexColor('#2d1a3e'),
    900: hexColor('#22142f'),
  });

  // Colors
  static Color onPrimary = paleRoseLavender;
  static Color secondary = white;
  static Color onSecondary = lightGrey;
  static Color error = hexColor('#FF0202');
  static Color onError = white;
  static Color background = white;
  static Color onBackground = black;
  static Color surface = white;
  static Color onSurface = black;
  static Color cursorColor = primary;
  static Color textSelectionColor = purple.withOpacity(0.25);
  static Color textSelectionHandleColor = primary;
  static Color black = Colors.black;
  static const Color opaqueBlack = Color.fromRGBO(18, 1, 1, 0.68);
  static Color darkGrey = hexColor('#818181');
  static Color grey = hexColor('#7a767a');
  static Color lightGrey = hexColor('#B4B4B4');
  static Color veryLightGrey = hexColor('#DEDEDE');
  static Color extraLightGrey = hexColor('#F5F5F5');
  static const Color white = Colors.white;
  static const Color red = Colors.red;
  static Color purple = hexColor('#513070');
  static Color lightShadow = hexColor('#A8A8A8').withOpacity(0.20);
  static Color opaqueShadow = Colors.black.withOpacity(0.16);
  static Color titleBlack = hexColor('#120101').withOpacity(0.85);
  static Color chipBlack = hexColor('#4A4A4A');
  static Color gunGrey = hexColor('#4C4C4C');
  static Color darkCharcoal = hexColor('#333333');
  static Color blackLung = hexColor('#151515');
  static Color borderGrey = hexColor('#707070');
  static Color textFieldGrey = hexColor('#EDEDED');
  static Color blueQuestion = hexColor('#879FDE');
  static Color navyGrey = hexColor("#3C3C43").withOpacity(0.60);
  static Color whiteHorse = hexColor("#EBEBEB");
  static Color paleRoseLavender = hexColor("#EEEAF1");
  static Color appGradientColor1 = hexColor('#513070');
  static Color appGradientColor2 = hexColor('#331F46');

  // helpers
  static Color hexColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
