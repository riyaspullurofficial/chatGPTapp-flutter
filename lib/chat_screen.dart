import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<ChatMessage> _messages = [];
  ChatGPT? chatGPT;
  StreamSubscription? _subscription;

  @override
  void initState() {
    chatGPT = ChatGPT.instance;
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void sendMessage() {
    /*   final String text = _textEditingController.text;
    if (text.isNotEmpty) {
      _textEditingController.clear();
      final ChatMessage message = ChatMessage(text: text, sender: "Me");
    }*/

    ChatMessage _message =
        ChatMessage(text: _textEditingController.text, sender: "User");
    setState(() {
      _messages.insert(0, _message);
    });

    _textEditingController.clear();

    final request = CompleteReq(
        prompt: _message.text, model: kTranslateModelV3, max_tokens: 200);

    _subscription = chatGPT!
        .builder("api-key")
        .onCompleteStream(request: request)
        .listen((response) {
      Vx.log(response!.choices[0].text);
      ChatMessage botMessage =
          ChatMessage(text: response!.choices[0].text, sender: "bot");

      setState(() {
        _messages.insert(0, botMessage);
      });
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          onSubmitted: (value) => sendMessage(),
          controller: _textEditingController,
          decoration:
              const InputDecoration.collapsed(hintText: "Send a message"),
        )),
        IconButton(onPressed: () => sendMessage(), icon: const Icon(Icons.send))
      ],
    ).px12();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Chat GPT OpenAI",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
          child: Column(
            children: [
              Flexible(
                  child: /*Container(
                height: context.screenHeight,
              )*/

                      ListView.builder(
                          reverse: true,
                          padding: Vx.m8,
                          itemCount: _messages.length,
                          itemBuilder: (cnx, index) {
                            return /*Container(
                              height: 100,
                              color: Colors.red,
                            ).p(5)*/
                                _messages[index];
                          })),
              Container(
                decoration: BoxDecoration(color: context.cardColor),
                child: _buildTextComposer(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
