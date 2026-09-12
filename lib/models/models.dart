import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.categories,
    required this.rating,
    required this.deliveryTime,
    required this.freeDelivery,
    required this.description,
  });

  final String id;
  final String name;
  final String imageUrl;
  final List<String> categories;
  final double rating;
  final int deliveryTime;
  final bool freeDelivery;
  final String description;

  String get categoryLabel => categories.join(' • ');

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'imageUrl': imageUrl,
        'categories': categories,
        'rating': rating,
        'deliveryTime': deliveryTime,
        'freeDelivery': freeDelivery,
        'description': description,
      };

  factory Restaurant.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Restaurant(
      id: doc.id,
      name: data['name'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      categories: ((data['categories'] as List?) ?? const []).cast<String>(),
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      deliveryTime: (data['deliveryTime'] as num?)?.toInt() ?? 0,
      freeDelivery: data['freeDelivery'] as bool? ?? false,
      description: data['description'] as String? ?? '',
    );
  }
}

class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.restaurantId,
    required this.restaurantName,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.deliveryTime,
    this.freeDelivery = true,
  });

  final String id;
  final String name;
  final String restaurantId;
  final String restaurantName;
  final String category;
  final double price;
  final double rating;
  final String imageUrl;
  final String description;
  final int deliveryTime;
  final bool freeDelivery;

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'restaurantId': restaurantId,
        'restaurantName': restaurantName,
        'category': category,
        'price': price,
        'rating': rating,
        'imageUrl': imageUrl,
        'description': description,
        'deliveryTime': deliveryTime,
        'freeDelivery': freeDelivery,
      };

  factory FoodItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return FoodItem(
      id: doc.id,
      name: data['name'] as String? ?? '',
      restaurantId: data['restaurantId'] as String? ?? '',
      restaurantName: data['restaurantName'] as String? ?? '',
      category: data['category'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      imageUrl: data['imageUrl'] as String? ?? '',
      description: data['description'] as String? ?? '',
      deliveryTime: (data['deliveryTime'] as num?)?.toInt() ?? 0,
      freeDelivery: data['freeDelivery'] as bool? ?? true,
    );
  }
}

class CartLine {
  CartLine({
    required this.food,
    required this.size,
    required this.quantity,
  });

  final FoodItem food;
  final String size;
  int quantity;

  double get lineTotal => food.price * quantity * sizeMultiplier;

  double get sizeMultiplier {
    switch (size) {
      case '10':
        return 0.85;
      case '16':
        return 1.2;
      default:
        return 1;
    }
  }

  Map<String, dynamic> toJson() => {
        'foodId': food.id,
        'size': size,
        'quantity': quantity,
      };

  Map<String, dynamic> toFirestore() => toJson();
}

class AddressModel {
  AddressModel({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.street,
    required this.postCode,
    required this.apartment,
  });

  final String id;
  String label;
  String fullAddress;
  String street;
  String postCode;
  String apartment;

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'fullAddress': fullAddress,
        'street': street,
        'postCode': postCode,
        'apartment': apartment,
      };

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      label: json['label'] as String? ?? 'Home',
      fullAddress: json['fullAddress'] as String? ?? '',
      street: json['street'] as String? ?? '',
      postCode: json['postCode'] as String? ?? '',
      apartment: json['apartment'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'label': label,
        'fullAddress': fullAddress,
        'street': street,
        'postCode': postCode,
        'apartment': apartment,
      };

  factory AddressModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return AddressModel.fromJson({...data, 'id': doc.id});
  }
}

class PaymentCardModel {
  PaymentCardModel({
    required this.id,
    required this.holderName,
    required this.number,
    required this.expiry,
    required this.cvc,
  });

  final String id;
  String holderName;
  String number;
  String expiry;
  String cvc;

  String get last4 {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4) return '0000';
    return digits.substring(digits.length - 4);
  }

  String get masked => '**** **** **** $last4';

  Map<String, dynamic> toJson() => {
        'id': id,
        'holderName': holderName,
        'number': number,
        'expiry': expiry,
        'cvc': cvc,
      };

  factory PaymentCardModel.fromJson(Map<String, dynamic> json) {
    return PaymentCardModel(
      id: json['id'] as String,
      holderName: json['holderName'] as String? ?? '',
      number: json['number'] as String? ?? json['last4'] as String? ?? '',
      expiry: json['expiry'] as String? ?? '',
      cvc: json['cvc'] as String? ?? '',
    );
  }

  Map<String, dynamic> toSafeFirestore() => {
        'holderName': holderName,
        'last4': last4,
        'expiry': expiry,
      };

  factory PaymentCardModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return PaymentCardModel.fromJson({...data, 'id': doc.id});
  }
}

