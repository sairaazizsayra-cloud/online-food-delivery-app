import 'package:flutter/material.dart';
import 'package:food_application/core/app_assets.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/models/models.dart';
import 'package:food_application/screens/delivery%20man%20call%20screen/delivery_man_call%20_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class TrackingOder2Screen extends StatelessWidget {
  const TrackingOder2Screen({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final order = state.orders.cast<OrderModel?>().firstWhere(
          (item) => item?.id == orderId,
          orElse: () => state.orders.isEmpty ? null : state.orders.first,
        );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const FoodNetworkImage(
                    url: AppAssets.locationMap,
                    height: double.infinity,
                    radius: 0,
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleIconButton(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () {
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order == null ? 'No active order' : 'Order #${order.id}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    order?.address ?? 'Waiting for an order',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const _TrackStep(title: 'Order placed', done: true),
                  const _TrackStep(title: 'Restaurant preparing', done: true),
                  _TrackStep(
                    title: 'On the way',
                    done: order?.status == OrderStatus.ongoing ||
                        order?.status == OrderStatus.delivered,
                  ),
                  _TrackStep(
                    title: 'Delivered',
                    done: order?.status == OrderStatus.delivered,
                    isLast: true,
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF91A4B6),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: const Text('Robert Fox'),
                    subtitle: const Text('Delivery partner'),
                    trailing: CircleIconButton(
                      icon: Icons.phone,
                      background: AppColors.primary,
                      iconColor: Colors.white,
                      size: 42,
                      onTap: () => AppNav.to(context, const CallingScreen()),
                    ),
                  ),
                  if (order?.status == OrderStatus.ongoing)
                    PrimaryButton(
                      label: 'MARK DELIVERED (DEMO)',
                      onPressed: () {
                        state.markDelivered(order!.id);
                        showAppSnack(context, 'Order delivered');
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackStep extends StatelessWidget {
  const _TrackStep({
    required this.title,
    required this.done,
    this.isLast = false,
  });

  final String title;
  final bool done;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: done ? AppColors.primary : Colors.grey,
            ),
            if (!isLast)
              Container(width: 2, height: 22, color: done ? AppColors.primary : Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: done ? AppColors.dark : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
