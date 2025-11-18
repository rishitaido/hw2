import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user_model.dart';

/// Handles all authentication operations
/// This separates business logic from UI code (good practice!)
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current user stream
  /// Stream = continuously updates when auth state changes
  /// This allows the app to automatically respond to login/logout
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Register a new user with email and password
  /// Returns the created UserModel or null if registration fails
  Future<UserModel?> registerWithEmailPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      // Create the user in Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user == null) return null;

      // Create a UserModel with the new user's data
      UserModel newUser = UserModel(
        uid: user.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        role: 'user', // Default role
        registrationDate: DateTime.now(),
      );

      // Store user data in Firestore
      // This creates a document with the user's UID as the document ID
      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

      return newUser;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  /// Sign in with email and password
  /// Returns the User object or null if login fails
  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  /// Get user data from Firestore
  /// This fetches additional user information beyond what Auth provides
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      
      if (!doc.exists) return null;
      
      return UserModel.fromFirestore(uid, doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Get user data error: $e');
      return null;
    }
  }

  /// Update user profile information
  Future<bool> updateUserProfile({
    required String uid,
    required String firstName,
    required String lastName,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'firstName': firstName,
        'lastName': lastName,
      });
      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }
}