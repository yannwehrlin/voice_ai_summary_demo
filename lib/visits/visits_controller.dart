import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:voice_ai_summary_demo/services/ai_service.dart';
import 'package:voice_ai_summary_demo/visits/visits_repository.dart';

part 'visits_controller.g.dart';

final reviewProvider = StateProvider.autoDispose<String?>((ref) => null);
final isListeningProvider = StateProvider.autoDispose<bool>((ref) => false);

@riverpod
class VisitsController extends _$VisitsController {
  @override
  FutureOr<void> build() {}

  Future reviewVisit() async {
    final visitsRepository = ref.read(visitsRepositoryProvider);
    try {
      ref.read(isListeningProvider.notifier).state = true;
      final review = await visitsRepository.recordReview();
      //   final review =
      //      "une personne a visité le bien, il a trouvé l'appartement plutôt grand et lumineux, cependant il est gêné par l'absence de garage, mais il aime qu'il soit traversant et en étage élevé. Par contre il est un peu loin de son travail donc il va réfléchir";
      if (review != null) {
        final summary = await AIService().getSummary(review);
        print('summary: $summary');
        ref.read(reviewProvider.notifier).state = summary;
      }
      ref.read(isListeningProvider.notifier).state = false;
    } catch (e) {
      print(e);
      ref.read(isListeningProvider.notifier).state = false;
    }
  }
}
