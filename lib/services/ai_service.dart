import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

// Set these via --dart-define when running the app to enable real cloud responses.
const String kOpenAiApiKey = String.fromEnvironment('OPENAI_API_KEY');
const String kOpenAiModel = String.fromEnvironment('OPENAI_MODEL', defaultValue: 'gpt-3.5-turbo');
const String kOpenAiBaseUrl =
    String.fromEnvironment('OPENAI_BASE_URL', defaultValue: 'https://api.openai.com/v1/chat/completions');

class AiService {
  final Uri _ollamaEndpoint = Uri.parse('http://localhost:11434/api/chat');
  final String _ollamaModel;

  AiService({String model = 'llama3.2'}) : _ollamaModel = model;

  Future<String> getSupportiveReply(String userText) async {
    // Prefer OpenAI if an API key is provided at build/run time.
    if (kOpenAiApiKey.isNotEmpty) {
      final openAi = await _requestOpenAi(userText);
      if (openAi != null && openAi.trim().isNotEmpty) return openAi.trim();
    }

    // Try local Ollama endpoint if available.
    final ollama = await _requestOllama(userText);
    if (ollama != null && ollama.trim().isNotEmpty) return ollama.trim();

    // Fallback canned reply.
    await Future.delayed(const Duration(milliseconds: 500));
    return _fallbackResponse();
  }

  /// Lightweight availability check. Returns true if either OpenAI (when keyed) or local Ollama responds.
  Future<bool> checkAvailability() async {
    if (kOpenAiApiKey.isNotEmpty) {
      final ok = await _pingOpenAi();
      if (ok) return true;
    }
    final ollamaOk = await _pingOllama();
    return ollamaOk;
  }

  Future<String?> _requestOpenAi(String userText) async {
    try {
      final response = await http
          .post(
            Uri.parse(kOpenAiBaseUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $kOpenAiApiKey',
            },
            body: jsonEncode({
              'model': kOpenAiModel,
              'messages': [
                {
                  'role': 'system',
                  'content':
                      'You are a supportive, non-clinical emotional support companion. Be brief, empathetic, and encourage seeking human/professional help for serious concerns. Never provide medical advice.',
                },
                {'role': 'user', 'content': userText},
              ],
              'temperature': 0.7,
              'max_tokens': 200,
            }),
          )
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = data['choices'];
        if (choices is List && choices.isNotEmpty) {
          final message = (choices.first as Map<String, dynamic>)['message'] as Map<String, dynamic>?;
          final content = message?['content'] as String?;
          return content;
        }
      }
    } catch (_) {
      // Ignore and fall back.
    }
    return null;
  }

  Future<bool> _pingOpenAi() async {
    try {
      final response = await http
          .post(
            Uri.parse(kOpenAiBaseUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $kOpenAiApiKey',
            },
            body: jsonEncode({
              'model': kOpenAiModel,
              'messages': const [
                {'role': 'user', 'content': 'ping'},
              ],
              'max_tokens': 1,
            }),
          )
          .timeout(const Duration(seconds: 8));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _pingOllama() async {
    try {
      final response = await http
          .get(_ollamaEndpoint.replace(path: '/api/tags'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<String?> _requestOllama(String userText) async {
    try {
      final response = await http
          .post(
            _ollamaEndpoint,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'model': _ollamaModel,
              'messages': [
                {
                  'role': 'system',
                  'content':
                      'You are a supportive, non-clinical emotional support companion. '
                      'You do not diagnose or prescribe. Be brief, empathetic, and encourage seeking human/professional help for serious concerns.'
                },
                {'role': 'user', 'content': userText}
              ],
              'stream': false,
            }),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final message = data['message'] as Map<String, dynamic>?;
        final content = message?['content'] as String?;
        return content;
      }
    } catch (_) {
      // Ignore and fall back.
    }
    return null;
  }

  String _fallbackResponse() {
    const responses = [
      'I hear you. That’s a big topic. What makes this feel important to you right now?',
      'I’m listening. Sounds like you’re sorting through something meaningful. What’s on your mind about it?',
      'Thanks for sharing. No perfect answers here, but I’m here to think it through with you.',
      'That’s deep and personal. What feelings come up when you think about this?',
    ];
    final index = DateTime.now().millisecondsSinceEpoch % responses.length;
    return responses[index];
  }
}
