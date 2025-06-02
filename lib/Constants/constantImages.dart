
abstract class AssetsPath {
  /// svg Images
  static const String splashImage = "splashImage";
  static const String undraw_aircraft_fbvl = "undraw_aircraft_fbvl";
  static const String map = "map";
  static const String compare = "compare";
  static const String filter = "filter";
  static const String apple = "Apple";
  static const String facebook = "Facebook";
  static const String google = "Google";
  static const String logoMain = "LogoMain";


  // jpg images
  static const String explore = "explore";

}


class CommonUi {
  //
  static String setjpgImage(String image) {
    // return 'assets/images/$image.png';
    return 'assets/jpg_images/$image.jpg';

  }
  //
  // static String setPngNavImage(String image) {
  //   // return 'assets/images/$image.png';
  //   return 'assets/navIcons/$image.png';
  // }

  static String setSvgImage(String image) {
    return 'assets/svg_images/$image.svg';

  }
}