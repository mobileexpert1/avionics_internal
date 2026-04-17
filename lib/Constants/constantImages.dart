abstract class AssetsPath {
  /// svg Images

  //home Screen
  static const String mainLogo = "0MainLogo";
  static const String avionicaHome = "1avionicaHome";
  static const String homeLeftMainLogo = "2homeLeftMainLogo";
  static const String homeRightSetting = "3homeRightSetting";
  static const String homeCompareAircraft = "4homeCompareAircraft";
  static const String homeManufacturerLibrary = "5homeManufacturerLibrary";
  static const String homeWilco = "6homeWilco";
  static const String homeLiveTracking = "7HomeLiveTracking";
  static const String compareLogo = "8CompareLogo";
  static const String compareFilter = "9CompareFilter";
  static const String generalCompare = "10GeneralCompare";
  static const String technicalCompare = "11TechnicalCompare";
  static const String searchIcon = "12SearchIcon";

  static const String exploreTabBarIcon = "13ExploreTabBar";
  static const String unExploreTabBarIcon = "14UnExploreTabBar";
  static const String trackTabBarIcon = "15TrackTabBar";
  static const String unTrackTabBarIcon = "16UnTrackTabBar";
  static const String gamesTabBarIcon = "17GamesTabBar";
  static const String unGamesTabBarIcon = "18UnGamesTabBar";
  static const String wilcoTabBarIcon = "19WilcoTabBar";
  static const String unWilcoTabBarIcon = "20UnWilcoTabBar";
  static const String profileTabBarIcon = "21ProfileTabBar";
  static const String unProfileTabBarIcon = "22UnProfileTabBar";
  static const String compareAeroPlaneIcon = "23CompareAeroPlaneIcon";
  static const String backArrowForPop = "24BackArrowForPop";

  static const String ExploreIcon = "ExploreIcon";
  static const String ExploreUnSelectedIcon = "ExploreIconUnSelected";

  static const String MapIcon = "MapIcon";
  static const String gameIcon = "gameIcon";
  static const String chatIcon = "chatIcon";
  static const String ProfileIcon = "ProfileIcon";

  static const String tutorialVideo = "TutorialVideo";
  static const String undraw_aircraft_fbvl = "undraw_aircraft_fbvl1";
  static const String mapLayers = "MpaLayes";
  static const String map = "map";
  static const String successIcon = "successIcon";
  static const String compare = "compare";
  static const String filter = "filter";
  static const String apple = "Apple";
  static const String facebook = "Facebook";
  static const String google = "Google";
  static const String logoMain = "mainLogo";
  static const String splashLogo = "splashLogo";
  static const String manufacturer = "manufacturer";
  static const String starIcon = "StarIcon";
  static const String star = "star";
  static const String trackIcon = "TrackIcon";
  static const String tickIcon = "TickIcon";
  static const String sliders = "Sliders";
  static const String WebAppLogo = "WebAppLogo";
  static const String search = "search";
  static const String comparsion = "Comparsion";
  static const String selectModel = "SelectModel";
  static const String Chatbot = "Chatbot";
  static const String upArrow = "upArrow";
  static const String downArrow = "downArrow";
  static const String Plane1 = "Plane1";
  static const String ChatIcon = "Chatbot";
  static const String SendIcon = "SendIcon";
  static const String flyingareaicon = "flyingareaicon";
  static const String instantAI = "instantAI";
  static const String Quiz = "Quiz";
  static const String chatHistoryicon = "chatHistoryicon";
  static const String manuFirstImage = "ManuFirstImage";
  static const String LockIcon = "LockIcon";
  static const String badgesLock = "badgesLock";
  static const String badgeTrophy = "badgeTrophy";
  static const String resultIcon = "resultIcon";
  static const String Tik = "TickIcon";
  static const String Trophy = "Trophy";
  static const String clock = "clock";
  static const String quizDetail = "quizICon2";
  static const String onewordDetail = "oneWordICon2";
  static const String calculationDetail = "calculationIcon2";
  static const String compare1 = "compare1";
  static const String backgroundImageComapre = "backgroundImageComapre";

  static const String deleteAcc = "Delete";
  static const String deleteAccSvg = "deleteIconsSvg";
  static const String contactAcc = "Contact";
  static const String reviewsAcc = "Reviews";
  static const String glossaryAcc = "Glossary";
  static const String unitMeasureAcc = "UnitsMeasurments";
  static const String savedIcon = "savedIcon";
  static const String avtarAcc = "Avatar";
  static const String subsrcitAcc = "Subscriptions";
  static const String manageAccountAcc = "manageAccount";
  static const String editIcon = "EditIcon";
  static const String badgeIcon = "badgeIcon";
  static const String bagdestarIcon = "bagdestarIcon";

  static const String avtarSecond = "AvtarSecond";

  static const String loginIcon = "loginIcon";
  static const String otpIcon = "otpIcon";
  static const String logoutIcon = "logoutIcon";
  static const String signinIcon = "signinIcon";

  static const String quiz = "quizIcon";
  static const String oneWord = "oneWorldIcon";
  static const String blackBox = "blackBoxIcon";
  static const String calculations = "calculationIcon";
  static const String Blackboxlogo = "gameBlackboxlogo";

  static const String mapPopupAircraft = "MapPopupAircraft";
  static const String mapPopupLivearea = "MapPopupLivearea";
  static const String aircraftIconmap = "aircraftIconmap";
  static const String closeIcon = "closeMapIcon";
  static const String closeIconsearch = "closeIconsearch";
  static const String infoIcon2 = "infoIcon2";

  /// png
  static const String CompareIcon = "CompareIcon";

  static const String SavedIcon = "SavedIcon";
  static const String airbus = "airbus";
  static const String aeroplaneComparison = "aeroplaneComparison";
  static const String boeinglogo = "boeinglogo";
  static const String DhcLogo = "DhcLogo";
  static const String airbusplane = "airbusplane";
  static const String HistoryImg = "HistoryImg";
  static const String badgeimg = "badgeimg";
  static const String carFollowImage = "CarFollowIcon";

  static const String gifTimeoutAlert = "timeout";

  ///jpg
  static const String explore = "explore";

  static const deleteForCal = 'assets/images/delete.svg';
  static const expandForCal = 'assets/images/expand.svg';
  static const historyForCal = 'assets/images/history.svg';
  static const switchLGridForCal = 'assets/images/switch.svg';

  static const calculatorImage = 'Calculator';
  static const conversionImage = 'Conversion';
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

  static String setGifImage(String image) {
    return 'assets/gif/$image.gif';
  }
}

