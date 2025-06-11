// lib/app/presentation/widgets/chat/empty_chat_view.dart
import 'package:flutter/material.dart';
import '../../theme/chat_theme.dart';

class EmptyChatView extends StatelessWidget {
  const EmptyChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: ChatTheme.primaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Envie uma mensagem para iniciar a conversa',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}