import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../theme/chat_theme.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final bool isComposing;
  final VoidCallback onSendPressed;
  final Function(String) onSubmitted;

  const ChatInputField({
    Key? key,
    required this.controller,
    required this.isLoading,
    required this.isComposing,
    required this.onSendPressed,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Material(
        elevation: 8,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: ChatTheme.sendMessageColor,
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: ChatTheme.inputBackgroundColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Mensagem...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            isDense: true,
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.send,
                          onSubmitted: onSubmitted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Material(
                color: isComposing ? ChatTheme.sendMessageColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isLoading
                        ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                        : IconButton(
                      icon: Icon(
                        isComposing ? Icons.send : Icons.mic,
                        color: isComposing ? Colors.white : Colors.grey[600],
                      ),
                      onPressed: isLoading || !isComposing ? null : onSendPressed,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}