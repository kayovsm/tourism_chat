// lib/app/data/datasources/message_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

abstract class MessageDataSource {
  Future<void> sendMessage(MessageModel message);

  Stream<List<MessageModel>> getMessages(String userId, String otherUserId);

  Stream<List<UserModel>> getUsers();
}

class FirebaseMessageDataSource implements MessageDataSource {
  final FirebaseFirestore _firestore;

  FirebaseMessageDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // gera ID de chat
  String _getChatId(String userId1, String userId2) {
    final List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('_');
  }

  @override
  Future<void> sendMessage(MessageModel message) async {
    final chatId = _getChatId(message.senderId, message.receiverId);

    // salva a mensagem
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  }

  @override
  Stream<List<MessageModel>> getMessages(String userId, String otherUserId) {
    final chatId = _getChatId(userId, otherUserId);

    // busca mensagens da subcolecao deste chat específico
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Stream<List<UserModel>> getUsers() {
    return _firestore
        .collection('users')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
