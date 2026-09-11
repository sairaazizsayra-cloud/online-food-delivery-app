import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_application/core/app_assets.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/models/models.dart';
import 'package:food_application/widgets/common_widgets.dart';

void main() {
  test('app primary color stays Foodie orange', () {
    expect(AppColors.primary, const Color(0xFFFF7622));
  });

  testWidgets('food cards fit a narrow popular grid without overflow', (tester) async {
    const food = FoodItem(
      id: 'p1',
      name: 'Pizza Calzone European',
      restaurantId: 'r3',
      restaurantName: 'Pansi Restaurant',
      category: 'Pizza',
      price: 12,
      rating: 4.7,
      imageUrl: AppAssets.foodPizza,
      description: 'Oven baked pizza',
      deliveryTime: 20,
    );

    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GridView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: foodCardGridDelegate,
            children: [
              FoodCard(food: food, onTap: () {}, onAdd: () {}),
              FoodCard(food: food, onTap: () {}, onAdd: () {}),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Pizza Calzone European'), findsNWidgets(2));
    expect(find.text('Pansi Restaurant'), findsNWidgets(2));
  });
}
