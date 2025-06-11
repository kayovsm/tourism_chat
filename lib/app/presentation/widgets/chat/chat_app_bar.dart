// lib/app/presentation/widgets/chat/chat_app_bar.dart
import 'package:flutter/material.dart';
import '../../theme/chat_theme.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String receiverName;
  final VoidCallback? onCallPressed;
  final VoidCallback? onMenuPressed;

  const ChatAppBar({
    Key? key,
    required this.receiverName,
    this.onCallPressed,
    this.onMenuPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ChatTheme.primaryColor,
      iconTheme: IconThemeData(color: ChatTheme.white),
      elevation: 0,
      title: Row(
        spacing: 8,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              receiverName[0].toUpperCase(),
              style: TextStyle(color: ChatTheme.primaryColor),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                receiverName,
                style: TextStyle(
                  color: ChatTheme.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Online',
                style: TextStyle(fontSize: 12, color: ChatTheme.white),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.translate_rounded, color: ChatTheme.white),
          onPressed: onCallPressed ?? () {},
        ),
        SizedBox(width: 10),
        // IconButton(
        //   icon: const Icon(Icons.more_vert),
        //   onPressed: onMenuPressed ?? () {},
        // ),
      ],
    );
  }
}