enum OrderStatus { ongoing, delivered, cancelled }

class OrderModel {
  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.address,
    required this.paymentLabel,
    required this.createdAt,
    required this.status,
    required this.restaurantName,
  });

  final String id;
  final List<CartLine> items;
  final double total;
  final String address;
  final String paymentLabel;
  final DateTime createdAt;
  OrderStatus status;
  final String restaurantName;

  int get itemCount => items.fold(0, (total, item) => total + item.quantity);

  String get summary {
    if (items.isEmpty) return '0 items';
    return '${items.first.quantity}x ${items.first.size}" | $itemCount items';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'total': total,
        'address': address,
        'paymentLabel': paymentLabel,
        'createdAt': createdAt.toIso8601String(),
        'status': status.name,
        'restaurantName': restaurantName,
        'items': items
            .map(
              (item) => {
                'foodId': item.food.id,
                'size': item.size,
                'quantity': item.quantity,
              },
            )
            .toList(),
      };

  Map<String, dynamic> toFirestore(String uid) => {
        'uid': uid,
        'total': total,
        'address': address,
        'paymentLabel': paymentLabel,
        'createdAt': Timestamp.fromDate(createdAt),
        'status': status.name,
        'restaurantName': restaurantName,
        'items': items
            .map(
              (item) => {
                'foodId': item.food.id,
                'name': item.food.name,
                'size': item.size,
                'quantity': item.quantity,
                'price': item.food.price,
                'restaurantName': item.food.restaurantName,
              },
            )
            .toList(),
      };

  factory OrderModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    final lines = ((data['items'] as List?) ?? []).map((line) {
      final lineMap = line as Map<String, dynamic>;
      return CartLine(
        food: FoodItem(
          id: lineMap['foodId'] as String? ?? '',
          name: lineMap['name'] as String? ?? 'Item',
          restaurantId: '',
          restaurantName: lineMap['restaurantName'] as String? ?? '',
          category: '',
          price: (lineMap['price'] as num?)?.toDouble() ?? 0,
          rating: 0,
          imageUrl: '',
          description: '',
          deliveryTime: 0,
        ),
        size: lineMap['size'] as String? ?? '14',
        quantity: (lineMap['quantity'] as num?)?.toInt() ?? 1,
      );
    }).toList();

    return OrderModel(
      id: doc.id,
      items: lines,
      total: (data['total'] as num?)?.toDouble() ?? 0,
      address: data['address'] as String? ?? '',
      paymentLabel: data['paymentLabel'] as String? ?? 'Cash',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['createdAt'] as String? ?? '') ??
              DateTime.now(),
      status: OrderStatus.values.firstWhere(
        (value) => value.name == data['status'],
        orElse: () => OrderStatus.ongoing,
      ),
      restaurantName: data['restaurantName'] as String? ?? 'Restaurant',
    );
  }
}

class UserAccount {
  UserAccount({
    required this.uid,
    required this.name,
    required this.email,
    this.password = '',
    this.phone = '',
    this.bio = 'I love fast food',
  });

  final String uid;
  String name;
  String email;
  String password;
  String phone;
  String bio;

  String get firstName {
    final parts = name.trim().split(' ');
    return parts.isEmpty ? 'there' : parts.first;
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'bio': bio,
      };

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'bio': bio,
      };

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      bio: json['bio'] as String? ?? 'I love fast food',
    );
  }

  factory UserAccount.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return UserAccount.fromJson({...?doc.data(), 'uid': doc.id});
  }
}

class FilterOptions {
  FilterOptions({
    this.minPrice = 0,
    this.maxPrice = 200,
    this.minRating = 0,
    this.maxDeliveryTime = 60,
    this.offersFreeDelivery = false,
  });

  double minPrice;
  double maxPrice;
  double minRating;
  int maxDeliveryTime;
  bool offersFreeDelivery;

  FilterOptions copy() {
    return FilterOptions(
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      maxDeliveryTime: maxDeliveryTime,
      offersFreeDelivery: offersFreeDelivery,
    );
  }

  bool get isDefault =>
      minPrice == 0 &&
      maxPrice == 200 &&
      minRating == 0 &&
      maxDeliveryTime == 60 &&
      !offersFreeDelivery;
}

class AppNotification {
  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  bool read;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
        'read': read,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      read: json['read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'body': body,
        'createdAt': Timestamp.fromDate(createdAt),
        'read': read,
      };

  factory AppNotification.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return AppNotification(
      id: doc.id,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['createdAt'] as String? ?? '') ??
              DateTime.now(),
      read: data['read'] as bool? ?? false,
    );
  }
}

class FoodReview {
  const FoodReview({
    required this.author,
    required this.rating,
    required this.comment,
  });

  final String author;
  final double rating;
  final String comment;
}
