// lib/app/presentation/theme/chat_theme.dart
import 'package:flutter/material.dart';

class ChatTheme {
  // Cores principais
  static final Color primaryColor = Color(0xFF24BAEC);
  static final Color secondaryColor = Colors.teal[300]!;
  static final Color myMessageColor = Color(0xFFD3F4FF);
  static final Color otherMessageColor = Color(0xFFB1AEAE);
  static final Color inputBackgroundColor = Colors.grey[200]!;
  static final Color sendMessageColor = Color(0xFF24BAEC);
  static final Color white = Colors.white;
  // static final Color sendMessageColor = Color(0xFFE9523F);

  // Estilos de texto
  static const TextStyle messageTextStyle = TextStyle(fontSize: 16);
  static const TextStyle timeTextStyle = TextStyle(fontSize: 11);
  static const TextStyle nameTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}