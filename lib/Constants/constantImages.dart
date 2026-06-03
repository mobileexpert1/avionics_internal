class AtmosphereAssets {
  static const String exosphereQuiz = "42Exosphere";
  static const String thermosphereQuiz = "43Thermosphere";
  static const String mesosphereQuiz = "44Mesosphere";
  static const String stratosphereQuiz = "45Stratosphere";
  static const String troposphereQuiz = "46Troposphere";

  static String getAsset(String layer) {
    switch (layer) {
      case "Exosphere":
        return exosphereQuiz;
      case "Thermosphere":
        return thermosphereQuiz;
      case "Mesosphere":
        return mesosphereQuiz;
      case "Stratosphere":
        return stratosphereQuiz;
      case "Troposphere":
        return troposphereQuiz;
      default:
        return "";
    }
  }
}

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

  static const String calculatorProfile = '25Calculator';
  static const String conversionProfile = '26Conversion';
  static const String formulasProfile = "27Formulas";
  static const String glossaryProfile = "28Glossary";
  static const String badgeProfile = "29badgeIcon";
  static const String progressProfile = "30ProgressState";
  static const String savedProfile = "31SavedIcon";
  static const String manageAccountProfile = "32ManageAccount";
  static const String subscriptionProfile = "33Subscriptions";
  static const String logoutProfile = "34LogoutIcon";
  static const String deleteProfile = "35DeleteIcons";
  static const String tutorialVideoProfile = "36TutorialVideo";
  static const String reviewsProfile = "37Reviews";
  static const String customerSupportProfile = "38CustomerSupport";
  static const String privacyPolicyProfile = "39PrivacyPolicy";
  static const String termsAndConditionsProfile = "40Terms&Conditions";
  static const String aboutProfile = "41About";
  static const String liveTrackImage = "47LiveTrackImage";
  static const String quizLockArrow = "48QuizLockArrow";
  static const String crossIconSubscription = "49CrossIcon";
  static const String wilcoChatLogo = "50WilcoChatLogo";
  static const String wilcoChatUser = "51ChatUser";
  static const String wilcoChatBoat = "52ChatBoat";
  static const String wilcoChatMic = "53WilcoMic";
  static const String wilcoAttention = "54WilcoAttention";
  static const String highlightStar = "55HighlightStar";
  static const String unHighlightStar = "55_1UnHighlightStar";
  static const String backArrowButton = "56BackArrowButton";
  static const String contactSupport = "57ContactSupport";
  static const String infoWrongFirst = "58InfoWrongGameIcon";
  static const String infoWrongSecond = "59InfoWrongGameIcon";
  static const String infoWrongThird = "60InfoWrongGameIcon";
  static const String gameInfoClose = "61GameInfoClose";
  static const String towerImageForGame = "62TowerImage";
  static const String aeroplaneManufacturer = "63AeroplaneManufacturer";

  static const String takeMeasureUnSelected = "65TakeMeasureUnSelected";
  static const String flightMathUnSelected = "66FlightMathUnSelected";
  static const String greenBlueUnSelected = "67GreenBlueUnSelected";
  static const String mindSeparationUnSelected = "68MindSeparationUnSelected";

  static const String takeMeasureSelected = "69TakeMeasureSelected";
  static const String flightMathSelected = "70FlightMathSelected";
  static const String greenBlueSelected = "71GreenBlueSelected";
  static const String mindSeparationSelected = "72MindSeparationSelected";

  static const String timeLevelIcon = "73TimeIcon";
  static const String questionLevelIcon = "74QuestionIcon";
  static const String aeroplaneLevelIcon = "75AeroplaneIcon";
  static const String correctLevelAnswer = "76CorrectAnswer";
  static const String speedLevelBounce = "77SpeedBounce";
  static const String perfectLevelBounce = "78PerfectBounce";
  static const String winnerLevelIcon = "79WinnerIcon";
  static const String carHelpLevelIcon = "80CarHelpIcon";

  static const String editForChat = "81EditForChat";
  static const String deleteForChat = "82DeleteForChat";

  static const String aeroplaneBasic = "84AeroplaneBasic";
  static const String settingBasic = "85SettingBasic";
  static const String trackBasic = "86TrackBasic";
  static const String aeroplaneClouds = "87AeroplaneClouds";
  static const String notesBasic = "88NotesBasic";
  static const String userBasic = "89UserBasic";
  static const String manageEditIcon = "90ManageEditIcon";

  static const String visibilityOff = "91VisibilityOff";
  static const String visibilityOn = "92VisibilityOn";
  static const String emailIcon = "93EmailIcon";
  static const String bookMarkIcon = "94BookmarkIcon";
  static const String airBusPlanePlaceholder = "95AirBusPlanePlaceholder";
  static const String airportIcon = "96AirportIcon";
  static const String appleIcon = "97AppleIcon";
  static const String googleIcon = "98GoogleIcon";
  static const String facebookIcon = "99FacebookIcon";



  static const String MapIcon = "MapIcon";
  static const String chatIcon = "chatIcon";
  static const String ProfileIcon = "ProfileIcon";

  static const String undraw_aircraft_fbvl = "undraw_aircraft_fbvl1";
  static const String mapLayers = "MpaLayes";
  static const String map = "map";
  static const String successIcon = "successIcon";
  static const String compare = "compare";
  static const String filter = "filter";
  static const String logoMain = "mainLogo";
  static const String splashLogo = "splashLogo";
  static const String trackIcon = "TrackIcon";
  static const String tickIcon = "TickIcon";
  static const String sliders = "Sliders";
  static const String WebAppLogo = "WebAppLogo";
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
  static const String quizDetail = "quizICon2";
  static const String onewordDetail = "oneWordICon2";
  static const String calculationDetail = "calculationIcon2";
  static const String compare1 = "compare1";

  static const String avtarAcc = "Avatar";
  static const String bagdestarIcon = "bagdestarIcon";

  static const String avtarSecond = "AvtarSecond";

  static const String loginIcon = "loginIcon";
  static const String otpIcon = "otpIcon";
  static const String signinIcon = "signinIcon";

  static const String oneWord = "oneWorldIcon";
  static const String blackBox = "blackBoxIcon";
  static const String calculations = "calculationIcon";
  static const String Blackboxlogo = "gameBlackboxlogo";

  static const String mapPopupAircraft = "MapPopupAircraft";
  static const String mapPopupLivearea = "MapPopupLivearea";
  static const String closeIcon = "closeMapIcon";
  static const String closeIconsearch = "closeIconsearch";
  static const String infoIcon2 = "infoIcon2";

  static const String airbus = "airbus";
  static const String aeroplaneComparison = "aeroplaneComparison";
  static const String boeinglogo = "boeinglogo";

  static const String badgeimg = "badgeimg";
  static const String carFollowImage = "CarFollowIcon";

  static const String gifTimeoutAlert = "timeout";

  ///jpg
  static const String explore = "explore";

  static const deleteForCal = 'assets/images/delete.svg';
  static const expandForCal = 'assets/images/expand.svg';
  static const historyForCal = 'assets/images/history.svg';
  static const switchLGridForCal = 'assets/images/switch.svg';
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
