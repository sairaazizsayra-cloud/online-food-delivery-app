import 'package:flutter/material.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/data/catalog.dart';
import 'package:food_application/screens/my%20card%20screen/my_card_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class FoodDetailSecreen1 extends StatefulWidget {
  const FoodDetailSecreen1({super.key, this.foodId = 'f7'});

  final String foodId;

  @override
  State<FoodDetailSecreen1> createState() => _FoodDetailSecreen1State();
}

class _FoodDetailSecreen1State extends State<FoodDetailSecreen1> {
  String size = '14';
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final food = Catalog.foodById(widget.foodId) ?? Catalog.foods.first;
    final state = context.watch<AppState>();
    final favorite = state.isFavorite(food.id);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      CircleIconButton(
                        icon: Icons.arrow_back_ios_new,
                        size: 40,
                        onTap: () {
                          if (Navigator.canPop(context)) Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Details',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      CircleIconButton(
                        icon: favorite ? Icons.favorite : Icons.favorite_border,
                        iconColor: favorite ? Colors.red : AppColors.dark,
                        size: 40,
                        onTap: () => state.toggleFavorite(food.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FoodNetworkImage(url: food.imageUrl, height: 210, radius: 24),
                  const SizedBox(height: 16),
                  Text(
                    food.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(food.restaurantName, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  Text(food.description, style: const TextStyle(color: Color(0xFFA0A5BA))),
                  const SizedBox(height: 16),
                  RestaurantMetaRow(
                    rating: food.rating,
                    freeDelivery: food.freeDelivery,
                    minutes: food.deliveryTime,
                  ),
                  const SizedBox(height: 22),
                  const Text('SIZE', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: ['10', '14', '16'].map((value) {
                      final selected = size == value;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => setState(() => size = value),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor:
                                selected ? AppColors.primary : AppColors.field,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selected ? Colors.white : AppColors.dark,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 22),
                  const Text('QUANTITY', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleIconButton(
                        icon: Icons.remove,
                        size: 40,
                        onTap: () {
                          if (quantity > 1) setState(() => quantity--);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      CircleIconButton(
                        icon: Icons.add,
                        size: 40,
                        background: AppColors.primary,
                        iconColor: Colors.white,
                        onTap: () => setState(() => quantity++),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: PrimaryButton(
                label: 'ADD TO CART  •  \$${(food.price * quantity).toStringAsFixed(0)}',
                onPressed: () {
                  state.addToCart(food, size: size, quantity: quantity);
                  showAppSnack(context, '${food.name} added to cart');
                  AppNav.to(context, const MyCardScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
