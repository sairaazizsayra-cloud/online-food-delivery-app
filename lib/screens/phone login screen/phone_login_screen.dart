import 'package:flutter/material.dart';
import 'package:food_application/core/app_colors.dart';
import 'package:food_application/core/app_nav.dart';
import 'package:food_application/core/firebase_constants.dart';
import 'package:food_application/screens/location%20access%20screen/location_access_screen.dart';
import 'package:food_application/services/auth_service.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final phoneController = TextEditingController();
  String verificationId = '';
  String code = '';
  String? errorText;
  bool codeSent = false;
  bool submitting = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    setState(() {
      submitting = true;
      errorText = null;
    });
    var sent = false;
    try {
      await context.read<AppState>().sendPhoneCode(
            phoneNumber: phoneController.text,
            onCodeSent: (id) {
              sent = true;
              if (!mounted) {
                return;
              }
              setState(() {
                verificationId = id;
                codeSent = true;
                submitting = false;
              });
            },
            onFailed: (message) {
              if (!mounted) {
                return;
              }
              setState(() {
                errorText = message;
                submitting = false;
              });
            },
          );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        errorText = AuthService.mapAuthError(error);
        submitting = false;
      });
      return;
    }
    if (!mounted) {
      return;
    }
    if (context.read<AppState>().isLoggedIn) {
      AppNav.offAll(context, const LocationAccessScreen());
      return;
    }
    if (!sent && !codeSent && submitting) {
      setState(() => submitting = false);
    }
  }

  Future<void> _confirm() async {
    setState(() {
      submitting = true;
      errorText = null;
    });
    final error = await context.read<AppState>().confirmPhoneCode(
          verificationId: verificationId,
          smsCode: code,
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
      title: 'Phone Login',
      subtitle: codeSent
          ? 'Enter the 6-digit SMS code'
          : 'Sign in with your mobile number',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!codeSent) ...[
              const Text(
                'PHONE NUMBER',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              AppField(
                controller: phoneController,
                hint: '${PhoneAuthConfig.defaultCountryCode} 300 1234567',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              const Text(
                'Pakistan numbers like 0300 1234567 work. Complete the security check if it appears.',
                style: TextStyle(color: Color(0xFF7E8A97), fontSize: 12),
              ),
            ] else ...[
              const Text('CODE', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              MaterialPinField(
                length: 6,
                keyboardType: TextInputType.number,
                onChanged: (value) => code = value,
                theme: MaterialPinTheme(
                  shape: MaterialPinShape.filled,
                  cellSize: const Size(46, 56),
                  borderRadius: BorderRadius.circular(10),
                  fillColor: AppColors.field,
                  focusedFillColor: Colors.white,
                  focusedBorderColor: AppColors.primary,
                ),
              ),
            ],
            if (errorText != null) ...[
              const SizedBox(height: 10),
              Text(errorText!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            PrimaryButton(
              label: submitting
                  ? 'PLEASE WAIT'
                  : codeSent
                      ? 'VERIFY CODE'
                      : 'SEND CODE',
              onPressed: submitting
                  ? null
                  : codeSent
                      ? _confirm
                      : _sendCode,
            ),
          ],
        ),
      ),
    );
  }
}
