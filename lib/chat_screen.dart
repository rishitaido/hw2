import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../auth_service.dart';
import '../firestore_service.dart';
import '../message_model.dart';
import '../user_model.dart';

/// Chat screen for a specific message board
/// Shows all messages in real-time
class ChatScreen extends StatefulWidget {
  final String boardId;
  final String boardName;

  const ChatScreen({
    super.key,
    required this.boardId,
    required this.boardName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _messageController = TextEditingController();
  
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      final user = await _authService.getUserData(uid);
      setState(() => _currentUser = user);
    }
  }

  /// Send a message to the board
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    if (_currentUser == null) return;

    await _firestoreService.sendMessage(
      boardId: widget.boardId,
      userId: _currentUser!.uid,
      username: _currentUser!.fullName,
      message: _messageController.text.trim(),
    );

    // Clear the input field
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardName),
      ),
      body: Column(
        children: [
          // Messages list - StreamBuilder for real-time updates
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              // This stream continuously listens for new messages
              stream: _firestoreService.getMessages(widget.boardId),
              builder: (context, snapshot) {
                // Loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error state
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // No messages yet
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Start the conversation!'),
                  );
                }

                // Display messages
                final messages = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isCurrentUser = message.userId == _currentUser?.uid;

                    return _buildMessageTile(message, isCurrentUser);
                  },
                );
              },
            ),
          ),
          
          // Message input area
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                // Text input field
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    // Send on enter key
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Send button
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual message tile
  Widget _buildMessageTile(MessageModel message, bool isCurrentUser) {
    final dateFormat = DateFormat('MMM d, y • h:mm a');
    
    return Align(
      // Align current user's messages to the right, others to the left
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username (only show for other users)
            if (!isCurrentUser)
              Text(
                message.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            
            // Message text
            Text(
              message.message,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            
            // Timestamp
            Text(
              dateFormat.format(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}