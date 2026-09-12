import 'package:firebase_auth/firebase_auth.dart';
// RecaptchaVerifier needs the platform auth instance on web only.
// ignore: depend_on_referenced_packages
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:food_application/core/firebase_constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance {
    _googleReady = _prepareGoogleSignIn();
  }

  final FirebaseAuth _auth;
  late final Future<void> _googleReady;
  ConfirmationResult? _webPhoneConfirmation;
  RecaptchaVerifier? _webRecaptcha;

  Future<void> _prepareGoogleSignIn() async {
    if (kIsWeb) {
      return;
    }
    await GoogleSignIn.instance.initialize(
      clientId: defaultTargetPlatform == TargetPlatform.iOS
          ? GoogleAuthConfig.iosClientId
          : null,
      serverClientId: GoogleAuthConfig.webClientId,
    );
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await credential.user?.updateDisplayName(name.trim());
    return credential;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        return _auth.signInWithPopup(GoogleAuthProvider());
      }

      await _googleReady;
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      return _auth.signInWithCredential(
        GoogleAuthProvider.credential(idToken: googleAuth.idToken),
      );
    } on GoogleSignInException catch (error) {
      debugPrint('Google Sign-In cancelled or failed: $error');
      return null;
    } catch (error) {
      debugPrint('Error during Google Sign-In: $error');
      rethrow;
    }
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> sendPhoneCode({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(PhoneAuthCredential credential) onAutoVerified,
    required void Function(String message) onFailed,
  }) async {
    final normalized = normalizePhoneNumber(phoneNumber);
    if (normalized == null) {
      onFailed(AuthCopy.phoneRequired);
      return;
    }

    if (kIsWeb) {
      try {
        final verifier = _createWebRecaptcha();
        _webPhoneConfirmation = await _auth.signInWithPhoneNumber(
          normalized,
          verifier,
        );
        onCodeSent('web');
      } catch (error) {
        _clearWebRecaptcha();
        onFailed(mapAuthError(error));
      }
      return;
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: normalized,
        verificationCompleted: onAutoVerified,
        verificationFailed: (error) => onFailed(mapAuthError(error)),
        codeSent: (verificationId, _) => onCodeSent(verificationId),
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (error) {
      onFailed(mapAuthError(error));
    }
  }

  RecaptchaVerifier _createWebRecaptcha() {
    _clearWebRecaptcha();
    _webRecaptcha = RecaptchaVerifier(
      auth: FirebaseAuthPlatform.instance,
      container: PhoneAuthConfig.recaptchaContainerId,
      size: RecaptchaVerifierSize.compact,
      theme: RecaptchaVerifierTheme.light,
    );
    return _webRecaptcha!;
  }

  void _clearWebRecaptcha() {
    try {
      _webRecaptcha?.clear();
    } catch (error) {
      debugPrint('Error clearing reCAPTCHA: $error');
    }
    _webRecaptcha = null;
  }

  Future<UserCredential> confirmPhoneCode({
    required String verificationId,
    required String smsCode,
  }) async {
    if (kIsWeb) {
      final confirmation = _webPhoneConfirmation;
      if (confirmation == null) {
        throw FirebaseAuthException(
          code: 'missing-verification-id',
          message: 'Request a new phone code first',
        );
      }
      return confirmation.confirm(smsCode.trim());
    }

    return _auth.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode.trim(),
      ),
    );
  }

  Future<UserCredential> signInWithPhoneCredential(
    PhoneAuthCredential credential,
  ) {
    return _auth.signInWithCredential(credential);
  }

  Future<void> updateDisplayName(String name) async {
    await _auth.currentUser?.updateDisplayName(name.trim());
  }

  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleReady;
        await GoogleSignIn.instance.signOut();
      }
      await _auth.signOut();
    } catch (error) {
      debugPrint('Error signing out: $error');
      rethrow;
    }
  }

  static String? normalizePhoneNumber(String raw) {
    var trimmed = raw.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (trimmed.startsWith('00')) {
      trimmed = '+${trimmed.substring(2)}';
    }
    if (trimmed.startsWith('+')) {
      final digits = trimmed.substring(1).replaceAll(RegExp(r'\D'), '');
      if (digits.length >= 10 && digits.length <= 15) {
        return '+$digits';
      }
      return null;
    }

    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11 && digits.startsWith('03')) {
      return '${PhoneAuthConfig.defaultCountryCode}${digits.substring(1)}';
    }
    if (digits.length == 10 && digits.startsWith('3')) {
      return '${PhoneAuthConfig.defaultCountryCode}$digits';
    }
    if (digits.length == 12 && digits.startsWith('92')) {
      return '+$digits';
    }
    if (digits.length == 10) {
      return '+1$digits';
    }
    if (digits.length >= 11 && digits.length <= 15) {
      return '+$digits';
    }
    return null;
  }

  static String mapAuthError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Please enter a valid email address';
        case 'user-disabled':
          return 'This account has been disabled';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Invalid email or password';
        case 'email-already-in-use':
          return 'An account with this email already exists';
        case 'weak-password':
          return 'Password must be at least 6 characters';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later';
        case 'invalid-phone-number':
        case 'missing-phone-number':
          return AuthCopy.phoneRequired;
        case 'invalid-verification-code':
          return 'The SMS code is invalid';
        case 'session-expired':
          return 'The SMS code expired. Request a new one';
        case 'operation-not-allowed':
          return 'This sign-in method is not enabled yet';
        case 'unauthorized-domain':
        case 'auth/unauthorized-domain':
          return AuthCopy.unauthorizedDomain;
        case 'captcha-check-failed':
        case 'invalid-app-credential':
        case 'missing-client-identifier':
          return AuthCopy.phoneCaptchaFailed;
        case 'quota-exceeded':
          return AuthCopy.phoneQuota;
        case 'network-request-failed':
          return 'Network error. Check your connection';
        default:
          return error.message ?? 'Authentication failed';
      }
    }
    return 'Authentication failed';
  }
}
