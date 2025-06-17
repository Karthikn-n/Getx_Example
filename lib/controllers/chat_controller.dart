import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  StreamController<String>? responseController;
  String _buffer = "";
  RxBool isSent = false.obs;

  void sendPrompt(List<Content> prompt) {
    responseController = StreamController<String>();
    _buffer = "";
    responseController!.add(""); // Reset UI

    final model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash');
    final stream = model.generateContentStream(prompt);

    stream.listen((chunk) {
      final text = chunk.text ?? "";
      _buffer += text;
      responseController!.add(_buffer); // Emit the updated text
    }, onError: (e) {
      responseController!.add("Error: $e");
    });
  }

  Stream<String> get responseStream => responseController!.stream;
}
