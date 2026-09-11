import 'package:flutter/material.dart';
import 'package:food_application/core/app_theme.dart';
import 'package:food_application/screens/spalsh%20screen/spalsh_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FoodieApp());
}

class FoodieApp extends StatelessWidget {
  const FoodieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..hydrate(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Foodie',
        theme: AppTheme.light(),
        home: const SpalshScreen(),
      ),
    );
  }
}
