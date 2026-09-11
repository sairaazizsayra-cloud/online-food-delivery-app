import 'package:flutter/material.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/data/catalog.dart';
import 'package:food_application/screens/filter%20screen/filter_screen.dart';
import 'package:food_application/screens/food%20detail%201%20screen/food_detail_secreen1.dart';
import 'package:food_application/screens/resturent%20view%201%20screen/resturent_view_1_screen.dart';
import 'package:food_application/screens/search%20screen/search_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class BurgerScreen extends StatefulWidget {
  const BurgerScreen({super.key, this.category = 'Burger'});

  final String category;

  @override
  State<BurgerScreen> createState() => _BurgerScreenState();
}

class _BurgerScreenState extends State<BurgerScreen> {
  late String category = widget.category;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final foods = Catalog.foodsForCategory(category);
    final restaurants = Catalog.restaurants
        .where(
          (restaurant) =>
              category == 'All' || restaurant.categories.contains(category),
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                CircleIconButton(
                  icon: Icons.arrow_back_ios_new,
                  size: 40,
                  onTap: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  initialValue: category,
                  onSelected: (value) => setState(() => category = value),
                  itemBuilder: (_) => Catalog.categories
                      .map((item) => PopupMenuItem(value: item, child: Text(item)))
                      .toList(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          category.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.orange),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                CircleIconButton(
                  icon: Icons.search,
                  size: 40,
                  background: const Color(0xFF171827),
                  iconColor: Colors.white,
                  onTap: () => AppNav.to(context, const SearchScreen()),
                ),
                const SizedBox(width: 8),
                CircleIconButton(
                  icon: Icons.tune,
                  size: 40,
                  iconColor: Colors.orange,
                  onTap: () => AppNav.to(context, const FilterScreen()),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Popular $category',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: foods.length,
              gridDelegate: foodCardGridDelegate,
              itemBuilder: (context, index) {
                final food = foods[index];
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
            const SizedBox(height: 18),
            const Text(
              'Open Restaurants',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ...restaurants.map(
              (restaurant) => ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () => AppNav.to(
                  context,
                  ResturentView1Screen(restaurantId: restaurant.id),
                ),
                leading: SizedBox(
                  width: 64,
                  child: FoodNetworkImage(url: restaurant.imageUrl, height: 52, radius: 8),
                ),
                title: Text(restaurant.name),
                subtitle: RestaurantMetaRow(
                  rating: restaurant.rating,
                  freeDelivery: restaurant.freeDelivery,
                  minutes: restaurant.deliveryTime,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
