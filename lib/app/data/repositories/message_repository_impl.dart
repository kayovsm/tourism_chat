// lib/app/data/repositories/message_repository_impl.dart
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_datasource.dart';
import '../models/message_model.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageDataSource dataSource;

  MessageRepositoryImpl(this.dataSource);

  @override
  Future<void> sendMessage(MessageEntity message) {
    final messageModel = MessageModel(
      id: message.id,
      senderId: message.senderId,
      receiverId: message.receiverId,
      content: message.content,
      timestamp: message.timestamp,
    );
    return dataSource.sendMessage(messageModel);
  }

  @override
  Stream<List<MessageEntity>> getMessages(String userId, String otherUserId) {
    return dataSource.getMessages(userId, otherUserId);
  }

  @override
  Stream<List<UserEntity>> getUsers() {
    return dataSource.getUsers();
  }
}