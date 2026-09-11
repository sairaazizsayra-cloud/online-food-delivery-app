import 'package:flutter/material.dart';
import 'package:food_application/core/app_assets.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/screens/main%20shell/main_shell.dart';
import 'package:food_application/widgets/common_widgets.dart';

class LocationAccessScreen extends StatefulWidget {
  const LocationAccessScreen({super.key});

  @override
  State<LocationAccessScreen> createState() => _LocationAccessScreenState();
}

class _LocationAccessScreenState extends State<LocationAccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const FoodNetworkImage(
                url: AppAssets.locationMap,
                height: 220,
                radius: 80,
              ),
              const SizedBox(height: 36),
              const Text(
                'Find restaurants near you',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'FOODIE WILL ACCESS YOUR LOCATION\nONLY WHILE USING THE APP',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.4),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'ACCESS LOCATION',
                onPressed: () => AppNav.offAll(context, const MainShell()),
              ),
              TextButton(
                onPressed: () => AppNav.offAll(context, const MainShell()),
                child: const Text('Skip for now'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
