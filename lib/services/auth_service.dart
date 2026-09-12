import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:food_application/core/firebase_constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance {
    if (!kIsWeb) {
      GoogleSignIn.instance.initialize();
    }
  }

  final FirebaseAuth _auth;
  ConfirmationResult? _webPhoneConfirmation;

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
        _webPhoneConfirmation = await _auth.signInWithPhoneNumber(normalized);
        onCodeSent('web');
      } on FirebaseAuthException catch (error) {
        onFailed(mapAuthError(error));
      }
      return;
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: normalized,
      verificationCompleted: onAutoVerified,
      verificationFailed: (error) => onFailed(mapAuthError(error)),
      codeSent: (verificationId, _) => onCodeSent(verificationId),
      codeAutoRetrievalTimeout: (_) {},
    );
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
        await GoogleSignIn.instance.signOut();
      }
      await _auth.signOut();
    } catch (error) {
      debugPrint('Error signing out: $error');
      rethrow;
    }
  }

  static String? normalizePhoneNumber(String raw) {
    final trimmed = raw.trim().replaceAll(' ', '');
    if (trimmed.startsWith('+') && trimmed.length >= 10) {
      return trimmed;
    }
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) {
      return '+1$digits';
    }
    if (digits.length >= 11) {
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
          return AuthCopy.phoneRequired;
        case 'invalid-verification-code':
          return 'The SMS code is invalid';
        case 'session-expired':
          return 'The SMS code expired. Request a new one';
        case 'operation-not-allowed':
          return 'This sign-in method is not enabled yet';
        case 'network-request-failed':
          return 'Network error. Check your connection';
        default:
          return error.message ?? 'Authentication failed';
      }
    }
    return 'Authentication failed';
  }
}
