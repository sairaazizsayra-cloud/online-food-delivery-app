import 'package:food_application/core/app_assets.dart';
import 'package:food_application/models/models.dart';

class Catalog {
  static const List<String> categories = [
    'All',
    'Burger',
    'Pizza',
    'Pasta',
    'Chicken',
    'Hot Dog',
    'Drinks',
  ];

  static const List<Restaurant> restaurants = [
    Restaurant(
      id: 'r1',
      name: 'Rose Garden Restaurant',
      imageUrl: AppAssets.restaurantRose,
      categories: ['Burger', 'Chicken', 'Rice', 'Wings'],
      rating: 4.7,
      deliveryTime: 20,
      freeDelivery: true,
      description:
          'Fresh grills, signature burgers and family platters from the Rose Garden kitchen.',
    ),
    Restaurant(
      id: 'r2',
      name: 'Spicy Restaurant',
      imageUrl: AppAssets.restaurantSpicy,
      categories: ['Burger', 'Sandwich', 'Pizza'],
      rating: 4.7,
      deliveryTime: 22,
      freeDelivery: true,
      description:
          'Bold spices, loaded sandwiches and oven-baked pizza made to order.',
    ),
    Restaurant(
      id: 'r3',
      name: 'Pansi Restaurant',
      imageUrl: AppAssets.restaurantPansi,
      categories: ['Pizza', 'Pasta'],
      rating: 4.7,
      deliveryTime: 18,
      freeDelivery: true,
      description: 'Wood-fired pizza, creamy pasta and classic Italian sides.',
    ),
    Restaurant(
      id: 'r4',
      name: 'American Spicy Burger Shop',
      imageUrl: AppAssets.restaurantBurger,
      categories: ['Burger', 'Hot Dog'],
      rating: 4.3,
      deliveryTime: 16,
      freeDelivery: true,
      description: 'Stacked burgers, crispy fries and all-day American classics.',
    ),
    Restaurant(
      id: 'r5',
      name: 'Cafenio Coffee Club',
      imageUrl: AppAssets.restaurantCafe,
      categories: ['Drinks', 'Pizza'],
      rating: 4.0,
      deliveryTime: 15,
      freeDelivery: false,
      description: 'Handcrafted coffee, desserts and light bites for any time of day.',
    ),
    Restaurant(
      id: 'r6',
      name: 'Tasty Treat Gallery',
      imageUrl: AppAssets.restaurantGallery,
      categories: ['Chicken', 'Pasta', 'Burger'],
      rating: 4.5,
      deliveryTime: 20,
      freeDelivery: true,
      description: 'Chef specials with generous portions and free delivery nearby.',
    ),
  ];

