import 'package:flutter/material.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/models/models.dart';
import 'package:food_application/screens/my%20card%20screen/my_card_screen.dart';
import 'package:food_application/screens/tracking%20order%202%20screen/tracking_oder_2_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class MyOrders1 extends StatefulWidget {
  const MyOrders1({super.key});

  @override
  State<MyOrders1> createState() => _MyOrders1State();
}

class _MyOrders1State extends State<MyOrders1> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final list = tab == 0 ? state.ongoingOrders : state.historyOrders;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    'My Orders',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: _tab('Ongoing', 0)),
                  Expanded(child: _tab('History', 1)),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: list.isEmpty
                    ? Center(
                        child: Text(
                          tab == 0 ? 'No ongoing orders' : 'No order history yet',
                        ),
                      )
                    : ListView.separated(
                        itemCount: list.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final order = list[index];
                          return _OrderCard(order: order);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab(String label, int value) {
    final selected = tab == value;
    return GestureDetector(
      onTap: () => setState(() => tab = value),
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.field,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final ongoing = order.status == OrderStatus.ongoing;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF9AABBA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.fastfood, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.restaurantName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(order.summary, style: const TextStyle(color: Color(0xFF9EA3AA))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${order.total.toStringAsFixed(2)}'),
                  Text(
                    order.status.name.toUpperCase(),
                    style: TextStyle(
                      color: ongoing ? AppColors.primary : AppColors.muted,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (ongoing) {
                      AppNav.to(context, TrackingOder2Screen(orderId: order.id));
                    } else {
                      state.reorder(order);
                      AppNav.to(context, const MyCardScreen());
                    }
                  },
                  child: Text(ongoing ? 'Track Order' : 'Reorder'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: ongoing
                      ? () {
                          state.cancelOrder(order.id);
                          showAppSnack(context, 'Order cancelled');
                        }
                      : null,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  child: Text(
                    ongoing ? 'Cancel' : order.status.name,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
