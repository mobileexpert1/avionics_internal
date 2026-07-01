class AppleSignInErrorHandler {
  static String getMessage(dynamic error) {
    final errorString = error.toString();

    if (errorString.contains('AuthorizationError error 1000')) {
      return 'Apple Sign In is currently unavailable. Please try again later.';
    }

    if (errorString.contains('AuthorizationErrorCode.canceled')) {
      return 'Sign in was cancelled.';
    }

    if (errorString.contains('AuthorizationErrorCode.invalidResponse')) {
      return 'Invalid response received from Apple.';
    }

    if (errorString.contains('AuthorizationErrorCode.notHandled')) {
      return 'Apple Sign In could not be completed.';
    }

    if (errorString.contains('AuthorizationErrorCode.failed')) {
      return 'Apple Sign In failed. Please try again.';
    }

    return 'Something went wrong while signing in with Apple.';
  }
}

class GoogleSignInErrorHandler {
  static String getMessage(dynamic error) {
    final errorString = error.toString();

    if (errorString.contains('GoogleSignInExceptionCode.canceled')) {
      return 'Sign in was cancelled.';
    }

    if (errorString.contains('GoogleSignInExceptionCode.interrupted')) {
      return 'Sign in was interrupted. Please try again.';
    }

    if (errorString.contains('GoogleSignInExceptionCode.clientConfigurationError')) {
      return 'Google Sign In is not configured correctly. Please contact support.';
    }

    if (errorString.contains('GoogleSignInExceptionCode.providerConfigurationError')) {
      return 'Google Sign In is currently unavailable. Please try again later.';
    }

    if (errorString.contains('GoogleSignInExceptionCode.uiUnavailable')) {
      return 'Google Sign In could not be displayed. Please try again.';
    }

    if (errorString.contains('GoogleSignInExceptionCode.userMismatch')) {
      return 'The signed-in account does not match. Please try again.';
    }

    if (errorString.contains('GoogleSignInExceptionCode.unknownError')) {
      return 'Google Sign In failed. Please try again.';
    }

    return 'Something went wrong while signing in with Google.';
  }
}