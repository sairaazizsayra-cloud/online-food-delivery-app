import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_application/data/catalog.dart';
import 'package:food_application/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static const String _storageKey = 'foodie_app_state_v1';
  static const String demoOtp = '1234';
  static const double deliveryFee = 0;
  static const double promoPercent = 0.2;

  bool hydrated = false;
  bool seenOnboarding = false;
  UserAccount? currentUser;
  final List<UserAccount> users = [];
  final List<CartLine> cart = [];
  final List<OrderModel> orders = [];
  final List<AddressModel> addresses = [];
  final List<PaymentCardModel> cards = [];
  final Set<String> favoriteFoodIds = {};
  String? selectedAddressId;
  String? selectedCardId;
  String selectedCategory = 'All';
  String searchQuery = '';
  String? promoCode;
  String paymentMethod = 'Cash';
  FilterOptions filter = FilterOptions();
  String? pendingResetEmail;
  String? errorMessage;

  Future<void> hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        seenOnboarding = json['seenOnboarding'] as bool? ?? false;
        users
          ..clear()
          ..addAll(
            ((json['users'] as List?) ?? []).map(
              (item) => UserAccount.fromJson(item as Map<String, dynamic>),
            ),
          );
        final email = json['currentEmail'] as String?;
        if (email != null) {
          currentUser = users.cast<UserAccount?>().firstWhere(
                (user) => user?.email == email,
                orElse: () => null,
              );
        }
        addresses
          ..clear()
          ..addAll(
            ((json['addresses'] as List?) ?? []).map(
              (item) => AddressModel.fromJson(item as Map<String, dynamic>),
            ),
          );
        cards
          ..clear()
          ..addAll(
            ((json['cards'] as List?) ?? []).map(
              (item) => PaymentCardModel.fromJson(item as Map<String, dynamic>),
            ),
          );
        selectedAddressId = json['selectedAddressId'] as String?;
        selectedCardId = json['selectedCardId'] as String?;
        favoriteFoodIds
          ..clear()
          ..addAll(((json['favoriteFoodIds'] as List?) ?? []).cast<String>());
        cart
          ..clear()
          ..addAll(
            ((json['cart'] as List?) ?? []).map((item) {
              final map = item as Map<String, dynamic>;
              final food = Catalog.foodById(map['foodId'] as String);
              if (food == null) return null;
              return CartLine(
                food: food,
                size: map['size'] as String? ?? '14',
                quantity: map['quantity'] as int? ?? 1,
              );
            }).whereType<CartLine>(),
          );
        orders
          ..clear()
          ..addAll(
            ((json['orders'] as List?) ?? []).map((item) {
              final map = item as Map<String, dynamic>;
              final lines = ((map['items'] as List?) ?? []).map((line) {
                final lineMap = line as Map<String, dynamic>;
                final food = Catalog.foodById(lineMap['foodId'] as String);
                if (food == null) return null;
                return CartLine(
                  food: food,
                  size: lineMap['size'] as String? ?? '14',
                  quantity: lineMap['quantity'] as int? ?? 1,
                );
              }).whereType<CartLine>().toList();
              return OrderModel(
                id: map['id'] as String,
                items: lines,
                total: (map['total'] as num?)?.toDouble() ?? 0,
                address: map['address'] as String? ?? '',
                paymentLabel: map['paymentLabel'] as String? ?? 'Cash',
                createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
                    DateTime.now(),
                status: OrderStatus.values.firstWhere(
                  (value) => value.name == map['status'],
                  orElse: () => OrderStatus.ongoing,
                ),
                restaurantName: map['restaurantName'] as String? ?? 'Restaurant',
              );
            }),
          );
      } catch (_) {
        _seedDefaults();
      }
    }
    if (users.isEmpty) {
      _seedDefaults();
    }
    hydrated = true;
    notifyListeners();
  }

  void _seedDefaults() {
    users.add(
      UserAccount(
        name: 'Halal Lab',
        email: 'demo@foodie.com',
        password: '123456',
        phone: '408-841-0926',
        bio: 'I love fast food',
      ),
    );
    addresses.add(
      AddressModel(
        id: 'a1',
        label: 'Office',
        fullAddress: 'Halal Lab Office, 2118 Thornridge Cir. Syracuse',
        street: 'Thornridge Circle',
        postCode: '34567',
        apartment: '12B',
      ),
    );
    selectedAddressId = 'a1';
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode({
        'seenOnboarding': seenOnboarding,
        'currentEmail': currentUser?.email,
        'users': users.map((user) => user.toJson()).toList(),
        'addresses': addresses.map((item) => item.toJson()).toList(),
        'cards': cards.map((item) => item.toJson()).toList(),
        'selectedAddressId': selectedAddressId,
        'selectedCardId': selectedCardId,
        'favoriteFoodIds': favoriteFoodIds.toList(),
        'cart': cart.map((item) => item.toJson()).toList(),
        'orders': orders.map((item) => item.toJson()).toList(),
      }),
    );
  }

  bool get isLoggedIn => currentUser != null;

  AddressModel? get selectedAddress {
    if (addresses.isEmpty) return null;
    return addresses.firstWhere(
      (item) => item.id == selectedAddressId,
      orElse: () => addresses.first,
    );
  }

  PaymentCardModel? get selectedCard {
    if (cards.isEmpty) return null;
    return cards.firstWhere(
      (item) => item.id == selectedCardId,
      orElse: () => cards.first,
    );
  }

  int get cartCount => cart.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => cart.fold(0, (sum, item) => sum + item.lineTotal);

  double get discount =>
      promoCode == 'FOOD20' ? subtotal * promoPercent : 0;

  double get total => (subtotal - discount + deliveryFee).clamp(0, 99999);

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  List<FoodItem> get visibleFoods {
    return Catalog.foods.where((food) {
      final matchesCategory =
          selectedCategory == 'All' || food.category == selectedCategory;
      final query = searchQuery.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          food.name.toLowerCase().contains(query) ||
          food.restaurantName.toLowerCase().contains(query) ||
          food.category.toLowerCase().contains(query);
      final matchesFilter = food.price >= filter.minPrice &&
          food.price <= filter.maxPrice &&
          food.rating >= filter.minRating &&
          food.deliveryTime <= filter.maxDeliveryTime &&
          (!filter.offersFreeDelivery || food.freeDelivery);
      return matchesCategory && matchesQuery && matchesFilter;
    }).toList();
  }

  List<Restaurant> get visibleRestaurants {
    return Catalog.restaurants.where((restaurant) {
      final query = searchQuery.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          restaurant.name.toLowerCase().contains(query) ||
          restaurant.categories.any(
            (category) => category.toLowerCase().contains(query),
          );
      final matchesCategory = selectedCategory == 'All' ||
          restaurant.categories.contains(selectedCategory);
      final matchesFilter = restaurant.rating >= filter.minRating &&
          restaurant.deliveryTime <= filter.maxDeliveryTime &&
          (!filter.offersFreeDelivery || restaurant.freeDelivery);
      return matchesQuery && matchesCategory && matchesFilter;
    }).toList();
  }

  List<OrderModel> get ongoingOrders =>
      orders.where((order) => order.status == OrderStatus.ongoing).toList();

  List<OrderModel> get historyOrders =>
      orders.where((order) => order.status != OrderStatus.ongoing).toList();

  void completeOnboarding() {
    seenOnboarding = true;
    _persist();
    notifyListeners();
  }

  String? login(String email, String password) {
    final user = users.cast<UserAccount?>().firstWhere(
          (item) =>
              item?.email.toLowerCase() == email.trim().toLowerCase() &&
              item?.password == password,
          orElse: () => null,
        );
    if (user == null) {
      return 'Invalid email or password. Try demo@foodie.com / 123456';
    }
    currentUser = user;
    errorMessage = null;
    _persist();
    notifyListeners();
    return null;
  }

  String? register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (name.trim().isEmpty) return 'Please enter your name';
    if (!_isValidEmail(email)) return 'Please enter a valid email';
    if (password.length < 6) return 'Password must be at least 6 characters';
    if (password != confirmPassword) return 'Passwords do not match';
    final exists = users.any(
      (user) => user.email.toLowerCase() == email.trim().toLowerCase(),
    );
    if (exists) return 'An account with this email already exists';
    final user = UserAccount(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
    );
    users.add(user);
    currentUser = user;
    _persist();
    notifyListeners();
    return null;
  }

  String? requestReset(String email) {
    final exists = users.any(
      (user) => user.email.toLowerCase() == email.trim().toLowerCase(),
    );
    if (!exists) return 'No account found for this email';
    pendingResetEmail = email.trim().toLowerCase();
    notifyListeners();
    return null;
  }

  String? verifyOtp(String code) {
    if (pendingResetEmail == null) return 'Request a code first';
    if (code.trim() != demoOtp) return 'Invalid code. Use 1234 for demo';
    return null;
  }

  String? resetPassword(String password, String confirmPassword) {
    if (pendingResetEmail == null) return 'Session expired';
    if (password.length < 6) return 'Password must be at least 6 characters';
    if (password != confirmPassword) return 'Passwords do not match';
    final user = users.firstWhere(
      (item) => item.email == pendingResetEmail,
    );
    user.password = password;
    pendingResetEmail = null;
    _persist();
    notifyListeners();
    return null;
  }

  void logout() {
    currentUser = null;
    cart.clear();
    promoCode = null;
    _persist();
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String email,
    required String phone,
    required String bio,
  }) {
    if (currentUser == null) return;
    currentUser!
      ..name = name.trim()
      ..phone = phone.trim()
      ..bio = bio.trim();
    _persist();
    notifyListeners();
  }

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void applyFilter(FilterOptions options) {
    filter = options;
    notifyListeners();
  }

  void resetFilter() {
    filter = FilterOptions();
    notifyListeners();
  }

  void addToCart(FoodItem food, {String size = '14', int quantity = 1}) {
    final existing = cart.cast<CartLine?>().firstWhere(
          (item) => item?.food.id == food.id && item?.size == size,
          orElse: () => null,
        );
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      cart.add(CartLine(food: food, size: size, quantity: quantity));
    }
    _persist();
    notifyListeners();
  }

  void changeQty(CartLine line, int quantity) {
    if (quantity <= 0) {
      cart.remove(line);
    } else {
      line.quantity = quantity;
    }
    _persist();
    notifyListeners();
  }

  void removeFromCart(CartLine line) {
    cart.remove(line);
    _persist();
    notifyListeners();
  }

  bool applyPromo(String code) {
    if (code.trim().toUpperCase() == 'FOOD20') {
      promoCode = 'FOOD20';
      _persist();
      notifyListeners();
      return true;
    }
    promoCode = null;
    notifyListeners();
    return false;
  }

  void toggleFavorite(String foodId) {
    if (favoriteFoodIds.contains(foodId)) {
      favoriteFoodIds.remove(foodId);
    } else {
      favoriteFoodIds.add(foodId);
    }
    _persist();
    notifyListeners();
  }

  bool isFavorite(String foodId) => favoriteFoodIds.contains(foodId);

  List<FoodItem> get favoriteFoods => Catalog.foods
      .where((food) => favoriteFoodIds.contains(food.id))
      .toList();

  void addAddress(AddressModel address) {
    addresses.add(address);
    selectedAddressId = address.id;
    _persist();
    notifyListeners();
  }

  void selectAddress(String id) {
    selectedAddressId = id;
    _persist();
    notifyListeners();
  }

  void addCard(PaymentCardModel card) {
    cards.add(card);
    selectedCardId = card.id;
    paymentMethod = 'Card';
    _persist();
    notifyListeners();
  }

  void selectCard(String id) {
    selectedCardId = id;
    paymentMethod = 'Card';
    _persist();
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    paymentMethod = method;
    notifyListeners();
  }

  OrderModel? placeOrder() {
    if (cart.isEmpty) return null;
    final snapshot = cart
        .map(
          (item) => CartLine(
            food: item.food,
            size: item.size,
            quantity: item.quantity,
          ),
        )
        .toList();
    final order = OrderModel(
      id: 'FD${DateTime.now().millisecondsSinceEpoch % 1000000}',
      items: snapshot,
      total: total,
      address: selectedAddress?.fullAddress ?? 'Halal Lab Office',
      paymentLabel: paymentMethod == 'Card' && selectedCard != null
          ? 'Card ${selectedCard!.masked}'
          : paymentMethod,
      createdAt: DateTime.now(),
      status: OrderStatus.ongoing,
      restaurantName: snapshot.first.food.restaurantName,
    );
    orders.insert(0, order);
    cart.clear();
    promoCode = null;
    _persist();
    notifyListeners();
    return order;
  }

  void cancelOrder(String id) {
    final order = orders.cast<OrderModel?>().firstWhere(
          (item) => item?.id == id,
          orElse: () => null,
        );
    if (order == null) return;
    order.status = OrderStatus.cancelled;
    _persist();
    notifyListeners();
  }

  void markDelivered(String id) {
    final order = orders.cast<OrderModel?>().firstWhere(
          (item) => item?.id == id,
          orElse: () => null,
        );
    if (order == null) return;
    order.status = OrderStatus.delivered;
    _persist();
    notifyListeners();
  }

  void reorder(OrderModel order) {
    for (final item in order.items) {
      addToCart(item.food, size: item.size, quantity: item.quantity);
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email.trim());
  }
}
