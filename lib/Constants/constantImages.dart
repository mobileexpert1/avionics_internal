
abstract class AssetsPath {
  /// png Images
  static const String splashImage = "splashImage";
  static const String undraw_aircraft_fbvl = "undraw_aircraft_fbvl";
  static const String map = "map";
  static const String compare = "compare";
  static const String filter = "filter";
  static const String explore = "explore";
}


class CommonUi {
  //
  // static String setPngImage(String image) {
  //   // return 'assets/images/$image.png';
  //   return 'assets/icons/$image.png';
  //
  // }
  //
  // static String setPngNavImage(String image) {
  //   // return 'assets/images/$image.png';
  //   return 'assets/navIcons/$image.png';
  // }

  static String setSvgImage(String image) {
    return 'assets/svg_images/$image.svg';

  }
}