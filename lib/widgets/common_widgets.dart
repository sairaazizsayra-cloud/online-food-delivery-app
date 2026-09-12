import 'package:flutter/material.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/models/models.dart';
import 'package:food_application/state/app_state.dart';
import 'package:provider/provider.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.background = const Color(0xFFECF0F4),
    this.iconColor = AppColors.dark,
    this.size = 45,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color background;
  final Color iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: size * 0.42),
      ),
    );
  }
}

class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key, this.dark = true, this.onTap});

  final bool dark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final count = context.watch<AppState>().cartCount;
    return InkWell(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: dark ? AppColors.dark : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: dark ? Colors.white : AppColors.dark,
            ),
          ),
          if (count > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: 18,
                width: 18,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FoodNetworkImage extends StatelessWidget {
  const FoodNetworkImage({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.radius = 16,
  });

  final String url;
  final double? height;
  final double? width;
  final double radius;

  bool get _isAsset => !url.startsWith('http://') && !url.startsWith('https://');

  Widget _fallback() {
    return Container(
      height: height,
      width: width,
      color: const Color(0xFFFFEDE4),
      alignment: Alignment.center,
      child: const Icon(Icons.fastfood, color: AppColors.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = _isAsset
        ? Image.asset(
            url,
            height: height,
            width: width ?? double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallback(),
          )
        : Image.network(
            url,
            height: height,
            width: width ?? double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallback(),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                height: height,
                width: width,
                color: const Color(0xFFFFEDE4),
                alignment: Alignment.center,
                child: const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(height: height, width: width, child: image),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.onTap,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed ?? onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}

class AppField extends StatelessWidget {
  const AppField({
    super.key,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onSubmitted,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFD0D9E1)),
        filled: true,
        fillColor: AppColors.field,
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            color: Colors.black,
            child: Column(
              children: [
                const SizedBox(height: 90),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: child,
            ),
          ),
          if (Navigator.canPop(context))
            Positioned(
              top: MediaQuery.paddingOf(context).top + 18,
              left: 20,
              child: CircleIconButton(
                icon: Icons.arrow_back_ios_new,
                size: 45,
                background: Colors.white,
                iconColor: AppColors.dark,
                onTap: () => Navigator.pop(context),
              ),
            ),
        ],
      ),
    );
  }
}

class MoneyText extends StatelessWidget {
  const MoneyText(this.value, {super.key, this.style});

  final double value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text('\$${value.toStringAsFixed(2)}', style: style);
  }
}

class RestaurantMetaRow extends StatelessWidget {
  const RestaurantMetaRow({
    super.key,
    required this.rating,
    required this.freeDelivery,
    required this.minutes,
  });

  final double rating;
  final bool freeDelivery;
  final int minutes;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: AppColors.primary, size: 18),
        const SizedBox(width: 4),
        Text(rating.toStringAsFixed(1)),
        const SizedBox(width: 14),
        const Icon(Icons.local_shipping, color: AppColors.primary, size: 18),
        const SizedBox(width: 4),
        Text(freeDelivery ? 'Free' : 'Paid'),
        const SizedBox(width: 14),
        const Icon(Icons.access_time, color: AppColors.primary, size: 18),
        const SizedBox(width: 4),
        Text('$minutes min'),
      ],
    );
  }
}

const foodCardGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  childAspectRatio: 0.72,
);

class FoodCard extends StatelessWidget {
  const FoodCard({
    super.key,
    required this.food,
    required this.onTap,
    required this.onAdd,
  });

  final FoodItem food;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Color(0x22000000), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return FoodNetworkImage(
                      url: food.imageUrl,
                      height: constraints.maxHeight,
                      radius: 8,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                food.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  height: 1.2,
                ),
              ),
              Text(
                food.restaurantName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '\$${food.price.toStringAsFixed(0)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: onAdd,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 14),
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

void showAppSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class OptionalBackButton extends StatelessWidget {
  const OptionalBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Navigator.canPop(context)) {
      return const SizedBox(width: 40, height: 40);
    }
    return CircleIconButton(
      icon: Icons.arrow_back_ios_new,
      size: 40,
      onTap: () => Navigator.pop(context),
    );
  }
}
