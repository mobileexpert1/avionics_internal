class ConstantStrings {
  // ─────────────────────────────
  // App Name
  // ─────────────────────────────
  static const String poweredBy = "Powered by AskWILCO";

  // ─────────────────────────────
  // Onboarding Titles
  // ─────────────────────────────
  static const String title1 = "Aircraft \nEncyclopedia";
  static const String title2 = "Live Aircraft \nTracking";
  static const String title3 = "Compare \nModels";
  static const String title4 = "Filter, Search \nand Save";
  static const String title5 = "AskWILCO";
  static const String title6 = "Learning Games";

  // ─────────────────────────────
  // Onboarding Descriptions
  // ─────────────────────────────
  static const String description1 = "Database for professionals with\nup-to-date technical info";
  static const String description2 = "See how different aircraft \nperform on a live flight map";
  static const String description3 = "Learn quickly from data \nwith advanced compare features";
  static const String description4 = "Map filter and smart search options \ngive you quick access to data";
  static const String description5 = "Get instant AI-powered answers to \naviation questions and flight procedures";
  static const String description6 = "Master the skies through 4 thrilling \nchallenges. Quiz battles, Word puzzles, \nSurvival missions, and Fuel strategy games";

  // ─────────────────────────────
  // Onboarding Buttons
  // ─────────────────────────────
  static const String skip = "Skip";
  static const String next = "Next";

  // ─────────────────────────────
  // Authentication
  // ─────────────────────────────
  static const String title = 'Login';
  static const String titleLogin = "Login";
  static const String loginButton = 'Log In';
  static const String forgotPassword = 'Forgot your password?';
  static const String orContinue = 'Or Continue with';
  static const String loginWithGoogle = 'Log in with Google';
  static const String loginWithApple = 'Log in with Apple';
  static const String loginWithFacebook = 'Log in with Facebook';
  static const String loginPrompt = 'Already a user? Log in';
  static const String signUpPrompt = "Don't have an account? Sign up";
  static const String CreateAccount = 'Create your account';

  // ─────────────────────────────
  // Passwords & Reset
  // ─────────────────────────────
  static const String appBarTitleForgotPwd = 'Forgot Password';
  static const String appBarTitleResetPwd = 'Reset Password';
  static const String appBarTitleOTPScreen = 'OTP Verification';
  static const String sendEmailButton = 'Send Email Code';
  static const String createPasswordLabel = 'Create Password';
  static const String createNewPasswordLabel = 'Create New Password';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String changePassword = 'Change Password';
  static const String changePasswordLabel = 'Change Password';
  static const String oldPasswordLabel = 'Old Password';
  static const String newPasswordLabel = 'New Password';
  static const String resetPassword = ' Reset Password';
  static const String Otptitle = 'Enter the 4-digit OTP sent to your registered email.';
  static const String continueText = 'Continue';
  static const String goBack = 'Go Back';

  // ─────────────────────────────
  // Labels / Form Fields
  // ─────────────────────────────
  static const String emailLabel = 'Email address';
  static const String passwordLabel = 'Password';
  static const String firstNameLabel = 'First name';
  static const String lastNameLabel = 'Last name';

  // ─────────────────────────────
  // General Navigation / Actions
  // ─────────────────────────────
  static const String unitsMeasurmentsTitle = 'Units & Measurements';
  static const String saveTitle = 'Save';
  static const String exploring = 'Start Exploring';
  static const String contactSupport = 'Contact Support';
  static const String reviewTitle = 'Review';


  // ─────────────────────────────
  // Section Titles
  // ─────────────────────────────

  static const String signupTitle = 'Sign up';
  static const String submitTitle = 'Submit';
  static const String startSubscription = 'Start Subscription';
  static const String manageAccount = 'Manage Your Account';
  static const String titleHome = "Home";
  static const String profileTitle = 'Profile';
  static const String glossaryTitle = 'Glossary';
  static const String avtarTitle = 'Choose Your Avatar';

// ─────────────────────────────
// Create New Password
// ─────────────────────────────
  static const String OtpVerified = 'Your OTP verified successfully. Please reset your password within 5 minutes.';


  // ─────────────────────────────
  // Chat History
  // ─────────────────────────────

  static const String chatHistoryTitle = 'Chat History';

  // ─────────────────────────────
  // Quiz
  // ─────────────────────────────

  static const String aviationQuizTitle = 'Aviation Quiz';
  static const String backToGame = 'Back to games';
  static const String startGame = 'Start Game';
  static const String compare = 'Compare';
  static const String calculationsTitle = 'Calculations';
}


