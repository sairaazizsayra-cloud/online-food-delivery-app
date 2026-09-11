import 'package:flutter/material.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/screens/home%20screen%20v1/home_screen%20v1.dart';
import 'package:food_application/screens/menu%20screen/menu_screen.dart';
import 'package:food_application/screens/my%20card%20screen/my_card_screen.dart';
import 'package:food_application/screens/my%20orders%201/my_orders_1.dart';
import 'package:food_application/state/app_state.dart';
import 'package:provider/provider.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<AppState>().cartCount;
    final pages = const [
      HomeScreenv1(),
      MyOrders1(),
      MyCardScreen(),
      MenuScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.muted,
        onTap: (value) => setState(() => index = value),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
