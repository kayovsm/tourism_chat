// lib/app/domain/repositories/message_repository.dart
import '../entities/message_entity.dart';
import '../entities/user_entity.dart';

abstract class MessageRepository {
  Future<void> sendMessage(MessageEntity message);
  Stream<List<MessageEntity>> getMessages(String userId, String otherUserId);
  Stream<List<UserEntity>> getUsers();
}