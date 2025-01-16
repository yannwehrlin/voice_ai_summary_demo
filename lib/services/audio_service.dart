import 'dart:async';
import 'dart:math';

import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AudioService {
  Future<PermissionStatus> requestMicrophonePermission() async {
    if (await Permission.microphone.isGranted) {
      return PermissionStatus.granted;
    }
    await Permission.microphone.request();
    if (await Permission.microphone.isGranted) {
      return PermissionStatus.granted;
    }
    return Permission.microphone.status;
  }

  Future<String?> speechToText() async {
    Completer<String?> completer = Completer<String?>();
    var permissionStatus = await requestMicrophonePermission();
    print('Permission status: $permissionStatus');
    if (permissionStatus.isGranted) {
      bool onDevice = false;
      const int listenForSeconds = 60;
      const int pauseForSeconds = 4;
      double minSoundLevel = 50000;
      double maxSoundLevel = -50000;
      final SpeechToText speech = SpeechToText();

      final options = SpeechListenOptions(
          onDevice: onDevice,
          listenMode: ListenMode.confirmation,
          cancelOnError: true,
          partialResults: true,
          autoPunctuation: true,
          enableHapticFeedback: true);

      try {
        bool isInitialized = await speech.initialize(
          onError: (error) {
            print('Speech recognition error: ${error.errorMsg}');
            if (!completer.isCompleted) completer.complete(null);
          },
          onStatus: (status) {
            print('Speech recognition status: $status');
            if (status == 'done' && !completer.isCompleted) {
              completer.complete(null);
            }
          },
        );

        if (!isInitialized) {
          print('Speech recognition initialization failed');
          return null;
        }

        var systemLocale = await speech.systemLocale();
        String currentLocaleId = systemLocale?.localeId ?? '';

        if (!speech.isAvailable) {
          print('Speech recognition is not available');
          return null;
        }

        await speech.listen(
          onResult: (SpeechRecognitionResult result) async {
            print("onResult");
            if (result.finalResult) {
              if (!completer.isCompleted) {
                completer.complete(result.recognizedWords);
              }
            }
          },
          listenFor: const Duration(seconds: listenForSeconds),
          pauseFor: const Duration(seconds: pauseForSeconds),
          localeId: currentLocaleId,
          onSoundLevelChange: (level) {
            minSoundLevel = min(minSoundLevel, level);
            maxSoundLevel = max(maxSoundLevel, level);
            //    print('Sound level $level: $minSoundLevel - $maxSoundLevel');
          },
          listenOptions: options,
        );
        print("completer.future: ${completer.future}");
        return completer.future;
      } catch (e) {
        print('Error in speech recognition: $e');
      }
    } else {
      print('Microphone permission denied');
    }
    return completer.future;
  }
}
