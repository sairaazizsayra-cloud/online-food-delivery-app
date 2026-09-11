import 'package:flutter/material.dart';
import 'package:food_application/screens/food%20detail%201%20screen/food_detail_secreen1.dart';

class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key, this.foodId = 'f1'});

  final String foodId;

  @override
  Widget build(BuildContext context) {
    return FoodDetailSecreen1(foodId: foodId);
  }
}
