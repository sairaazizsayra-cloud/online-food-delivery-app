import 'package:flutter/material.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/screens/location%20access%20screen/location_access_screen.dart';
import 'package:food_application/screens/login%20screen/login_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  String? errorText;
  bool submitting = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    setState(() {
      submitting = true;
      errorText = null;
    });
    final error = await context.read<AppState>().register(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          confirmPassword: confirmController.text,
        );
    if (!mounted) {
      return;
    }
    if (error != null) {
      setState(() {
        errorText = error;
        submitting = false;
      });
      return;
    }
    AppNav.offAll(context, const LocationAccessScreen());
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Sign Up',
      subtitle: 'Please sign up to get started',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('NAME', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            AppField(controller: nameController, hint: 'John Doe'),
            const SizedBox(height: 14),
            const Text('EMAIL', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            AppField(
              controller: emailController,
              hint: 'example@gmail.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
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
            if (errorText != null) ...[
              const SizedBox(height: 10),
              Text(errorText!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 20),
            PrimaryButton(
              label: submitting ? 'PLEASE WAIT' : 'SIGN UP',
              onPressed: submitting ? null : _signUp,
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => AppNav.to(context, const LoginScreen()),
                child: const Text('Already have an account? LOG IN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
