import 'package:flutter/material.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/models/models.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late FilterOptions options;

  @override
  void initState() {
    super.initState();
    options = context.read<AppState>().filter.copy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleIconButton(
                    icon: Icons.close,
                    size: 40,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Filter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Price  \$${options.minPrice.toInt()} - \$${options.maxPrice.toInt()}'),
              RangeSlider(
                values: RangeValues(options.minPrice, options.maxPrice),
                min: 0,
                max: 200,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    options.minPrice = value.start;
                    options.maxPrice = value.end;
                  });
                },
              ),
              Text('Minimum rating  ${options.minRating.toStringAsFixed(1)}'),
              Slider(
                value: options.minRating,
                min: 0,
                max: 5,
                divisions: 10,
                activeColor: AppColors.primary,
                label: options.minRating.toStringAsFixed(1),
                onChanged: (value) => setState(() => options.minRating = value),
              ),
              Text('Max delivery time  ${options.maxDeliveryTime} min'),
              Slider(
                value: options.maxDeliveryTime.toDouble(),
                min: 10,
                max: 60,
                divisions: 10,
                activeColor: AppColors.primary,
                onChanged: (value) =>
                    setState(() => options.maxDeliveryTime = value.round()),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Free delivery only'),
                value: options.offersFreeDelivery,
                activeThumbColor: AppColors.primary,
                onChanged: (value) =>
                    setState(() => options.offersFreeDelivery = value),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<AppState>().resetFilter();
                        Navigator.pop(context);
                      },
                      child: const Text('RESET'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'APPLY',
                      onPressed: () {
                        context.read<AppState>().applyFilter(options);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
