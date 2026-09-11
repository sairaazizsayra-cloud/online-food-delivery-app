import 'package:flutter/material.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/models/models.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final addressController = TextEditingController();
  final streetController = TextEditingController();
  final postController = TextEditingController();
  final apartmentController = TextEditingController();
  final labelController = TextEditingController(text: 'Home');

  @override
  void dispose() {
    addressController.dispose();
    streetController.dispose();
    postController.dispose();
    apartmentController.dispose();
    labelController.dispose();
    super.dispose();
  }

  void _save() {
    if (addressController.text.trim().isEmpty) {
      showAppSnack(context, 'Please enter an address');
      return;
    }
    context.read<AppState>().addAddress(
          AddressModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            label: labelController.text.trim().isEmpty
                ? 'Home'
                : labelController.text.trim(),
            fullAddress: addressController.text.trim(),
            street: streetController.text.trim(),
            postCode: postController.text.trim(),
            apartment: apartmentController.text.trim(),
          ),
        );
    showAppSnack(context, 'Address saved');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 180,
              color: const Color(0xFFCFD9E2),
              child: Stack(
                children: [
                  Positioned(
                    left: 16,
                    top: 16,
                    child: CircleIconButton(
                      icon: Icons.arrow_back_ios_new,
                      background: const Color(0xFF292D39),
                      iconColor: Colors.white,
                      size: 36,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const Center(
                    child: Icon(Icons.location_on, color: AppColors.primary, size: 48),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SAVED ADDRESSES', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...state.addresses.map(
                    (address) => ListTile(
                      leading: Icon(
                        state.selectedAddressId == address.id
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: AppColors.primary,
                      ),
                      title: Text(address.label),
                      subtitle: Text(address.fullAddress),
                      onTap: () => state.selectAddress(address.id),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('LABEL'),
                  const SizedBox(height: 6),
                  AppField(controller: labelController, hint: 'Home / Office'),
                  const SizedBox(height: 12),
                  const Text('ADDRESS'),
                  const SizedBox(height: 6),
                  AppField(
                    controller: addressController,
                    hint: '3235 Royal Ln. Mesa, New Jersey 34567',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Street'),
                            const SizedBox(height: 6),
                            AppField(controller: streetController, hint: 'Hason Nagar'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Post code'),
                            const SizedBox(height: 6),
                            AppField(controller: postController, hint: '34567'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Apartment'),
                  const SizedBox(height: 6),
                  AppField(controller: apartmentController, hint: '345'),
                  const SizedBox(height: 20),
                  PrimaryButton(label: 'SAVE ADDRESS', onPressed: _save),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
