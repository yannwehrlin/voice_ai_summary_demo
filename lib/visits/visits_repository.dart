import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_ai_summary_demo/services/ai_service.dart';
import 'package:voice_ai_summary_demo/services/audio_service.dart';

final visitsRepositoryProvider = Provider<VisitsRepository>((ref) {
  return VisitsRepository();
});

class VisitsRepository {
  final aiService = AIService();
  final audio = AudioService();

  Future<String?> recordReview() async {
    var review = await audio.speechToText();
    print("speechToText: $review");
    if (review != null) {
      String summary = await aiService.getSummary(review);
      return summary;
    } else {
      print("No text captured");
      return null;
    }
  }
}
