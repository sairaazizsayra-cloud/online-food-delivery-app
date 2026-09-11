import 'package:flutter/material.dart';
import 'package:food_application/models/models.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvcController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    expiryController.dispose();
    cvcController.dispose();
    super.dispose();
  }

  void _save() {
    if (nameController.text.trim().isEmpty ||
        numberController.text.replaceAll(' ', '').length < 12) {
      showAppSnack(context, 'Enter a valid card holder and number');
      return;
    }
    context.read<AppState>().addCard(
          PaymentCardModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            holderName: nameController.text.trim(),
            number: numberController.text.trim(),
            expiry: expiryController.text.trim(),
            cvc: cvcController.text.trim(),
          ),
        );
    showAppSnack(context, 'Card saved');
    Navigator.pop(context);
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
                  const SizedBox(width: 10),
                  const Text('Add Card', style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 24),
              const Text('CARD HOLDER NAME'),
              const SizedBox(height: 8),
              AppField(controller: nameController, hint: 'Vishal Khadok'),
              const SizedBox(height: 16),
              const Text('CARD NUMBER'),
              const SizedBox(height: 8),
              AppField(
                controller: numberController,
                hint: '4242 4242 4242 4242',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('EXPIRE DATE'),
                        const SizedBox(height: 8),
                        AppField(controller: expiryController, hint: 'mm/yyyy'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('CVC'),
                        const SizedBox(height: 8),
                        AppField(
                          controller: cvcController,
                          hint: '***',
                          obscure: true,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              PrimaryButton(label: 'ADD CARD', onPressed: _save),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
