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
      number: json['number'] as String? ?? '',
      expiry: json['expiry'] as String? ?? '',
      cvc: json['cvc'] as String? ?? '',
    );
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

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

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
}

class UserAccount {
  UserAccount({
    required this.name,
    required this.email,
    required this.password,
    this.phone = '',
    this.bio = 'I love fast food',
  });

  String name;
  final String email;
  String password;
  String phone;
  String bio;

  String get firstName {
    final parts = name.trim().split(' ');
    return parts.isEmpty ? 'there' : parts.first;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'bio': bio,
      };

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      bio: json['bio'] as String? ?? 'I love fast food',
    );
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
