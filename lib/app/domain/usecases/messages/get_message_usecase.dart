// lib/app/domain/usecases/message/get_messages_usecase.dart
import '../../entities/message_entity.dart';
import '../../repositories/message_repository.dart';

class GetMessageUseCase {
  final MessageRepository repository;

  GetMessageUseCase(this.repository);

  Stream<List<MessageEntity>> call(String userId, String otherUserId) {
    return repository.getMessages(userId, otherUserId);
  }
}