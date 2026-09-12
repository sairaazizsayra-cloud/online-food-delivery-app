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

class AuthCopy {
  static const String defaultBio = 'I love fast food';
  static const String googleCancelled = 'Google sign-in was cancelled';
  static const String phoneRequired =
      'Enter a valid phone number with country code';
}
