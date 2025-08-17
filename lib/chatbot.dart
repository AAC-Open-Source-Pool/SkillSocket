import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotScreen extends StatefulWidget {
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add initial bot welcome message
    _messages.add({
      'text':
          'Hello! I\'m your AI study assistant. How can I help you today?\n\n• Ask me about study topics\n• Get help with homework\n• Learn about new skills\n• Find study strategies',
      'isBot': true,
      'timestamp': DateTime.now(),
    });
  }

  // Fallback responses for when backend is not available
  String _getFallbackResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('hello') ||
        lowerMessage.contains('hi') ||
        lowerMessage.contains('hey')) {
      return 'Hello! I\'m here to help you with your studies. What would you like to learn about today?';
    } else if (lowerMessage.contains('help') ||
        lowerMessage.contains('assistance')) {
      return 'I can help you with:\n• Study strategies and techniques\n• Subject-specific questions\n• Skill development advice\n• Learning resources\n\nWhat specific area would you like help with?';
    } else if (lowerMessage.contains('study') ||
        lowerMessage.contains('learn')) {
      return 'Great! Learning is a wonderful journey. Here are some effective study tips:\n\n• Use active recall techniques\n• Practice spaced repetition\n• Take regular breaks (Pomodoro technique)\n• Create mind maps for complex topics\n\nWhat subject are you studying?';
    } else if (lowerMessage.contains('programming') ||
        lowerMessage.contains('coding') ||
        lowerMessage.contains('flutter') ||
        lowerMessage.contains('dart')) {
      return 'Programming is an excellent skill! For Flutter and Dart:\n\n• Start with basic Dart syntax\n• Practice building simple widgets\n• Learn state management\n• Build projects to solidify concepts\n\nWould you like resources for any specific programming topic?';
    } else if (lowerMessage.contains('math') ||
        lowerMessage.contains('mathematics')) {
      return 'Mathematics builds logical thinking! Some effective strategies:\n\n• Practice problems daily\n• Understand concepts before memorizing formulas\n• Use visual aids and diagrams\n• Work through examples step by step\n\nWhat math topic are you working on?';
    } else if (lowerMessage.contains('time') ||
        lowerMessage.contains('schedule') ||
        lowerMessage.contains('manage')) {
      return 'Time management is crucial for effective learning:\n\n• Create a study schedule\n• Prioritize important topics\n• Use time-blocking techniques\n• Set realistic daily goals\n• Take regular breaks\n\nWould you like help creating a study plan?';
    } else {
      return 'That\'s an interesting question! While I\'d love to provide a detailed response, I recommend:\n\n• Breaking down complex topics into smaller parts\n• Using multiple learning resources\n• Practicing regularly\n• Seeking help from teachers or peers when needed\n\nCould you be more specific about what you\'d like to learn?';
    }
  }

  Future<void> _sendMessageToBot(String message) async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Sending message to bot: $message');
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/chat'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': message,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Parsed response data: $responseData');

        String botReply;
        if (responseData['success'] == true && responseData['reply'] != null) {
          botReply = responseData['reply'];
        } else if (responseData['reply'] != null) {
          botReply = responseData['reply'];
        } else {
          botReply = 'Sorry, I received an empty response. Please try again.';
        }

        setState(() {
          _messages.add({
            'text': botReply,
            'isBot': true,
            'timestamp': DateTime.now(),
          });
        });
      } else {
        final errorData = jsonDecode(response.body);
        print('Error response: $errorData');
        setState(() {
          _messages.add({
            'text':
                'Sorry, I encountered an error: ${errorData['error'] ?? 'Unknown error'}. Please try again.',
            'isBot': true,
            'timestamp': DateTime.now(),
          });
        });
      }
    } catch (error) {
      print('Network error: $error');
      // Use fallback response when backend is not available
      String fallbackReply = _getFallbackResponse(message);
      setState(() {
        _messages.add({
          'text': fallbackReply,
          'isBot': true,
          'timestamp': DateTime.now(),
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({
          'text': text,
          'isBot': false,
          'timestamp': DateTime.now(),
        });
      });
      _controller.clear();

      // Send message to backend AI
      _sendMessageToBot(text);
    }
  }

  void _sendPredefinedMessage(String message) {
    setState(() {
      _messages.add({
        'text': message,
        'isBot': false,
        'timestamp': DateTime.now(),
      });
    });
    _sendMessageToBot(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF56195B),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.smart_toy, color: Color(0xFF56195B)),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Study Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat Area
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                // Show loading indicator at the top (first item when reversed)
                if (_isLoading && index == 0) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF56195B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF56195B),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'AI is thinking...',
                          style: TextStyle(
                            color: Color(0xFF56195B),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Adjust index for actual messages
                final messageIndex = _isLoading ? index - 1 : index;
                final reversedIndex = _messages.length - 1 - messageIndex;
                final message = _messages[reversedIndex];

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: message['isBot']
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (message['isBot']) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFF56195B),
                          child: Icon(Icons.smart_toy,
                              color: Colors.white, size: 16),
                        ),
                        SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: message['isBot']
                                ? Color(0xFF56195B).withOpacity(0.1)
                                : Color(0xFF56195B),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            message['text'],
                            style: TextStyle(
                              color: message['isBot']
                                  ? Colors.black87
                                  : Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      if (!message['isBot']) ...[
                        SizedBox(width: 8),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFF56195B),
                          child:
                              Icon(Icons.person, color: Colors.white, size: 16),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          // Quick action buttons
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                _buildOptionButton(
                  label: "What are trending skills in tech?",
                  onTap: () {
                    _sendPredefinedMessage(
                        "What are the trending skills in technology?");
                  },
                ),
                SizedBox(height: 8),
                _buildOptionButton(
                  label: "Suggest me a skill to learn",
                  onTap: () {
                    _sendPredefinedMessage(
                        "Can you suggest a skill I should learn based on current market trends?");
                  },
                ),
              ],
            ),
          ),

          // Input Area
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Ask me anything...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => handleSend(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _isLoading ? null : handleSend,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _isLoading ? Colors.grey[400] : Color(0xFF56195B),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xFF56195B).withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Color(0xFF56195B).withOpacity(0.3)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF56195B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
