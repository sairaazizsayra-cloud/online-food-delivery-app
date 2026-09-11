import 'package:flutter/material.dart';
import 'package:food_application/screens/resturent%20view%201%20screen/resturent_view_1_screen.dart';

class ResturentView2Screen extends StatelessWidget {
  const ResturentView2Screen({super.key, this.restaurantId = 'r1'});

  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    return ResturentView1Screen(restaurantId: restaurantId);
  }
}
