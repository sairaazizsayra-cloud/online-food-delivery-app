import 'package:flutter/material.dart';
import 'package:food_application/core/app_assets.dart';
import 'package:food_application/core/app_colors.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({super.key});

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  bool muted = false;
  bool speaker = true;
  String status = 'Connecting...';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => status = 'Call in progress');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF536B80),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage(AppAssets.onboardDelivery),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Robert Fox',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(status, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.chip,
                        child: IconButton(
                          onPressed: () => setState(() => muted = !muted),
                          icon: Icon(muted ? Icons.mic_off : Icons.mic),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 68,
                          width: 68,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFFFE6DA), width: 8),
                          ),
                          child: const Icon(Icons.call_end, color: Colors.white),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.chip,
                        child: IconButton(
                          onPressed: () => setState(() => speaker = !speaker),
                          icon: Icon(speaker ? Icons.volume_up : Icons.volume_off),
                        ),
                      ),
                    ],
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
