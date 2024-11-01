import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelegramPostWidget extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _postToTelegram() async {
    final String botToken = 'YOUR_TELEGRAM_BOT_TOKEN';
    final String chatId = 'YOUR_TELEGRAM_CHAT_ID';
    final String message = "${_titleController.text}\n\n${_contentController.text}";

    final response = await http.post(
      Uri.parse("https://api.telegram.org/bot$botToken/sendMessage"),
      body: {
        'chat_id': chatId,
        'text': message,
      },
    );

    if (response.statusCode == 200) {
      print("Message sent to Telegram");
    } else {
      print("Failed to send message");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Post to Telegram'),
              content: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(labelText: 'Content'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _postToTelegram();
                    Navigator.pop(context);
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Text("Post to Telegram"),
      ),
    );
  }
}
