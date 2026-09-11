import 'package:flutter/material.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/screens/main%20shell/main_shell.dart';
import 'package:food_application/screens/tracking%20order%202%20screen/tracking_oder_2_screen.dart';
import 'package:food_application/widgets/common_widgets.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.check_circle, color: Color(0xFFFF7622), size: 120),
              const SizedBox(height: 20),
              const Text(
                'Congratulations!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                orderId == null
                    ? 'You successfully made a payment.\nEnjoy our service!'
                    : 'Order #$orderId is confirmed.\nEnjoy our service!',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF98A8B8), fontSize: 16),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'TRACK ORDER',
                onPressed: () => AppNav.replace(
                  context,
                  TrackingOder2Screen(orderId: orderId),
                ),
              ),
              TextButton(
                onPressed: () => AppNav.offAll(context, const MainShell()),
                child: const Text('Back to Home'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
