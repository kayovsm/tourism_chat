import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/chat_theme.dart';
import '../../../domain/entities/message_entity.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/chat_theme.dart';
import '../../../domain/entities/message_entity.dart';

class ChatMessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;
  final bool showAvatar;
  final String receiverName;
  final bool isFirstInSequence;

  const ChatMessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.showAvatar,
    required this.receiverName,
    required this.isFirstInSequence,
  }) : super(key: key);

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: showAvatar ? 12 : 4),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && showAvatar)
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: ChatTheme.primaryColor,
                child: Text(
                  receiverName[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            )
          else if (!isMe)
            const SizedBox(width: 40),

          if (isFirstInSequence)
            Flexible(
              child: CustomPaint(
                painter: ChatBubblePainter(
                  color: isMe
                      ? ChatTheme.myMessageColor
                      : ChatTheme.otherMessageColor,
                  isMe: isMe,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: isMe ? 26 : 16,
                    top: 10,
                    // bottom: 10,
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 30),
                          child: Text(
                            message.content,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          _formatTime(message.timestamp),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? ChatTheme.myMessageColor
                      : ChatTheme.otherMessageColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                margin: EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Text(
                        message.content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      _formatTime(message.timestamp),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // if (isMe && showAvatar)
            // Padding(
            //   padding: const EdgeInsets.only(left: 8),
            //   child: Icon(
            //     Icons.done_all,
            //     size: 16,
            //     color: ChatTheme.secondaryColor,
            //   ),
            // )
          // else if (isMe)
          //   const SizedBox(width: 24),
        ],
      ),
    );
  }
}

class ChatBubblePainter extends CustomPainter {
  final Color color;
  final bool isMe;

  ChatBubblePainter({required this.color, required this.isMe});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final radius = 16.0;
    final path = Path();
    final arrowSize = 10.0; // Tamanho da seta

    if (isMe) {
      // Bolha de mensagem enviada (direita)
      path.moveTo(0, 0); // Canto superior esquerdo
      path.lineTo(
        size.width - radius - arrowSize,
        0,
      ); // Linha superior até a base da seta

      // Desenha a seta no topo direito
      path.lineTo(
        size.width - radius - arrowSize,
        0,
      ); // Base da seta à esquerda
      path.lineTo(size.width, 0); // Ponta da seta no meio
      path.lineTo(size.width - radius, radius); // Base da seta à direita

      // Continua desenhando o resto da bolha
      path.lineTo(size.width - radius, size.height - radius); // Linha direita
      path.quadraticBezierTo(
        size.width - radius,
        size.height,
        size.width - radius * 2,
        size.height,
      ); // Canto inferior direito arredondado
      path.lineTo(radius, size.height); // Linha inferior
      path.quadraticBezierTo(
        0,
        size.height,
        0,
        size.height - radius,
      ); // Canto inferior esquerdo arredondado
      path.lineTo(0, radius); // Linha esquerda
      path.quadraticBezierTo(
        0,
        0,
        radius,
        0,
      ); // Canto superior esquerdo arredondado
    } else {
      // Bolha de mensagem recebida (esquerda)
      path.moveTo(radius * 2, 0); // Canto superior esquerdo após a seta
      path.lineTo(size.width - radius, 0); // Linha superior
      path.quadraticBezierTo(
        size.width,
        0,
        size.width,
        radius,
      ); // Canto superior direito arredondado
      path.lineTo(size.width, size.height - radius); // Linha direita
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - radius,
        size.height,
      ); // Canto inferior direito arredondado
      path.lineTo(radius, size.height); // Linha inferior
      path.quadraticBezierTo(
        0,
        size.height,
        0,
        size.height - radius,
      ); // Canto inferior esquerdo arredondado
      path.lineTo(0, radius); // Linha esquerda até a base da seta

      // Desenha a seta no topo esquerdo
      path.lineTo(0, radius); // Base da seta abaixo
      path.lineTo(radius, 0); // Ponta da seta no meio
      path.lineTo(radius * 2, 0); // Base da seta à direita
    }

    path.close();
    canvas.drawPath(path, paint);

    // // Adiciona sombra (descomentado para ficar mais bonito)
    // final shadowPaint = Paint()
    //   ..color = Colors.black.withOpacity(0.1)
    //   ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    // canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
