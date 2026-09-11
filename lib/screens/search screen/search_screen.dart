import 'package:flutter/material.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/screens/food%20detail%201%20screen/food_detail_secreen1.dart';
import 'package:food_application/screens/my%20card%20screen/my_card_screen.dart';
import 'package:food_application/screens/resturent%20view%201%20screen/resturent_view_1_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.text = context.read<AppState>().searchQuery;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final foods = state.visibleFoods;
    final restaurants = state.visibleRestaurants;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
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
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Search', style: TextStyle(fontSize: 18)),
                ),
                CartBadgeButton(
                  onTap: () => AppNav.to(context, const MyCardScreen()),
                ),
              ],
            ),
            const SizedBox(height: 18),
            TextField(
              controller: searchController,
              onChanged: state.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Pizza, burger, pasta...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                    state.setSearchQuery('');
                  },
                  icon: const Icon(Icons.cancel),
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Recent Keywords',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: ['Burger', 'Pizza', 'Pasta', 'Chicken', 'Drinks']
                  .map(
                    (keyword) => ActionChip(
                      label: Text(keyword),
                      onPressed: () {
                        searchController.text = keyword;
                        state.setSearchQuery(keyword);
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 18),
            const Text(
              'Restaurants',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...restaurants.map(
              (restaurant) => ListTile(
                onTap: () => AppNav.to(
                  context,
                  ResturentView1Screen(restaurantId: restaurant.id),
                ),
                contentPadding: EdgeInsets.zero,
                leading: SizedBox(
                  width: 60,
                  child: FoodNetworkImage(url: restaurant.imageUrl, height: 54, radius: 10),
                ),
                title: Text(restaurant.name),
                subtitle: Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFF7622), size: 16),
                    Text(' ${restaurant.rating}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Foods',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: foods.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
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
          ],
        ),
      ),
    );
  }
}
