import 'package:flutter/material.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/data/catalog.dart';
import 'package:food_application/screens/food%20detail%201%20screen/food_detail_secreen1.dart';
import 'package:food_application/screens/my%20card%20screen/my_card_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class ResturentView1Screen extends StatefulWidget {
  const ResturentView1Screen({super.key, this.restaurantId = 'r2'});

  final String restaurantId;

  @override
  State<ResturentView1Screen> createState() => _ResturentView1ScreenState();
}

class _ResturentView1ScreenState extends State<ResturentView1Screen> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final restaurant =
        Catalog.restaurantById(widget.restaurantId) ?? Catalog.restaurants.first;
    final foods = Catalog.foodsForRestaurant(restaurant.id);
    final categories = foods.map((food) => food.category).toSet().toList();
    final visible = selectedCategory == null
        ? foods
        : foods.where((food) => food.category == selectedCategory).toList();
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                CircleIconButton(
                  icon: Icons.arrow_back_ios_new,
                  size: 40,
                  onTap: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                ),
                const Spacer(),
                const Text(
                  'Restaurant View',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                CartBadgeButton(
                  onTap: () => AppNav.to(context, const MyCardScreen()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FoodNetworkImage(url: restaurant.imageUrl, height: 150, radius: 18),
            const SizedBox(height: 12),
            Text(
              restaurant.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(restaurant.description, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            RestaurantMetaRow(
              rating: restaurant.rating,
              freeDelivery: restaurant.freeDelivery,
              minutes: restaurant.deliveryTime,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('All'),
                      selected: selectedCategory == null,
                      onSelected: (_) => setState(() => selectedCategory = null),
                    ),
                  ),
                  ...categories.map(
                    (category) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (_) => setState(() => selectedCategory = category),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${selectedCategory ?? 'Menu'} (${visible.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visible.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                final food = visible[index];
                return FoodCard(
                  food: food,
                  onTap: () => AppNav.to(context, FoodDetailSecreen1(foodId: food.id)),
                  onAdd: () {
                    state.addToCart(food);
                    showAppSnack(context, '${food.name} added to cart');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
