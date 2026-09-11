import 'package:flutter/material.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/screens/verification%20screen/verification_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  String? errorText;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _send() {
    final error = context.read<AppState>().requestReset(emailController.text);
    if (error != null) {
      setState(() => errorText = error);
      return;
    }
    AppNav.to(context, const VerificationScreen());
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Forgot Password',
      subtitle: 'Enter your email to receive a reset code',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('EMAIL', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            AppField(
              controller: emailController,
              hint: 'demo@foodie.com',
              keyboardType: TextInputType.emailAddress,
            ),
            if (errorText != null) ...[
              const SizedBox(height: 10),
              Text(errorText!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            PrimaryButton(label: 'SEND CODE', onPressed: _send),
            const SizedBox(height: 12),
            const Text(
              'Demo code: 1234',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
