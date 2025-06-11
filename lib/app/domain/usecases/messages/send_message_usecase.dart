// lib/app/domain/usecases/message/send_message_usecase.dart
import '../../entities/message_entity.dart';
import '../../repositories/message_repository.dart';

class SendMessageUseCase {
  final MessageRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call(MessageEntity message) {
    return repository.sendMessage(message);
  }
}