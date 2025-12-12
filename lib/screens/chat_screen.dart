import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final AiService _aiService = AiService();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: 'I am your anonymous support companion. How are you feeling today?',
      isUser: false,
    ),
  ];
  final List<String> _crisisKeywords = const [
    'want to die',
    'kill myself',
    'end my life',
    'suicide',
    'hurt myself',
  ];
  bool _isWaiting = false;
  Future<bool>? _aiStatus;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _refreshStatus();
  }

  void _refreshStatus() {
    setState(() {
      _aiStatus = _aiService.checkAvailability();
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (_isCrisis(text)) {
      _showCrisisDialog();
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isWaiting = true;
      _controller.clear();
    });

    _aiService.getSupportiveReply(text).then((reply) {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(text: reply, isUser: false));
        _isWaiting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF6FFF8), Color(0xFFE8F5E9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: [
                FutureBuilder<bool>(
                  future: _aiStatus,
                  builder: (context, snapshot) {
                    final connected = snapshot.data == true;
                    final loading = snapshot.connectionState == ConnectionState.waiting;
                    return Chip(
                      avatar: loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              connected ? Icons.check_circle : Icons.error_outline,
                              color: connected ? Colors.green : Colors.redAccent,
                            ),
                      label: Text(
                        connected ? 'AI online' : 'Offline (fallback)',
                        style: TextStyle(
                          color: connected ? Colors.green[900] : Colors.red[900],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: connected ? const Color(0xFFDFF7E3) : const Color(0xFFFFE6E6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    );
                  },
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Refresh status',
                  icon: const Icon(Icons.refresh),
                  onPressed: _refreshStatus,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _messages.length + (_isWaiting ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isWaiting && index == _messages.length) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 10),
                            Text('Thinking...'),
                          ],
                        ),
                      ),
                    );
                  }
                  final message = _messages[index];
                  return Align(
                    alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: message.isUser ? const Color(0xFF4CAF50) : const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (message.isUser)
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: message.isUser ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 540),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Share what’s on your mind...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          minLines: 1,
                          maxLines: 1,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                          minimumSize: const Size(44, 44),
                        ),
                        onPressed: _sendMessage,
                        child: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  const _ChatMessage({required this.text, required this.isUser});
}

extension on _ChatScreenState {
  bool _isCrisis(String text) {
    final lower = text.toLowerCase();
    return _crisisKeywords.any((keyword) => lower.contains(keyword));
  }

  void _showCrisisDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('You are important. Please get help now.'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'This app cannot help in emergencies.\n'
                'Please contact local emergency services or a mental health helpline immediately.',
              ),
              SizedBox(height: 12),
              Text('Emergency (IN): 112'),
              Text('Mental Health (IN): 1800-599-0019 (KIRAN)'),
              Text('Mental Health (IN): 14416 (Tele-MANAS)'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
