import 'package:flutter/material.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/screens/add%20card%20screen/add_card_screen.dart';
import 'package:food_application/screens/payment%20success%20screen/payment_success_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class PaymentScreen1 extends StatefulWidget {
  const PaymentScreen1({super.key});

  @override
  State<PaymentScreen1> createState() => _PaymentScreen1State();
}

class _PaymentScreen1State extends State<PaymentScreen1> {
  void _pay() {
    final state = context.read<AppState>();
    if (state.paymentMethod == 'Card' && state.cards.isEmpty) {
      showAppSnack(context, 'Add a card first or choose cash');
      return;
    }
    final order = state.placeOrder();
    if (order == null) {
      showAppSnack(context, 'Your cart is empty');
      return;
    }
    AppNav.replace(context, PaymentSuccessScreen(orderId: order.id));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        CircleIconButton(
                          icon: Icons.arrow_back_ios_new,
                          size: 40,
                          onTap: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 10),
                        const Text('Payment', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _methodTile(
                      title: 'Cash on Delivery',
                      selected: state.paymentMethod == 'Cash',
                      onTap: () => state.setPaymentMethod('Cash'),
                    ),
                    _methodTile(
                      title: 'Card',
                      selected: state.paymentMethod == 'Card',
                      onTap: () => state.setPaymentMethod('Card'),
                    ),
                    const SizedBox(height: 12),
                    if (state.cards.isEmpty)
                      const Text('No mastercard added yet.')
                    else
                      ...state.cards.map(
                        (card) => ListTile(
                          leading: Icon(
                            state.selectedCardId == card.id
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: AppColors.primary,
                          ),
                          title: Text(card.masked),
                          subtitle: Text(card.holderName),
                          onTap: () => state.selectCard(card.id),
                        ),
                      ),
                    OutlinedButton.icon(
                      onPressed: () => AppNav.to(context, const AddCardScreen()),
                      icon: const Icon(Icons.add, color: AppColors.primary),
                      label: const Text(
                        'ADD NEW',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text('TOTAL:', style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        Text(
                          '\$${state.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: PrimaryButton(label: 'PAY & CONFIRM', onPressed: _pay),
            ),
          ],
        ),
      ),
    );
  }

  Widget _methodTile({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: AppColors.primary,
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
