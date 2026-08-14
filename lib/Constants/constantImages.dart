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
  ///
  static const String mainLogoWhiteColour = "0_0MainLogo";
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
  static const String gameInfoClose = "61GameInfoClose";
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
  static const String avtarPlaceholder = "100AvtarPlaceholder";

  static const String badgesLockIcon = "101BadgesLock";
  static const String badgeTrophyIcon = "102BadgeTrophy";
  static const String badgeStarIcon = "103BadgeStar";
  static const String chatHistoryIcon = "104ChatHistoryIcon";
  static const String closeIconSearch = "105CloseIconSearch";
  static const String closeMapIcon = "106CloseMapIcon";

  static const String splashCompareIcon = "107SplashCompare";
  static const String splashUndrawAircraft = "108SplashUndrawAircraft";
  static const String splashMap = "109SplashMap";
  static const String splashFilter = "110SplashFilter";
  static const String splashInstantAI = "111SplashInstantAI";
  static const String splashQuiz = "112SplashQuiz";
  static const String flyingAreaIcon = "113FlyingAreaIcon";
  static const String infoYellowIcon = "114InfoYellowIcon";
  static const String loginSuccessIcon = "115LoginSuccessIcon";
  static const String manufacturerPlaceholder = "116ManufacturerPlaceholder";
  static const String mapPopupAircraft = "117MapPopupAircraft";
  static const String mapPopupLiveArea = "118MapPopupLiveArea";
  static const String otpIconForAlert = "119otpIconForAlert";
  static const String gameResultIcon = "120GameResultIcon";
  static const String chatSendIcon = "121ChatSendIcon";
  static const String signInIconForAlert = "122SignInIconForAlert";
  static const String splashMainLogo = "123SplashMainLogo";
  static const String successIcon = "124SuccessIcon";

  static const deleteForCalculation = '125CalculationDelete';
  static const expandForCalculation = '126CalculationExpand';
  static const historyForCalculation = '127CalculationHistory';
  static const switchLGridForCalculation = '128CalculationSwitch';
  static const viewCreditsToken = '129ViewCreditsToken';
  static const tickIcon = '130TickIcon';
  static const myAirplaneIcon = '131MyAirplane';
  static const dragRotateIcon = '132dragIcon';
  static const successJettingAround = '133SuccessJettingAround';
  static const rightArrow = '134RightArrow';
  static const String airplaneParts = 'aircraft-parts';


  static const nose = '200nosse';
  static const cockpit = '201cockpit';
  static const fislage = '202fuslage';
  static const leftwing = '203leftwing';
  static const rightwing = '204rightwing';
  static const engine = '205engine';

  //JPG
  static const String startExploreIcon = "1StartExploreIcon";

  //png
  static const String infoWrongFirst = "1InfoWrongGameIcon";
  static const String infoWrongSecond = "2InfoWrongGameIcon";
  static const String infoWrongThird = "3InfoWrongGameIcon";
  static const String towerImageForGame = "4TowerImage";
  static const String towerImageForWebGame = "4_1TowerImage";
  static const String flightDownBB = "5FlightDownBB";
  static const String decodeBB = "6DecodeBB";
  static const String chainOfBB = "7ChainOfBB";
  static const String bluePrintBB = "8BluePrintBB";
  static const String comparisonPlaceholder = "9ComparisonPlaceholder";
  static const String badgeMainIcon = "10BadgeMainIcon";
  static const String carFollowImage = "11CarFollowIcon";
  static const String cloudsLeftForGame = "12LeftSideClouds";
  static const String cloudsRightForGame = "13RightSideClouds";

  static const String viewCreditTokensImage = "14ViewCreditTokens";
  static const String addOnPacksImage = "15AddOnPacks";
  static const String backgroundImagForPopup = "16BackgroundImagForPopup";
  //Gif
  static const String badgeGif = "1BadgeGif";
  static const String gameResultGif = "2GameResultGif";
  static const String timeoutAlertGif = "3TimeoutAlertGif";

  static const String phaseAnimationVideo = "phase_Animation";
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

  static String setGifAndVideoImage(String image, bool isForVideo) {
    if (isForVideo) {
      return 'assets/gif/$image.mp4';
    }
    return 'assets/gif/$image.gif';
  }
}
