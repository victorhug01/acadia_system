import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  final String? avatarUser;
  const ChatPage({super.key, this.avatarUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  late ChatUser currentUser;
  late ChatUser geminiUser;
  @override
  void initState() {
    super.initState();
    print(widget.avatarUser);
    currentUser = ChatUser(id: '0', firstName: 'user', profileImage: widget.avatarUser.toString());
    geminiUser = ChatUser(id: '1', firstName: 'Gemini', profileImage: 'https://static.vecteezy.com/system/resources/previews/046/861/646/non_2x/gemini-icon-on-a-transparent-background-free-png.png');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Gemini'),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      messageOptions: const MessageOptions(
        maxWidth: 350,
        borderRadius: 10.0,
      ),
      inputOptions: InputOptions(
        inputDecoration: InputDecoration(
          hintText: "Pesquisar por algo...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        trailing: [
          IconButton(
            onPressed: _sendMediaMessage,
            icon: const Icon(Icons.image),
          ),
        ],
      ),
      currentUser: currentUser,
      onSend: _sendMessages,
      messages: messages,
    );
  }

  void _sendMessages(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }
      gemini
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold("", (previous, current) => '$previous ${current.text}') ?? "";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold("", (previous, current) => '$previous ${current.text}') ?? "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(url: file.path, fileName: "", type: MediaType.image),
        ],
      );
      _sendMessages(chatMessage);
    }
  }
}
