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