class AppAssets {
  static const String logo = 'images/Logo.png';
  static const String homeBanner = 'images/home_banner.png';
  static const String locationMap = 'images/location_map.jpg';

  static const String onboardFavorites = 'images/onboard_favorites.jpg';
  static const String onboardChefs = 'images/onboard_chefs.jpg';
  static const String onboardDelivery = 'images/onboard_delivery.jpg';

  static const String restaurantRose = 'images/restaurant_rose.jpg';
  static const String restaurantSpicy = 'images/restaurant_spicy.jpg';
  static const String restaurantPansi = 'images/restaurant_pansi.jpg';
  static const String restaurantBurger = 'images/restaurant_burger.jpg';
  static const String restaurantCafe = 'images/restaurant_cafe.jpg';
  static const String restaurantGallery = 'images/restaurant_gallery.jpg';

  static const String foodBurgerClassic = 'images/food_burger_classic.jpg';
  static const String foodBurgerBbq = 'images/food_burger_bbq.jpg';
  static const String foodBurgerBuffalo = 'images/food_burger_buffalo.jpg';
  static const String foodBurgerDouble = 'images/food_burger_double.jpg';
  static const String foodBurgerChicken = 'images/food_burger_chicken.jpg';
  static const String foodPizza = 'images/food_pizza.jpg';
  static const String foodPizzaThin = 'images/food_pizza_thin.jpg';
  static const String foodPizzaBuffalo = 'images/food_pizza_buffalo.jpg';
  static const String foodPasta = 'images/food_pasta.jpg';
  static const String foodChicken = 'images/food_chicken.jpg';
  static const String foodHotdog = 'images/food_hotdog.jpg';
  static const String foodCoffee = 'images/food_coffee.jpg';
  static const String foodWings = 'images/food_wings.jpg';
  static const String foodSandwich = 'images/food_sandwich.jpg';

  static const String categoryAll = 'images/onboard_favorites.jpg';
  static const String categoryBurger = 'images/cat_burger.jpg';
  static const String categoryPizza = 'images/cat_pizza.jpg';
  static const String categoryPasta = 'images/cat_pasta.jpg';
  static const String categoryChicken = 'images/cat_chicken.jpg';
  static const String categoryHotdog = 'images/cat_hotdog.jpg';
  static const String categoryDrinks = 'images/cat_drinks.jpg';

  static String categoryImage(String category) {
    switch (category) {
      case 'Burger':
        return categoryBurger;
      case 'Pizza':
        return categoryPizza;
      case 'Pasta':
        return categoryPasta;
      case 'Chicken':
        return categoryChicken;
      case 'Hot Dog':
        return categoryHotdog;
      case 'Drinks':
        return categoryDrinks;
      default:
        return categoryAll;
    }
  }
}
