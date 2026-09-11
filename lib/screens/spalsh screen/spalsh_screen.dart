import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:food_application/core/app_assets.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/screens/login%20screen/login_screen.dart';
import 'package:food_application/screens/main%20shell/main_shell.dart';
import 'package:food_application/screens/onboarding%20screen/onboarding_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:provider/provider.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  bool _opened = false;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted || _opened) return;
    final state = context.read<AppState>();
    var guard = 0;
    while (!state.hydrated && guard < 40) {
      await Future.delayed(const Duration(milliseconds: 50));
      guard++;
    }
    if (!mounted || _opened) return;
    _opened = true;
    if (state.isLoggedIn) {
      AppNav.offAll(context, const MainShell());
    } else if (state.seenOnboarding) {
      AppNav.offAll(context, const LoginScreen());
    } else {
      AppNav.replace(context, const OnboardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cartBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.logo,
              width: 220,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                Icons.fastfood,
                size: 96,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              child: AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  FadeAnimatedText('Foodie', duration: const Duration(milliseconds: 1200)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
