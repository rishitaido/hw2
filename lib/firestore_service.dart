import 'package:cloud_firestore/cloud_firestore.dart';
import '../message_model.dart';

/// Handles all Firestore database operations for messages
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get a stream of messages for a specific board
  /// Stream = real-time updates! When someone posts, you see it immediately
  /// orderBy timestamp = newest messages can be at top or bottom based on descending parameter
  Stream<List<MessageModel>> getMessages(String boardId) {
    return _firestore
        .collection('boards')
        .doc(boardId)
        .collection('messages')
        .orderBy('timestamp', descending: false) // oldest first
        .snapshots()
        .map((snapshot) {
      // Convert each Firestore document to a MessageModel
      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Send a new message to a board
  /// Auto-generates a unique message ID using .add()
  Future<void> sendMessage({
    required String boardId,
    required String userId,
    required String username,
    required String message,
  }) async {
    try {
      MessageModel newMessage = MessageModel(
        id: '', // Firestore will generate this
        userId: userId,
        username: username,
        message: message,
        timestamp: DateTime.now(),
      );

      // Add to the messages subcollection of the specified board
      await _firestore
          .collection('boards')
          .doc(boardId)
          .collection('messages')
          .add(newMessage.toMap());
    } catch (e) {
      print('Send message error: $e');
    }
  }

  /// Initialize default message boards
  /// This creates the boards shown on the home screen
  /// Only needs to be run once (you could also create boards manually in Firebase Console)
  Future<void> initializeBoards() async {
    try {
      final boards = [
        {'id': 'games', 'name': 'Games'},
        {'id': 'business', 'name': 'Business'},
        {'id': 'public_health', 'name': 'Public Health'},
        {'id': 'study', 'name': 'Study'},
      ];

      for (var board in boards) {
        // Check if board already exists
        final doc = await _firestore.collection('boards').doc(board['id']).get();
        if (!doc.exists) {
          await _firestore.collection('boards').doc(board['id']).set({
            'name': board['name'],
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      print('Initialize boards error: $e');
    }
  }
}