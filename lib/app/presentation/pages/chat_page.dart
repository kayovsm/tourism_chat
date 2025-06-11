// lib/app/presentation/pages/chat_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../stores/auth_store.dart';
import '../stores/message_store.dart';
import '../../domain/entities/message_entity.dart';
import '../../injection_container.dart';
import '../widgets/chat/chat_app_bar.dart';
import '../widgets/chat/chat_input_field.dart';
import '../widgets/chat/chat_message_list.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatPage({
    Key? key,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final _authStore = sl<AuthStore>();
  final _messageStore = sl<MessageStore>();
  final ScrollController _scrollController = ScrollController();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _initChat();
    _messageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isComposing = _messageController.text.trim().isNotEmpty;
    });
  }

  void _initChat() {
    final currentUser = _authStore.user;
    if (currentUser != null) {
      _messageStore.startMessagesListener(currentUser.id, widget.receiverId);
    }
    _scrollToBottomOnLoad();
  }

  void _scrollToBottomOnLoad() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageStore.disposeMessagesListener();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final currentUser = _authStore.user;
    if (currentUser == null) return;

    final message = MessageEntity(
      id: '',
      senderId: currentUser.id,
      receiverId: widget.receiverId,
      content: _messageController.text.trim(),
      timestamp: DateTime.now(),
    );

    await _messageStore.sendMessage(message);
    _messageController.clear();
    _messageStore.reloadMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authStore.user;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não autenticado')),
      );
    }

    return Scaffold(
      appBar: ChatAppBar(receiverName: widget.receiverName),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: Column(
          children: [
            Expanded(
              child: Observer(
                builder: (_) {
                  return ChatMessageList(
                    messages: _messageStore.messages,
                    currentUserId: currentUser.id,
                    receiverName: widget.receiverName,
                    scrollController: _scrollController,
                  );
                },
              ),
            ),
            Observer(
              builder: (_) {
                return ChatInputField(
                  controller: _messageController,
                  isLoading: _messageStore.isLoading,
                  isComposing: _isComposing,
                  onSendPressed: _sendMessage,
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      _sendMessage();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
