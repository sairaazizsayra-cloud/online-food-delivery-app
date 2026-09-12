import 'package:flutter/material.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/core/firebase_constants.dart';
import 'package:food_application/screens/verification%20screen/verification_screen.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.email});

  final String? email;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController emailController;
  String? errorText;
  bool submitting = false;
  bool emailSent = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.email?.trim() ?? '');
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (submitting) {
      return;
    }
    setState(() {
      submitting = true;
      errorText = null;
    });
    final error = await context.read<AppState>().requestReset(
          emailController.text,
        );
    if (!mounted) {
      return;
    }
    setState(() => submitting = false);
    if (error != null) {
      setState(() => errorText = error);
      return;
    }
    AppNav.to(
      context,
      VerificationScreen(email: emailController.text.trim()),
    );
  }

  void _backToLogin() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: emailSent ? 'Check Email' : 'Forgot Password',
      subtitle: emailSent
          ? 'We sent a reset link to your email'
          : AuthCopy.resetEmailHint,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!emailSent) ...[
              const Text('EMAIL', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              AppField(
                controller: emailController,
                hint: 'example@gmail.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.email],
                maxLength: AppFieldLimits.emailMax,
                onSubmitted: submitting ? null : (_) => _send(),
              ),
              if (errorText != null) ...[
                const SizedBox(height: 10),
                Text(errorText!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              PrimaryButton(
                label: submitting ? 'PLEASE WAIT' : 'SEND CODE',
                onPressed: submitting ? null : _send,
              ),
              Center(
                child: TextButton(
                  onPressed: _backToLogin,
                  child: const Text('BACK TO LOG IN'),
                ),
              ),
            ] else ...[
              const Center(
                child: Icon(
                  Icons.mark_email_read_outlined,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AuthCopy.resetEmailSent,
                style: const TextStyle(
                  color: Color(0xFF7E8A97),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                emailController.text.trim(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (errorText != null) ...[
                const SizedBox(height: 10),
                Text(errorText!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'BACK TO LOG IN',
                onPressed: _backToLogin,
              ),
              Center(
                child: TextButton(
                  onPressed: submitting
                      ? null
                      : () => setState(() => emailSent = false),
                  child: const Text('RESEND CODE'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
