import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/screens/forgot%20password%20screen/forgot_password_screen.dart';
import 'package:food_application/screens/location%20access%20screen/location_access_screen.dart';
import 'package:food_application/screens/phone%20login%20screen/phone_login_screen.dart';
import 'package:food_application/screens/sign%20up%20screen/sign_up_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = true;
  bool obscure = true;
  String? errorText;
  bool submitting = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _afterAuth(String? error) async {
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

  Future<void> _login() async {
    setState(() {
      submitting = true;
      errorText = null;
    });
    final error = await context.read<AppState>().login(
          emailController.text,
          passwordController.text,
        );
    await _afterAuth(error);
  }

  Future<void> _google() async {
    setState(() {
      submitting = true;
      errorText = null;
    });
    final error = await context.read<AppState>().loginWithGoogle();
    await _afterAuth(error);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Log In',
      subtitle: 'Please sign in to your existing account',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('EMAIL', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            AppField(
              controller: emailController,
              hint: 'example@gmail.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 18),
            const Text('PASSWORD', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                hintStyle: const TextStyle(color: Color(0xFFD0D9E1)),
                filled: true,
                fillColor: AppColors.field,
                suffixIcon: IconButton(
                  onPressed: () => setState(() => obscure = !obscure),
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (errorText != null) ...[
              const SizedBox(height: 10),
              Text(errorText!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  activeColor: AppColors.primary,
                  onChanged: (value) =>
                      setState(() => rememberMe = value ?? false),
                ),
                const Text(
                  'Remember me',
                  style: TextStyle(color: Color(0xFF7E8A97)),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => AppNav.to(
                    context,
                    ForgotPasswordScreen(email: emailController.text),
                  ),
                  child: const Text(
                    'Forgot password',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              label: submitting ? 'PLEASE WAIT' : 'LOG IN',
              onPressed: submitting ? null : _login,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () => AppNav.to(context, const SignUpScreen()),
                  child: const Text(
                    'SIGN UP',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Center(child: Text('or')),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'google',
                  backgroundColor: const Color(0xFFDB4437),
                  onPressed: submitting ? null : _google,
                  child: const FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.white,
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'phone',
                  backgroundColor: AppColors.primary,
                  onPressed: submitting
                      ? null
                      : () => AppNav.to(context, const PhoneLoginScreen()),
                  child: const FaIcon(
                    FontAwesomeIcons.phone,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
