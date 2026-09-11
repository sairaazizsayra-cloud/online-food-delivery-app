import 'package:flutter/material.dart';
import 'package:food_application/core/app_assets.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/screens/login%20screen/login_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final _pages = const [
    _OnboardPage(
      icon: Icons.favorite,
      title: 'All Your Favorites',
      subtitle:
          'Get all your loved foods in one place.\nYou just place the order, we do the rest.',
      image: AppAssets.onboardFavorites,
    ),
    _OnboardPage(
      icon: Icons.restaurant,
      title: 'Order From Chosen Chefs',
      subtitle:
          'Browse nearby restaurants and chefs.\nFresh meals delivered to your door.',
      image: AppAssets.onboardChefs,
    ),
    _OnboardPage(
      icon: Icons.delivery_dining,
      title: 'Free Delivery Offers',
      subtitle:
          'Enjoy free delivery on selected restaurants\nand exclusive first-order deals.',
      image: AppAssets.onboardDelivery,
    ),
  ];

  void _finish() {
    context.read<AppState>().completeOnboarding();
    AppNav.offAll(context, const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final last = _index == _pages.length - 1;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemBuilder: (_, index) => _pages[index],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _index == i ? 22 : 8,
                    decoration: BoxDecoration(
                      color: _index == i ? AppColors.primary : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: last ? 'GET STARTED' : 'NEXT',
                onPressed: () {
                  if (last) {
                    _finish();
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
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
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        FoodNetworkImage(url: image, height: 240, radius: 24),
        const SizedBox(height: 32),
        Icon(icon, color: AppColors.primary, size: 36),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, color: Colors.grey, height: 1.4),
        ),
      ],
    );
  }
}
