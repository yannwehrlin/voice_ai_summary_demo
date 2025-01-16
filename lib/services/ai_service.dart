import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:voice_ai_summary_demo/credentials.dart';

class AIService {
  final String apiKey = Credentials.cohereApiKey;

//   Future<String> getSummary(String text) async {
//     final response = await http.post(
//       Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $apiKey',
//       },
//       body: jsonEncode({
//         'prompt': 'Summarize the following text: $text',
//         'max_tokens': 100,
//         'temperature': 0.7,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> parsed = json.decode(response.body);
//       return parsed['choices'][0]['text'].trim();
//     } else {
//       throw Exception('Failed to get summary');
//     }
//   }
// }

  Future<String> getSummary(String text) async {
    final response = await http.post(
      Uri.parse('https://api.cohere.ai/generate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'command-r-plus', // or use specific model name if required
        'prompt':
            'Résume le texte suivant, en dégageant si possible les points positifs et négatifs: $text',
        'max_tokens': 300,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> parsed =
          json.decode(utf8.decode(response.bodyBytes));

      print('parsed text: ${parsed['text']}');
      return parsed['text'];
    } else {
      throw Exception('Failed to get summary');
    }
  }
}
