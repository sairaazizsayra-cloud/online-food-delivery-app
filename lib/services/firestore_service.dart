import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:food_application/core/firebase_constants.dart';
import 'package:food_application/data/catalog.dart';
import 'package:food_application/models/models.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> userRef(String uid) {
    return _db.collection(FirebaseCollections.users).doc(uid);
  }

  CollectionReference<Map<String, dynamic>> _userCol(String uid, String name) {
    return userRef(uid).collection(name);
  }

  Future<UserAccount> ensureUserProfile({
    required String uid,
    required String name,
    required String email,
    String phone = '',
  }) async {
    final existing = await loadUserProfile(uid);
    if (existing != null) {
      return existing;
    }

    final user = UserAccount(
      uid: uid,
      name: name.trim().isEmpty ? 'Foodie User' : name.trim(),
      email: email.trim(),
      phone: phone.trim(),
    );
    await userRef(uid).set(user.toFirestore());
    return user;
  }

  Future<UserAccount?> loadUserProfile(String uid) async {
    try {
      final snapshot = await userRef(uid).get();
      if (!snapshot.exists) {
        return null;
      }
      return UserAccount.fromFirestore(snapshot);
    } catch (error) {
      debugPrint('Error loading user profile: $error');
      return null;
    }
  }

  Future<void> saveUserSettings({
    required String uid,
    required UserAccount user,
    required String? selectedAddressId,
    required String? selectedCardId,
    required String paymentMethod,
    required List<String> favoriteFoodIds,
  }) {
    return userRef(uid).set(
      {
        ...user.toFirestore(),
        'selectedAddressId': selectedAddressId,
        'selectedCardId': selectedCardId,
        'paymentMethod': paymentMethod,
        'favoriteFoodIds': favoriteFoodIds,
      },
      SetOptions(merge: true),
    );
  }

  Future<Map<String, dynamic>> loadUserSettings(String uid) async {
    final snapshot = await userRef(uid).get();
    return snapshot.data() ?? {};
  }

  Future<List<AddressModel>> loadAddresses(String uid) async {
    final snapshot = await _userCol(uid, FirebaseCollections.addresses).get();
    return snapshot.docs.map(AddressModel.fromFirestore).toList();
  }

  Future<void> saveAddress(String uid, AddressModel address) {
    return _userCol(uid, FirebaseCollections.addresses)
        .doc(address.id)
        .set(address.toFirestore());
  }

  Future<List<PaymentCardModel>> loadCards(String uid) async {
    final snapshot = await _userCol(uid, FirebaseCollections.cards).get();
    return snapshot.docs.map(PaymentCardModel.fromFirestore).toList();
  }

  Future<void> saveCard(String uid, PaymentCardModel card) {
    return _userCol(uid, FirebaseCollections.cards)
        .doc(card.id)
        .set(card.toSafeFirestore());
  }

  Future<List<CartLine>> loadCart(String uid) async {
    final snapshot = await _userCol(uid, FirebaseCollections.cart).get();
    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          final food = Catalog.foodById(data['foodId'] as String? ?? '');
          if (food == null) {
            return null;
          }
          return CartLine(
            food: food,
            size: data['size'] as String? ?? '14',
            quantity: (data['quantity'] as num?)?.toInt() ?? 1,
          );
        })
        .whereType<CartLine>()
        .toList();
  }

  Future<void> saveCart(String uid, List<CartLine> cart) async {
    final col = _userCol(uid, FirebaseCollections.cart);
    final existing = await col.get();
    final keepIds = <String>{};
    final batch = _db.batch();
    for (final line in cart) {
      final id = '${line.food.id}_${line.size}';
      keepIds.add(id);
      batch.set(col.doc(id), line.toFirestore());
    }
    for (final doc in existing.docs) {
      if (!keepIds.contains(doc.id)) {
        batch.delete(doc.reference);
      }
    }
    await batch.commit();
  }

  Future<List<OrderModel>> loadOrders(String uid) async {
    final snapshot = await _userCol(uid, FirebaseCollections.orders).get();
    final orders = snapshot.docs.map(OrderModel.fromFirestore).toList();
    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return orders;
  }

  Future<void> saveOrder(String uid, OrderModel order) {
    return _userCol(uid, FirebaseCollections.orders)
        .doc(order.id)
        .set(order.toFirestore(uid));
  }

  Future<void> updateOrderStatus({
    required String uid,
    required String orderId,
    required OrderStatus status,
  }) {
    return _userCol(uid, FirebaseCollections.orders).doc(orderId).update({
      'status': status.name,
    });
  }

  Future<List<AppNotification>> loadNotifications(String uid) async {
    final snapshot =
        await _userCol(uid, FirebaseCollections.notifications).get();
    final items = snapshot.docs.map(AppNotification.fromFirestore).toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<void> saveNotification(String uid, AppNotification notification) {
    return _userCol(uid, FirebaseCollections.notifications)
        .doc(notification.id)
        .set(notification.toFirestore());
  }

  Future<void> markNotificationsRead(
    String uid,
    List<AppNotification> items,
  ) async {
    if (items.isEmpty) {
      return;
    }
    final batch = _db.batch();
    for (final item in items) {
      batch.update(
        _userCol(uid, FirebaseCollections.notifications).doc(item.id),
        {'read': true},
      );
    }
    await batch.commit();
  }

  Future<List<Restaurant>> loadRestaurants() async {
    final snapshot = await _db.collection(FirebaseCollections.restaurants).get();
    return snapshot.docs.map(Restaurant.fromFirestore).toList();
  }

  Future<List<FoodItem>> loadFoods() async {
    final snapshot = await _db.collection(FirebaseCollections.foods).get();
    return snapshot.docs.map(FoodItem.fromFirestore).toList();
  }

  Future<void> ensureCatalogSeeded() async {
    try {
      final restaurants =
          await _db.collection(FirebaseCollections.restaurants).limit(1).get();
      if (restaurants.docs.isNotEmpty) {
        return;
      }

      final batch = _db.batch();
      for (final restaurant in Catalog.restaurants) {
        batch.set(
          _db.collection(FirebaseCollections.restaurants).doc(restaurant.id),
          restaurant.toFirestore(),
        );
      }
      for (final food in Catalog.foods) {
        batch.set(
          _db.collection(FirebaseCollections.foods).doc(food.id),
          food.toFirestore(),
        );
      }
      await batch.commit();
    } catch (error) {
      debugPrint('Error seeding catalog: $error');
    }
  }
}
