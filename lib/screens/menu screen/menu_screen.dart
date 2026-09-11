import 'package:flutter/material.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/screens/add%20new%20address%20screen/add_new_address_screen.dart';
import 'package:food_application/screens/edit%20profile%20screen/edit_profile_screen.dart';
import 'package:food_application/screens/food%20detail%201%20screen/food_detail_secreen1.dart';
import 'package:food_application/screens/login%20screen/login_screen.dart';
import 'package:food_application/screens/my%20orders%201/my_orders_1.dart';
import 'package:food_application/screens/payment%20sceen%201/payment_screen1.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
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
                const SizedBox(width: 10),
                const Text(
                  'Profile',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFFFC4AD),
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Guest',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user?.bio ?? 'I love fast food',
                        style: const TextStyle(color: Color(0xFFA0A4AA)),
                      ),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _tile(Icons.person_outline, 'Personal Info', () {
              AppNav.to(context, const EditProfileScreen());
            }),
            _tile(Icons.receipt_long_outlined, 'My Orders', () {
              AppNav.to(context, const MyOrders1());
            }),
            _tile(Icons.location_on_outlined, 'Addresses', () {
              AppNav.to(context, const AddLocationScreen());
            }),
            _tile(Icons.credit_card, 'Payment Methods', () {
              AppNav.to(context, const PaymentScreen1());
            }),
            const Divider(),
            const Text(
              'Favorites',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (state.favoriteFoods.isEmpty)
              const Text('No favorites yet. Tap the heart on a food item.')
            else
              ...state.favoriteFoods.map(
                (food) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SizedBox(
                    width: 56,
                    child: FoodNetworkImage(url: food.imageUrl, height: 52, radius: 8),
                  ),
                  title: Text(food.name),
                  subtitle: Text('\$${food.price.toStringAsFixed(0)}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => AppNav.to(context, FoodDetailSecreen1(foodId: food.id)),
                ),
              ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log Out', style: TextStyle(color: Colors.red)),
              onTap: () {
                state.logout();
                AppNav.offAll(context, const LoginScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.field,
        child: Icon(icon, color: AppColors.dark),
      ),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
