import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final DateTime registrationDate;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.registrationDate,
  });

  /// Get the user's full name
  String get fullName => '$firstName $lastName';

  /// Convert UserModel to a Map for storing in Firestore
  /// Firestore stores data as key-value pairs (Maps)
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'registrationDate': Timestamp.fromDate(registrationDate),
    };
  }

  
  factory UserModel.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      registrationDate: (data['registrationDate'] as Timestamp).toDate(),
    );
  }
}