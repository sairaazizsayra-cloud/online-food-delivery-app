import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_application/core/app_colors.dart';

void main() {
  test('app primary color stays Foodie orange', () {
    expect(AppColors.primary, const Color(0xFFFF7622));
  });
}
