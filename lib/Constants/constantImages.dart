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

  static const String starIcon = "StarIcon";
  static const String trackIcon = "TrackIcon";
  static const String tickIcon = "TickIcon";

  // jpg images
  static const String explore = "explore";
  static const String sliders = "Sliders";
  static const String avionicaHome = "avionicahome";
  static const String search = "search";
  static const String comparsion = "Comparsion";
  static const String selectModel = "SelectModel";

  // jpg images
  static const String manufacture = "manufacture";
}

class CommonUi {

  static String setjpgImage(String image) {
    return 'assets/jpg_images/$image.jpg';
  }

  static String setSvgImage(String image) {
    return 'assets/svg_images/$image.svg';
  }
}
