import 'package:flutter/material.dart';
import 'package:food_application/core/app_assets.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/screens/login%20screen/login_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({super.key});

  @override
  State<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3> {
  void _finish() {
    context.read<AppState>().completeOnboarding();
    AppNav.offAll(context, const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 25),
              const FoodNetworkImage(
                url: AppAssets.onboardDelivery,
                height: 220,
                radius: 16,
              ),
              const SizedBox(height: 30),
              const Text(
                'Free Delivery Offers',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Get all your loved foods in one place,\nyou just place the order we do the rest',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Spacer(),
              PrimaryButton(label: 'GET STARTED', onPressed: _finish),
              TextButton(
                onPressed: _finish,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
