import 'package:flutter/material.dart';
import 'package:food_application/core/app_assets.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/screens/login%20screen/login_screen.dart';
import 'package:food_application/screens/onboarding%20screen3/onboarding_screen3.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  void _skip() {
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
                url: AppAssets.onboardChefs,
                height: 220,
                radius: 16,
              ),
              const SizedBox(height: 30),
              const Text(
                'Order From Chosen Chefs',
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
              PrimaryButton(
                label: 'NEXT',
                onPressed: () => AppNav.to(context, const OnboardingScreen3()),
              ),
              TextButton(
                onPressed: _skip,
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
