class ConstantStrings {
  // ─────────────────────────────
  // App Name
  // ─────────────────────────────
  static const String avionica = "avionic";

  // ─────────────────────────────
  // Onboarding Titles
  // ─────────────────────────────
  static const String title1 = "Aircraft \nEncyclopedia";
  static const String title2 = "Live Aircraft \nTracking";
  static const String title3 = "Compare \nModels";
  static const String title4 = "Filter, Search \nand Save";

  // ─────────────────────────────
  // Onboarding Descriptions
  // ─────────────────────────────
  static const String description1 = "Database for professionals with\nup-to-date technical info";
  static const String description2 = "See how different aircraft \nperform on a live flight map";
  static const String description3 = "Learn quickly from data \nwith advanced compare features";
  static const String description4 = "Map filter and smart search options \ngive you quick access to data";

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
  static const String appBarTitleOTPScreen = 'Verify OTP Screen';
  static const String sendEmailButton = 'Send Email Code';
  static const String createPasswordLabel = 'Create Password';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String changePassword = 'Change Password';
  static const String changePasswordLabel = 'Change Password';
  static const String oldPasswordLabel = 'Old Password';
  static const String newPasswordLabel = 'New Password';
  static const String resetPassword = ' Reset Password';
  static const String Otptitle = 'Enter four digits otp';
  static const String continueText = 'Continue';
  static const String goBack = 'Go Back';

  // ─────────────────────────────
  // Labels / Form Fields
  // ─────────────────────────────
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String firstNameLabel = 'First Name';
  static const String lastNameLabel = 'Last Name';

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
  static const String startSubscription = 'Start Subscription';
  static const String manageAccount = 'Manage Your Account';
  static const String titleHome = "Home";
  static const String profileTitle = 'Profile';
  static const String glossaryTitle = 'Glossary';
  static const String avtarTitle = 'Avatar';
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
  static const String featureSaveFavorites = 'Save your Favorites Aircrafts';
}

class ApiBaseUrlConstant {
  static const String baseUrl = 'https://avionica.csdevhub.com/';
}

class ApiFunctionUrlConstant {
  static const String userService = 'user-service/';
}

class ApiServiceUrlConstant {
  static const String authSignup = 'auth/sign-up';
  static const String verifyOtp = 'auth/verify-otp';
}