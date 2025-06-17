import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get_state/controllers/chat_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  int _currentLines = 1;
  final int _maxLines = 10;
  String answer = "";
  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateLineCount);
  }

  void _updateLineCount() {
    final int lines = '\n'.allMatches(_controller.text).length + 1;
    if (lines != _currentLines && lines <= _maxLines) {
      setState(() {
        _currentLines = lines;
      });
    }
  }
  @override
  void dispose() {
    _controller.removeListener(_updateLineCount);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        leading: IconButton(
          onPressed: () {}, 
          icon: Icon(Icons.menu)
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.chat_bubble)),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: GetBuilder<ChatController>(
        init: ChatController(),
        builder: (controller) {
          return Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, kToolbarHeight),
                    child: Obx(() {
                      return !controller.isSent.value
                      ? Container()
                      : StreamBuilder(
                        stream: controller.responseStream, 
                        builder: (context, snapshot) {
                          final text = snapshot.data ?? "";
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if(snapshot.hasError) {
                            return Container();
                          }
                          return Text(
                            text,
                            style: TextStyle(fontSize: 16),
                          );
                        },
                      );
                    },)
                  )
                )
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  // height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30), 
                      topRight: Radius.circular(30)
                    )
                  ),
                  child: AnimatedSize(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: TextFormField(
                      maxLines: _maxLines,
                      minLines: _currentLines,
                      controller: _controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16.0),  
                        hintText: "Ask anything",
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            final promptText = _controller.text.trim();
                            if (promptText.isEmpty) return;
                            controller.sendPrompt([Content.text(promptText)]);
                            controller.isSent.value = true;
                            setState(() {
                              _currentLines = 1;
                            }); 
                            _controller.clear();
                          }, 
                          icon: Icon(Icons.arrow_circle_up)
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}