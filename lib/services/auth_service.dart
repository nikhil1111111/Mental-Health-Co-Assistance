import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

bool isFirebaseSupported = kIsWeb || defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

class AuthService {
  final FirebaseAuth? _auth = isFirebaseSupported ? FirebaseAuth.instance : null;

  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _auth!.authStateChanges();

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'No user returned from FirebaseAuth',
        );
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  // Send OTP to phone number
  Future<void> verifyPhoneNumber(String phoneNumber, Function(String) onCodeSent) async {
    await _auth!.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth!.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e;
      },
      codeSent: (String verificationId, int? resendToken) {
        if (verificationId == null) {
          throw FirebaseAuthException(
            code: 'verification-id-null',
            message: 'Verification ID is null',
          );
        }
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Verify OTP
  Future<UserCredential?> verifyOTP(String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    try {
      UserCredential userCredential = await _auth!.signInWithCredential(credential);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth!.signOut();
  }

  // Get current user
  User? get currentUser => _auth!.currentUser;
}
