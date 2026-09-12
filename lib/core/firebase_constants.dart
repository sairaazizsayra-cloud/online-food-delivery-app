class FirebaseCollections {
  static const String users = 'users';
  static const String restaurants = 'restaurants';
  static const String foods = 'foods';
  static const String addresses = 'addresses';
  static const String cards = 'cards';
  static const String cart = 'cart';
  static const String orders = 'orders';
  static const String notifications = 'notifications';
}

class AppFieldLimits {
  static const int nameMax = 80;
  static const int emailMax = 120;
  static const int phoneMax = 20;
  static const int bioMax = 280;
  static const int addressMax = 200;
  static const int streetMax = 120;
  static const int postCodeMax = 20;
  static const int apartmentMax = 40;
  static const int labelMax = 40;
  static const int holderNameMax = 80;
  static const int expiryMax = 10;
  static const int last4Max = 4;
  static const int notificationTitleMax = 80;
  static const int notificationBodyMax = 300;
  static const int foodNameMax = 80;
  static const int restaurantNameMax = 80;
  static const int descriptionMax = 500;
  static const int categoryMax = 40;
  static const int imageUrlMax = 400;
  static const int paymentLabelMax = 80;
  static const int orderAddressMax = 240;
  static const int cartMaxItems = 50;
  static const int favoritesMax = 100;
  static const int orderItemsMax = 50;
  static const int quantityMax = 20;
}

class GoogleAuthConfig {
  static const String webClientId =
      '407362360050-gc3kulf9e2qj081njld890o86qg5a7gn.apps.googleusercontent.com';
  static const String iosClientId =
      '407362360050-b6vntvj1u4f3l96tarprdv1urtl6v2np.apps.googleusercontent.com';
}

class PhoneAuthConfig {
  static const String defaultCountryCode = '+92';
  static const String recaptchaContainerId = 'recaptcha-container';
}

class AuthCopy {
  static const String defaultBio = 'I love fast food';
  static const String googleCancelled = 'Google sign-in was cancelled';
  static const String phoneRequired =
      'Enter a valid mobile number, e.g. 0300 1234567';
  static const String unauthorizedDomain =
      'This site is not authorized for Google sign-in yet';
  static const String phoneCaptchaFailed =
      'Complete the security check, then send the code again';
  static const String phoneQuota =
      'SMS limit reached. Try again later or use email login';
  static const String resetEmailSent =
      'A password reset link was sent. Open it to set a new password, then log in.';
  static const String resetEmailHint =
      'Please enter your email to reset password';
}
