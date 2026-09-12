import 'package:flutter/material.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/screens/login%20screen/login_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, this.email});

  final String? email;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String code = '';
  String? errorText;
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool verified = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void _verify() {
    final error = context.read<AppState>().verifyOtp(code);
    if (error != null) {
      setState(() => errorText = error);
      return;
    }
    setState(() {
      verified = true;
      errorText = null;
    });
  }

  void _resetPassword() {
    final error = context.read<AppState>().resetPassword(
          passwordController.text,
          confirmController.text,
        );
    if (error != null) {
      setState(() => errorText = error);
      return;
    }
    showAppSnack(context, 'Password updated. Please log in.');
    AppNav.offAll(context, const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email?.trim() ?? '';
    return AuthScaffold(
      title: verified ? 'Reset Password' : 'Verification',
      subtitle: verified
          ? 'Enter your new password'
          : email.isEmpty
              ? 'Enter the 4-digit code sent to your email'
              : 'Enter the 4-digit code sent to $email',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!verified) ...[
              const Text('CODE', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              MaterialPinField(
                length: 4,
                keyboardType: TextInputType.number,
                onChanged: (value) => code = value,
                theme: MaterialPinTheme(
                  shape: MaterialPinShape.filled,
                  cellSize: const Size(56, 56),
                  borderRadius: BorderRadius.circular(10),
                  fillColor: AppColors.field,
                  focusedFillColor: Colors.white,
                  focusedBorderColor: AppColors.primary,
                ),
              ),
            ] else ...[
              const Text(
                'PASSWORD',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              AppField(
                controller: passwordController,
                hint: '********',
                obscure: true,
              ),
              const SizedBox(height: 14),
              const Text(
                'RE-TYPE PASSWORD',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              AppField(
                controller: confirmController,
                hint: '********',
                obscure: true,
              ),
            ],
            if (errorText != null) ...[
              const SizedBox(height: 10),
              Text(errorText!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            PrimaryButton(
              label: verified ? 'RESET PASSWORD' : 'VERIFY',
              onPressed: verified ? _resetPassword : _verify,
            ),
          ],
        ),
      ),
    );
  }
}
