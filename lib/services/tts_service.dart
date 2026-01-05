import 'dart:ui';

import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  VoidCallback? _onComplete;

  Future<void> init({VoidCallback? onComplete}) async {
    _onComplete = onComplete;

    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    _tts.setCompletionHandler(() {
      _onComplete?.call();
    });
  }

  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  void dispose() {
    _tts.stop();
  }
}
