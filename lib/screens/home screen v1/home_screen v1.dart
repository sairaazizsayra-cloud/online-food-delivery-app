import 'package:flutter/material.dart';
import 'package:food_application/core/app_assets.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/data/catalog.dart';
import 'package:food_application/models/models.dart';
import 'package:food_application/screens/add%20new%20address%20screen/add_new_address_screen.dart';
import 'package:food_application/screens/burger%20screen/burger_screen.dart';
import 'package:food_application/screens/edit%20profile%20screen/edit_profile_screen.dart';
import 'package:food_application/screens/filter%20screen/filter_screen.dart';
import 'package:food_application/screens/login%20screen/login_screen.dart';
import 'package:food_application/screens/menu%20screen/menu_screen.dart';
import 'package:food_application/screens/my%20card%20screen/my_card_screen.dart';
import 'package:food_application/screens/my%20orders%201/my_orders_1.dart';
import 'package:food_application/screens/notifications%20screen/notifications_screen.dart';
import 'package:food_application/screens/resturent%20view%201%20screen/resturent_view_1_screen.dart';
import 'package:food_application/screens/search%20screen/search_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class HomeScreenv1 extends StatefulWidget {
  const HomeScreenv1({super.key});

  @override
  State<HomeScreenv1> createState() => _HomeScreenv1State();
}

class _HomeScreenv1State extends State<HomeScreenv1> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
    final restaurants = state.visibleRestaurants;
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _HomeDrawer(name: user?.name ?? 'Guest'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Builder(
                  builder: (context) => CircleIconButton(
                    icon: Icons.menu,
                    onTap: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DELIVER TO',
                        style: TextStyle(
                          color: AppColors.primarySoft,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => AppNav.to(context, const AddLocationScreen()),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                state.selectedAddress?.label ?? 'Halal Lab Office',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Color(0xFF676767)),
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleIconButton(
                      icon: Icons.notifications_none,
                      onTap: () =>
                          AppNav.to(context, const NotificationsScreen()),
                    ),
                    if (state.unreadCount > 0)
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${state.unreadCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                CartBadgeButton(
                  onTap: () => AppNav.to(context, const MyCardScreen()),
                ),
              ],
            ),
            const SizedBox(height: 22),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Color(0xFF1E1D1D), fontSize: 16),
                children: [
                  TextSpan(text: 'Hey ${user?.firstName ?? 'there'}, '),
                  TextSpan(
                    text: state.greeting,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => AppNav.to(context, const SearchScreen()),
                    child: AbsorbPointer(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Search dishes, restaurants',
                            prefixIcon: Icon(Icons.search, color: Color(0xFFA0A5BA)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleIconButton(
                  icon: Icons.tune,
                  iconColor: AppColors.primary,
                  onTap: () => AppNav.to(context, const FilterScreen()),
                ),
              ],
            ),
            const SizedBox(height: 22),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  const FoodNetworkImage(
                    url: AppAssets.homeBanner,
                    height: 160,
                    radius: 0,
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withValues(alpha: 0.62),
                            Colors.black.withValues(alpha: 0.12),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 18,
                    right: 18,
                    bottom: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hungry right now?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Order your favorite meals in minutes',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Text(
                  'All Categories',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => AppNav.to(context, const BurgerScreen()),
                  child: const Text('See All'),
                ),
              ],
            ),
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: Catalog.categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final category = Catalog.categories[index];
                  final selected = state.selectedCategory == category;
                  return GestureDetector(
                    onTap: () {
                      state.setCategory(category);
                      if (category != 'All') {
                        AppNav.to(context, BurgerScreen(category: category));
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: FoodNetworkImage(
                              url: AppAssets.categoryImage(category),
                              height: 58,
                              width: 58,
                              radius: 29,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.w500,
                            color: selected
                                ? AppColors.primary
                                : AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Open Restaurants',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => AppNav.to(context, const BurgerScreen()),
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...restaurants.map(
              (restaurant) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: _RestaurantTile(restaurant: restaurant),
              ),
            ),
            if (restaurants.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: Text('No restaurants match your filters')),
              ),
          ],
        ),
      ),
    );
  }
}

class _RestaurantTile extends StatelessWidget {
  const _RestaurantTile({required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNav.to(
        context,
        ResturentView1Screen(restaurantId: restaurant.id),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FoodNetworkImage(url: restaurant.imageUrl, height: 150, radius: 20),
          const SizedBox(height: 10),
          Text(
            restaurant.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            restaurant.categoryLabel,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 6),
          RestaurantMetaRow(
            rating: restaurant.rating,
            freeDelivery: restaurant.freeDelivery,
            minutes: restaurant.deliveryTime,
          ),
        ],
      ),
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFC4AD),
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Foodie member'),
            ),
            const Divider(),
            _item(context, Icons.person_outline, 'Personal Info', const EditProfileScreen()),
            _item(context, Icons.receipt_long_outlined, 'My Orders', const MyOrders1()),
            _item(context, Icons.favorite_border, 'Favorites', const MenuScreen()),
            _item(context, Icons.notifications_none, 'Notifications', const NotificationsScreen()),
            _item(context, Icons.shopping_bag_outlined, 'Cart', const MyCardScreen()),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log Out', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await context.read<AppState>().logout();
                if (!context.mounted) {
                  return;
                }
                AppNav.offAll(context, const LoginScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, Widget page) {
    return ListTile(
      leading: Icon(icon, color: AppColors.dark),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        AppNav.to(context, page);
      },
    );
  }
}
