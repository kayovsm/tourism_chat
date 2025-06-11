// lib/app/presentation/widgets/chat/chat_message_list.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/message_entity.dart';
import 'chat_message_bubble.dart';
import 'empty_chat_view.dart';

class ChatMessageList extends StatelessWidget {
  final List<MessageEntity> messages;
  final String currentUserId;
  final String receiverName;
  final ScrollController scrollController;

  const ChatMessageList({
    Key? key,
    required this.messages,
    required this.currentUserId,
    required this.receiverName,
    required this.scrollController,
  }) : super(key: key);

  bool _shouldShowAvatar(int index) {
    if (index == 0) return true;

    final currentMessage = messages[index];
    final previousMessage = messages[index - 1];

    return currentMessage.senderId != previousMessage.senderId ||
        currentMessage.timestamp
                .difference(previousMessage.timestamp)
                .inMinutes >
            5;
  }

  bool _isFirstInSequence(int index) {
    if (index == 0) return true;

    final currentMessage = messages[index];
    final previousMessage = messages[index - 1];

    // É a primeira mensagem na sequência se o remetente anterior for diferente
    return currentMessage.senderId != previousMessage.senderId;
  }

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const EmptyChatView();
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.senderId == currentUserId;
        final showAvatar = _shouldShowAvatar(index);
        final isFirstInSequence = _isFirstInSequence(index);

        return ChatMessageBubble(
          message: message,
          isMe: isMe,
          showAvatar: showAvatar,
          receiverName: receiverName,
          isFirstInSequence: isFirstInSequence,
        );
      },
    );
  }
}
