import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostelmate/core/models/contact_details_model.dart';
import 'package:hostelmate/core/models/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    try {
      if (!email.endsWith('@klu.ac.in')) {
        throw FirebaseAuthException(
          code: 'invalid-email-domain',
          message: 'Please use your KLU email address (@klu.ac.in)',
        );
      }
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String department,
    required int year,
    required int age,
    required String hostelType,
    required String phoneNumber,
    required String parentName,
    required String parentRelation,
    required String parentPhone,
    String? bloodGroup,
    required String address,
  }) async {
    try {
      if (!email.endsWith('@klu.ac.in')) {
        throw FirebaseAuthException(
          code: 'invalid-email-domain',
          message: 'Please use your KLU email address (@klu.ac.in)',
        );
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final contactDetails = ContactDetails(
        phoneNumber: phoneNumber,
        email: email,
      );

      final parentDetails = ParentDetails(
        name: parentName,
        relation: parentRelation,
        contactDetails: ContactDetails(
          phoneNumber: parentPhone,
        ),
      );

      final permanentAddress = LocalAddress(
        street: address,
        city: 'Guntur', // Default values for KLU
        state: 'Andhra Pradesh',
        pincode: '522502',
      );

      // Create user profile in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        'department': department,
        'year': year,
        'age': age,
        'hostelType': hostelType,
        'role': 'student',
        'contactDetails': contactDetails.toMap(),
        'parentDetails': parentDetails.toMap(),
        'permanentAddress': permanentAddress.toMap(),
        'bloodGroup': bloodGroup,
        'createdAt': DateTime.now().toIso8601String(),
      });

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to get user data
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUser == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (!doc.exists) return null;

      return UserModel.fromMap(doc.data()!..['uid'] = doc.id);
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }
} 