class SubscriptionTexts {
  // ─────────────────────────────
  // Plan Descriptions
  // ─────────────────────────────
  static const String trialMessage = 'Free for 7 days then 80 EURO per year.\nCancel anytime.';
  static const String goPremiumTitle = 'Go Premium';
  static const String changeSubPlanTitle = 'Change Subscription Plan';
  static const String restoreSubTitle = 'Restore Subscription';
  static const String currentSubTitle = 'Current Subscription';
  static const String currentPlanTitle = 'Current Plan';

  // ─────────────────────────────
  // Monthly Plan
  // ─────────────────────────────
  static const String oneMonthTitle = '1 Month';
  static const String oneMonthPrice = '10 EURO';
  static const String sevenDaysTrialSubtitle = '+ 7 days free trial';

  // ─────────────────────────────
  // Yearly Plan
  // ─────────────────────────────
  static const String oneYearTitle = '1 Year';
  static const String oneYearPrice = '80 EURO';

  // ─────────────────────────────
  // Features
  // ─────────────────────────────
  static const String featureTrackAircrafts = 'Track the aircrafts';
  static const String featureComparePlanes = 'Compare planes';
  static const String featureSaveFavorites = 'Save your favorite aircrafts';
}

class ApiBaseUrlConstant {
   static const String baseUrl = 'https://avionica.csdevhub.com/';
  //static const String baseUrl = 'http://192.168.10.186:8010/';
}

class ApiFunctionUrlConstant {
  static const String userService = 'user-service/';
}

class ApiServiceUrlConstant {

  static const String authRefreshToken = 'auth/refresh';
  static const String checkEmail = 'auth/check-email';
  static const String authSignup = 'auth/sign-up';
  static const String verifyOtp = 'auth/verify-otp';
  static const String signIn = 'auth/sign-in';
  static const String signInSocial = "auth/social-sign-in";
  static const String forgotEmaiiSend = 'auth/forget-password';
  static const String forgotPasswordVerify = 'auth/verify-forget-password';
  static const String resetPassword = 'auth/reset-password';
  static const String getSubscritionList = 'subscription/';
  static const String postSubscrition = 'subscription/user';
  static const String verfiyPostSubscrition = 'subscription/verify';

  //Profile
  static const String getUnitselection = 'user/measurement';
  static const String updateUnitselection = 'user/measurement';
  static const String changeCurrentPassword = 'auth/change-password';
  static const String getAndSetUserDetail = 'user/';
  static const String review = 'user/review';
  static const String setAvtar = 'user/avatar';
  static const String setAvtarWhileSignup = 'auth/avtar';
  static const String delete = 'user/';
  static const String getGlossary = 'user/glossary';
  static const String chatHistorySession = 'ai-engine/wilco/session';
}


class ApiFunctionUrlAirplaneConstant {
  static const String airplaneService = 'airplane-service/';
  static const String airCraftDetail  = 'aircraft/details/';
}


class ApiServiceUrlAirplaneConstant {
  //Home
  static const String getExploreData = 'explore/';
  static const String getListManufacturer = 'manufacturer/';
  static const String getListAirbus = 'aircraft/';
  static const String favUnFavPlane = 'aircraft/favorite';
  static const compareAircraft = "aircraft/comparison";
}

class ApiFunctionUrlGamesConstant {
  static const calculationService = "ai-engine/games/calculation/";
}


class ApiServiceUrlGamesConstant {
  // static const getLockScreen = "calculation/";
  // static const getQuestions = "calculation/";
  // static const submitCalculationResults = "calculation/take-measure/answer-submit";

  static String getQuestions(int gameNumber) => "$gameNumber";
  static String submitCalculationResults(int gameNumber) => "$gameNumber/answer-submit";
}