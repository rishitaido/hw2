import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a single message in a message board
class MessageModel {
  final String id;
  final String userId;
  final String username;
  final String message;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.message,
    required this.timestamp,
  });

  /// Convert to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  /// Create MessageModel from Firestore document
  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      username: data['username'] ?? 'Unknown',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}