  static const List<FoodItem> foods = [
    FoodItem(
      id: 'f1',
      name: 'Burger Bistro',
      restaurantId: 'r1',
      restaurantName: 'Rose Garden',
      category: 'Burger',
      price: 40,
      rating: 4.7,
      imageUrl: AppAssets.foodBurgerClassic,
      description:
          'Juicy beef patty, cheddar, lettuce and house sauce on a toasted brioche bun.',
      deliveryTime: 20,
    ),
    FoodItem(
      id: 'f2',
      name: "Smokin' Burger",
      restaurantId: 'r4',
      restaurantName: 'Cafenio Restaurant',
      category: 'Burger',
      price: 60,
      rating: 4.6,
      imageUrl: AppAssets.foodBurgerBbq,
      description: 'Smoky BBQ burger with crispy onion, cheddar and pickles.',
      deliveryTime: 18,
    ),
    FoodItem(
      id: 'f3',
      name: 'Buffalo Burgers',
      restaurantId: 'r6',
      restaurantName: 'Kaji Firm Kitchen',
      category: 'Burger',
      price: 75,
      rating: 4.8,
      imageUrl: AppAssets.foodBurgerBuffalo,
      description: 'Spicy buffalo sauce, ranch drizzle and melted mozzarella.',
      deliveryTime: 22,
    ),
    FoodItem(
      id: 'f4',
      name: 'Bullseye Burgers',
      restaurantId: 'r2',
      restaurantName: 'Kabob Restaurant',
      category: 'Burger',
      price: 94,
      rating: 4.5,
      imageUrl: AppAssets.foodBurgerDouble,
      description: 'Double stacked smash burger with caramelized onions.',
      deliveryTime: 24,
    ),
    FoodItem(
      id: 'f5',
      name: 'Burger Ferguson',
      restaurantId: 'r2',
      restaurantName: 'Spicy Restaurant',
      category: 'Burger',
      price: 40,
      rating: 4.4,
      imageUrl: AppAssets.foodBurgerClassic,
      description: 'Classic diner burger with tomato, onion and mustard.',
      deliveryTime: 16,
    ),
    FoodItem(
      id: 'f6',
      name: "Rockin' Burgers",
      restaurantId: 'r5',
      restaurantName: 'Cafecafachino',
      category: 'Burger',
      price: 40,
      rating: 4.2,
      imageUrl: AppAssets.foodBurgerChicken,
      description: 'Crispy chicken burger with slaw and spicy mayo.',
      deliveryTime: 19,
    ),
    FoodItem(
      id: 'f7',
      name: 'Pizza Calzone European',
      restaurantId: 'r3',
      restaurantName: 'Pansi Restaurant',
      category: 'Pizza',
      price: 32,
      rating: 4.7,
      imageUrl: AppAssets.foodPizza,
      description:
          'Prosciutto e funghi pizza topped with tomato sauce, mushrooms and ham.',
      deliveryTime: 20,
    ),
    FoodItem(
      id: 'f8',
      name: 'European Pizza',
      restaurantId: 'r5',
      restaurantName: 'Uttora Coffee House',
      category: 'Pizza',
      price: 28,
      rating: 4.3,
      imageUrl: AppAssets.foodPizzaThin,
      description: 'Thin crust pizza with olives, mozzarella and basil.',
      deliveryTime: 17,
    ),
    FoodItem(
      id: 'f9',
      name: 'Buffalo Pizza',
      restaurantId: 'r5',
      restaurantName: 'Cafenio Coffee Club',
      category: 'Pizza',
      price: 30,
      rating: 4.1,
      imageUrl: AppAssets.foodPizzaBuffalo,
      description: 'Spicy buffalo chicken pizza with ranch swirl.',
      deliveryTime: 21,
    ),
    FoodItem(
      id: 'f10',
      name: 'Creamy Alfredo Pasta',
      restaurantId: 'r3',
      restaurantName: 'Pansi Restaurant',
      category: 'Pasta',
      price: 60,
      rating: 4.6,
      imageUrl: AppAssets.foodPasta,
      description: 'Fettuccine in a rich parmesan alfredo sauce.',
      deliveryTime: 25,
    ),
    FoodItem(
      id: 'f11',
      name: 'Grilled Chicken Platter',
      restaurantId: 'r1',
      restaurantName: 'Rose Garden',
      category: 'Chicken',
      price: 80,
      rating: 4.8,
      imageUrl: AppAssets.foodChicken,
      description: 'Herb grilled chicken with rice, salad and garlic dip.',
      deliveryTime: 23,
    ),
    FoodItem(
      id: 'f12',
      name: 'Crispy Hot Dog',
      restaurantId: 'r4',
      restaurantName: 'American Spicy Burger Shop',
      category: 'Hot Dog',
      price: 18,
      rating: 4.2,
      imageUrl: AppAssets.foodHotdog,
      description: 'Toasted bun, mustard, ketchup and crispy onions.',
      deliveryTime: 12,
    ),
    FoodItem(
      id: 'f13',
      name: 'Iced Coffee',
      restaurantId: 'r5',
      restaurantName: 'Cafenio Coffee Club',
      category: 'Drinks',
      price: 8,
      rating: 4.0,
      imageUrl: AppAssets.foodCoffee,
      description: 'Cold brew coffee served over ice with optional milk.',
      deliveryTime: 10,
      freeDelivery: false,
    ),
    FoodItem(
      id: 'f14',
      name: 'Chicken Wings',
      restaurantId: 'r1',
      restaurantName: 'Rose Garden',
      category: 'Chicken',
      price: 22,
      rating: 4.6,
      imageUrl: AppAssets.foodWings,
      description: 'Crispy wings tossed in signature chili glaze.',
      deliveryTime: 18,
    ),
    FoodItem(
      id: 'f15',
      name: 'Zinger Burger',
      restaurantId: 'r4',
      restaurantName: 'American Spicy Burger Shop',
      category: 'Burger',
      price: 50,
      rating: 4.5,
      imageUrl: AppAssets.foodBurgerChicken,
      description: 'Crispy zinger fillet, lettuce and spicy mayo.',
      deliveryTime: 15,
    ),
    FoodItem(
      id: 'f16',
      name: 'Club Sandwich',
      restaurantId: 'r2',
      restaurantName: 'Spicy Restaurant',
      category: 'Hot Dog',
      price: 24,
      rating: 4.3,
      imageUrl: AppAssets.foodSandwich,
      description: 'Triple-layer club with chicken, egg and cheese.',
      deliveryTime: 14,
    ),
  ];

  static Restaurant? restaurantById(String id) {
    for (final restaurant in restaurants) {
      if (restaurant.id == id) return restaurant;
    }
    return null;
  }

  static FoodItem? foodById(String id) {
    for (final food in foods) {
      if (food.id == id) return food;
    }
    return null;
  }

  static List<FoodItem> foodsForRestaurant(String restaurantId) {
    return foods.where((food) => food.restaurantId == restaurantId).toList();
  }

  static List<FoodItem> foodsForCategory(String category) {
    if (category == 'All') return List<FoodItem>.from(foods);
    return foods.where((food) => food.category == category).toList();
  }

  static List<String> ingredientsFor(FoodItem food) {
    switch (food.category) {
      case 'Burger':
        return ['Beef', 'Cheddar', 'Lettuce', 'Brioche'];
      case 'Pizza':
        return ['Tomato', 'Mozzarella', 'Basil', 'Olive oil'];
      case 'Pasta':
        return ['Fettuccine', 'Parmesan', 'Cream', 'Garlic'];
      case 'Chicken':
        return ['Chicken', 'Herbs', 'Rice', 'Garlic dip'];
      case 'Hot Dog':
        return ['Sausage', 'Bun', 'Mustard', 'Onions'];
      case 'Drinks':
        return ['Coffee', 'Ice', 'Milk', 'Sugar'];
      default:
        return ['Fresh ingredients', 'House sauce'];
    }
  }

  static List<FoodReview> reviewsFor(FoodItem food) {
    return [
      FoodReview(
        author: 'Ayesha K.',
        rating: food.rating,
        comment:
            'Really good portion size and it arrived hot. I would order ${food.name} again, especially with the ${food.restaurantName} combo.',
      ),
      const FoodReview(
        author: 'Bilal R.',
        rating: 4.4,
        comment:
            'Packaging was neat and delivery was on time. Flavor is rich without being too oily.',
      ),
    ];
  }
}
