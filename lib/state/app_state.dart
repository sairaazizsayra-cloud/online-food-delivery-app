import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:food_application/core/firebase_constants.dart';
import 'package:food_application/data/catalog.dart';
import 'package:food_application/models/models.dart';
import 'package:food_application/services/auth_service.dart';
import 'package:food_application/services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static const String _onboardingKey = 'foodie_seen_onboarding';
  static const double deliveryFee = 0;
  static const double promoPercent = 0.2;

  AppState({
    AuthService? authService,
    FirestoreService? firestoreService,
  })  : _auth = authService ?? AuthService(),
        _db = firestoreService ?? FirestoreService();

  final AuthService _auth;
  final FirestoreService _db;

  bool hydrated = false;
  bool busy = false;
  bool seenOnboarding = false;
  UserAccount? currentUser;
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
  final List<AppNotification> notifications = [];
  List<FoodItem> _foods = List<FoodItem>.from(Catalog.foods);
  List<Restaurant> _restaurants = List<Restaurant>.from(Catalog.restaurants);

  String? get currentUid => _auth.currentUser?.uid ?? currentUser?.uid;

  Future<void> hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    seenOnboarding = prefs.getBool(_onboardingKey) ?? false;

    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      await _loadSignedInUser(firebaseUser);
    }

    hydrated = true;
    notifyListeners();
  }

  Future<void> _loadSignedInUser(User firebaseUser) async {
    try {
      await _db.ensureCatalogSeeded();
      final remoteRestaurants = await _db.loadRestaurants();
      final remoteFoods = await _db.loadFoods();
      if (remoteRestaurants.isNotEmpty) {
        _restaurants = remoteRestaurants;
      }
      if (remoteFoods.isNotEmpty) {
        _foods = remoteFoods;
      }

      currentUser = await _db.ensureUserProfile(
        uid: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'Foodie User',
        email: firebaseUser.email ?? '',
        phone: firebaseUser.phoneNumber ?? '',
      );

      final settings = await _db.loadUserSettings(firebaseUser.uid);
      selectedAddressId = settings['selectedAddressId'] as String?;
      selectedCardId = settings['selectedCardId'] as String?;
      paymentMethod = settings['paymentMethod'] as String? ?? 'Cash';
      favoriteFoodIds
        ..clear()
        ..addAll(((settings['favoriteFoodIds'] as List?) ?? []).cast<String>());

      addresses
        ..clear()
        ..addAll(await _db.loadAddresses(firebaseUser.uid));
      cards
        ..clear()
        ..addAll(await _db.loadCards(firebaseUser.uid));
      cart
        ..clear()
        ..addAll(await _db.loadCart(firebaseUser.uid));
      orders
        ..clear()
        ..addAll(await _db.loadOrders(firebaseUser.uid));
      notifications
        ..clear()
        ..addAll(await _db.loadNotifications(firebaseUser.uid));

      if (notifications.isEmpty) {
        await _seedWelcomeNotifications(firebaseUser.uid);
      }
    } catch (error) {
      debugPrint('Error loading signed-in user: $error');
    }
  }

  Future<void> _seedWelcomeNotifications(String uid) async {
    final welcome = [
      AppNotification(
        id: 'welcome',
        title: 'Welcome to Foodie',
        body: 'Order from nearby restaurants and track your delivery live.',
        createdAt: DateTime.now(),
      ),
      AppNotification(
        id: 'promo',
        title: '20% off your first order',
        body: 'Use promo code FOOD20 at checkout.',
        createdAt: DateTime.now(),
      ),
    ];
    notifications.addAll(welcome);
    for (final item in welcome) {
      await _db.saveNotification(uid, item);
    }
  }

  Future<void> _persistOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, seenOnboarding);
  }

  Future<void> _persistUser() async {
    final uid = currentUid;
    final user = currentUser;
    if (uid == null || user == null) {
      return;
    }
    try {
      await _db.saveUserSettings(
        uid: uid,
        user: user,
        selectedAddressId: selectedAddressId,
        selectedCardId: selectedCardId,
        paymentMethod: paymentMethod,
        favoriteFoodIds: favoriteFoodIds.toList(),
      );
    } catch (error) {
      debugPrint('Error saving user settings: $error');
    }
  }

  Future<void> _persistCart() async {
    final uid = currentUid;
    if (uid == null) {
      return;
    }
    try {
      await _db.saveCart(uid, cart);
    } catch (error) {
      debugPrint('Error saving cart: $error');
    }
  }

  void _clearUserData() {
    currentUser = null;
    cart.clear();
    orders.clear();
    addresses.clear();
    cards.clear();
    favoriteFoodIds.clear();
    notifications.clear();
    selectedAddressId = null;
    selectedCardId = null;
    promoCode = null;
    paymentMethod = 'Cash';
  }

  bool get isLoggedIn => currentUser != null || _auth.currentUser != null;

  AddressModel? get selectedAddress {
    if (addresses.isEmpty) {
      return null;
    }
    return addresses.firstWhere(
      (item) => item.id == selectedAddressId,
      orElse: () => addresses.first,
    );
  }

  PaymentCardModel? get selectedCard {
    if (cards.isEmpty) {
      return null;
    }
    return cards.firstWhere(
      (item) => item.id == selectedCardId,
      orElse: () => cards.first,
    );
  }

  int get cartCount => cart.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => cart.fold(0, (sum, item) => sum + item.lineTotal);

  double get discount => promoCode == 'FOOD20' ? subtotal * promoPercent : 0;

  double get total => (subtotal - discount + deliveryFee).clamp(0, 99999);

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    }
    if (hour < 17) {
      return 'Good Afternoon!';
    }
    return 'Good Evening!';
  }

  List<FoodItem> get menuFoods => _foods.isEmpty ? Catalog.foods : _foods;

  List<Restaurant> get menuRestaurants =>
      _restaurants.isEmpty ? Catalog.restaurants : _restaurants;

  List<FoodItem> get visibleFoods {
    return menuFoods.where((food) {
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
    return menuRestaurants.where((restaurant) {
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

  Future<void> completeOnboarding() async {
    seenOnboarding = true;
    await _persistOnboarding();
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    if (!_isValidEmail(email)) {
      return 'Please enter a valid email';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    busy = true;
    notifyListeners();
    try {
      final credential = await _auth.signInWithEmail(
        email: email,
        password: password,
      );
      await _loadSignedInUser(credential.user!);
      errorMessage = null;
      return null;
    } catch (error) {
      return AuthService.mapAuthError(error);
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (name.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (!_isValidEmail(email)) {
      return 'Please enter a valid email';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    busy = true;
    notifyListeners();
    try {
      final credential = await _auth.registerWithEmail(
        name: name,
        email: email,
        password: password,
      );
      await _loadSignedInUser(credential.user!);
      return null;
    } catch (error) {
      return AuthService.mapAuthError(error);
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<String?> loginWithGoogle() async {
    busy = true;
    notifyListeners();
    try {
      final credential = await _auth.signInWithGoogle();
      if (credential?.user == null) {
        return AuthCopy.googleCancelled;
      }
      await _loadSignedInUser(credential!.user!);
      return null;
    } catch (error) {
      return AuthService.mapAuthError(error);
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> sendPhoneCode({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onFailed,
  }) async {
    try {
      await _auth.sendPhoneCode(
        phoneNumber: phoneNumber,
        onCodeSent: onCodeSent,
        onAutoVerified: (credential) async {
          try {
            final result = await _auth.signInWithPhoneCredential(credential);
            await _loadSignedInUser(result.user!);
            notifyListeners();
          } catch (error) {
            onFailed(AuthService.mapAuthError(error));
          }
        },
        onFailed: onFailed,
      );
    } catch (error) {
      onFailed(AuthService.mapAuthError(error));
    }
  }

  Future<String?> confirmPhoneCode({
    required String verificationId,
    required String smsCode,
  }) async {
    busy = true;
    notifyListeners();
    try {
      final credential = await _auth.confirmPhoneCode(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _loadSignedInUser(credential.user!);
      return null;
    } catch (error) {
      return AuthService.mapAuthError(error);
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<String?> requestReset(String email) async {
    if (!_isValidEmail(email)) {
      return 'Please enter a valid email';
    }
    final normalized = email.trim().toLowerCase();
    try {
      await _auth.sendPasswordReset(normalized);
      pendingResetEmail = normalized;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (error) {
      // Do not reveal whether the email is registered.
      if (error.code == 'user-not-found') {
        pendingResetEmail = normalized;
        notifyListeners();
        return null;
      }
      return AuthService.mapAuthError(error);
    } catch (error) {
      return AuthService.mapAuthError(error);
    }
  }

  String? verifyOtp(String code) {
    if (pendingResetEmail == null) {
      return 'Request a reset email first';
    }
    if (code.trim().isEmpty) {
      return 'Enter the verification code';
    }
    return null;
  }

  String? resetPassword(String password, String confirmPassword) {
    if (pendingResetEmail == null) {
      return 'Session expired';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    pendingResetEmail = null;
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();
    _clearUserData();
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String bio,
  }) async {
    if (currentUser == null) {
      return;
    }
    currentUser!
      ..name = name.trim()
      ..email = email.trim()
      ..phone = phone.trim()
      ..bio = bio.trim();
    await _auth.updateDisplayName(name);
    await _persistUser();
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
    _persistCart();
    notifyListeners();
  }

  void changeQty(CartLine line, int quantity) {
    if (quantity <= 0) {
      cart.remove(line);
    } else {
      line.quantity = quantity;
    }
    _persistCart();
    notifyListeners();
  }

  void removeFromCart(CartLine line) {
    cart.remove(line);
    _persistCart();
    notifyListeners();
  }

  bool applyPromo(String code) {
    if (code.trim().toUpperCase() == 'FOOD20') {
      promoCode = 'FOOD20';
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
    _persistUser();
    notifyListeners();
  }

  bool isFavorite(String foodId) => favoriteFoodIds.contains(foodId);

  List<FoodItem> get favoriteFoods =>
      menuFoods.where((food) => favoriteFoodIds.contains(food.id)).toList();

  void addAddress(AddressModel address) {
    addresses.add(address);
    selectedAddressId = address.id;
    final uid = currentUid;
    if (uid != null) {
      _db.saveAddress(uid, address);
    }
    _persistUser();
    notifyListeners();
  }

  void selectAddress(String id) {
    selectedAddressId = id;
    _persistUser();
    notifyListeners();
  }

  void addCard(PaymentCardModel card) {
    cards.add(card);
    selectedCardId = card.id;
    paymentMethod = 'Card';
    final uid = currentUid;
    if (uid != null) {
      _db.saveCard(uid, card);
    }
    _persistUser();
    notifyListeners();
  }

  void selectCard(String id) {
    selectedCardId = id;
    paymentMethod = 'Card';
    _persistUser();
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    paymentMethod = method;
    _persistUser();
    notifyListeners();
  }

  OrderModel? placeOrder() {
    if (cart.isEmpty) {
      return null;
    }
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
    final uid = currentUid;
    if (uid != null) {
      _db.saveOrder(uid, order);
      _persistCart();
    }
    addNotification(
      'Order placed',
      'Order #${order.id} from ${order.restaurantName} is being prepared.',
    );
    return order;
  }

  void cancelOrder(String id) {
    final order = orders.cast<OrderModel?>().firstWhere(
          (item) => item?.id == id,
          orElse: () => null,
        );
    if (order == null) {
      return;
    }
    order.status = OrderStatus.cancelled;
    final uid = currentUid;
    if (uid != null) {
      _db.updateOrderStatus(
        uid: uid,
        orderId: id,
        status: OrderStatus.cancelled,
      );
    }
    addNotification('Order cancelled', 'Order #$id was cancelled.');
  }

  void markDelivered(String id) {
    final order = orders.cast<OrderModel?>().firstWhere(
          (item) => item?.id == id,
          orElse: () => null,
        );
    if (order == null) {
      return;
    }
    order.status = OrderStatus.delivered;
    final uid = currentUid;
    if (uid != null) {
      _db.updateOrderStatus(
        uid: uid,
        orderId: id,
        status: OrderStatus.delivered,
      );
    }
    addNotification('Order delivered', 'Order #$id has been delivered. Enjoy!');
  }

  int get unreadCount => notifications.where((item) => !item.read).length;

  void addNotification(String title, String body) {
    final item = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      createdAt: DateTime.now(),
    );
    notifications.insert(0, item);
    final uid = currentUid;
    if (uid != null) {
      _db.saveNotification(uid, item);
    }
    notifyListeners();
  }

  void markNotificationsRead() {
    for (final item in notifications) {
      item.read = true;
    }
    final uid = currentUid;
    if (uid != null) {
      _db.markNotificationsRead(uid, notifications);
    }
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
