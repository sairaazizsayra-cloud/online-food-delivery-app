import 'package:flutter/material.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/screens/add%20new%20address%20screen/add_new_address_screen.dart';
import 'package:food_application/screens/payment%20sceen%201/payment_screen1.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class MyCardScreen extends StatefulWidget {
  const MyCardScreen({super.key});

  @override
  State<MyCardScreen> createState() => _MyCardScreenState();
}

class _MyCardScreenState extends State<MyCardScreen> {
  final promoController = TextEditingController();

  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: AppColors.cartBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  if (Navigator.canPop(context))
                    CircleIconButton(
                      icon: Icons.arrow_back_ios_new,
                      background: AppColors.cartItem,
                      iconColor: Colors.white,
                      size: 40,
                      onTap: () => Navigator.pop(context),
                    )
                  else
                    const SizedBox(width: 40, height: 40),
                  const SizedBox(width: 10),
                  const Text('Cart', style: TextStyle(color: Colors.white, fontSize: 18)),
                  const Spacer(),
                  Text(
                    '${state.cartCount} items',
                    style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.cart.isEmpty
                  ? const Center(
                      child: Text(
                        'Your cart is empty',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.cart.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final line = state.cart[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 88,
                              child: FoodNetworkImage(
                                url: line.food.imageUrl,
                                height: 88,
                                radius: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    line.food.name,
                                    style: const TextStyle(color: Colors.white, fontSize: 15),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${line.lineTotal.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${line.size}"',
                                    style: const TextStyle(color: Color(0xFF777687)),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => state.removeFromCart(line),
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Color(0xFFFF4B4B),
                                child: Icon(Icons.close, color: Colors.white, size: 14),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.cartItem,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => state.changeQty(line, line.quantity - 1),
                                    child: const Icon(Icons.remove, color: Colors.white70, size: 18),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      '${line.quantity}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => state.changeQty(line, line.quantity + 1),
                                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'DELIVERY ADDRESS',
                        style: TextStyle(color: Color(0xFF9BA3AF), fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => AppNav.to(context, const AddLocationScreen()),
                        child: const Text(
                          'EDIT',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF4F8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      state.selectedAddress?.fullAddress ?? 'Add a delivery address',
                      style: const TextStyle(color: Color(0xFF9BA3AF)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: promoController,
                          decoration: InputDecoration(
                            hintText: 'Promo code FOOD20',
                            filled: true,
                            fillColor: AppColors.field,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final ok = state.applyPromo(promoController.text);
                          showAppSnack(
                            context,
                            ok ? 'Promo applied' : 'Invalid code. Try FOOD20',
                          );
                        },
                        child: const Text('APPLY'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('TOTAL:', style: TextStyle(color: Color(0xFF9BA3AF))),
                      const SizedBox(width: 8),
                      Text(
                        '\$${state.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark,
                        ),
                      ),
                      const Spacer(),
                      if (state.discount > 0)
                        Text(
                          'Saved \$${state.discount.toStringAsFixed(2)}',
                          style: const TextStyle(color: AppColors.primary),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'PLACE ORDER',
                    onPressed: state.cart.isEmpty
                        ? null
                        : () => AppNav.to(context, const PaymentScreen1()),
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
