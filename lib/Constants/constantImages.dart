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
  static const String manufacturer = "manufacturer";
  static const String starIcon = "StarIcon";
  static const String star = "star";
  static const String trackIcon = "TrackIcon";
  static const String tickIcon = "TickIcon";
  static const String sliders = "Sliders";
  static const String avionicaHome = "avionicahome";
  static const String search = "search";
  static const String comparsion = "Comparsion";
  static const String selectModel = "SelectModel";
  static const String aeroplaneIcon = "aeroplaneIcon";
  static const String Chatbot = "Chatbot";
  static const String BackIcon = "BackIcon";


  //jpg
  // static const String airbus = "airbus";
  static const String explore = "explore";

  // png
  static const String aeroplane = "aeroplane";
  static const String aeroplane2 = "aeroplane2";
  static const String aeroplane3 = "aeroplane3";
  static const String CroatiaAirlineLogo = "CroatiaAirline";
  static const String AirFranceLogo = "AirFrance";
  static const String CompareIcon = "CompareIcon";
  static const String ExploreIcon = "ExploreIcon";
  static const String MapIcon = "MapIcon";
  static const String ProfileIcon = "ProfileIcon";
  static const String SavedIcon = "SavedIcon";
  static const String airbus = "airbus";
  static const String AirbusPageImage = "AirbusPageImage";
  static const String manufacturerLogo = "manufacturerLogo";
  static const String aeroplaneComparison = "aeroplaneComparison";
  static const String boeinglogo = "boeinglogo";
  static const String DhcLogo = "DhcLogo";
  static const String airbusplane = "airbusplane";
  static const String HistoryImg = "HistoryImg";

}

class CommonUi {

  static String setjpgImage(String image) {
    return 'assets/jpg_images/$image.jpg';
  }
  static String setPngImage(String image) {
    return 'assets/png_images/$image.png';
  }
  static String setSvgImage(String image) {
    return 'assets/svg_images/$image.svg';
  }
}
