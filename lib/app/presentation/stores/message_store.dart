import 'dart:async';
import 'package:mobx/mobx.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/messages/get_message_usecase.dart';
import '../../domain/usecases/messages/send_message_usecase.dart';

part 'message_store.g.dart';

class MessageStore = _MessageStore with _$MessageStore;

abstract class _MessageStore with Store {
  final SendMessageUseCase sendMessageUseCase;
  final GetMessageUseCase getMessageUseCase;

  _MessageStore({
    required this.sendMessageUseCase,
    required this.getMessageUseCase,
  });

  @observable
  ObservableList<MessageEntity> messages = ObservableList<MessageEntity>();

  @observable
  ObservableList<UserEntity> users = ObservableList<UserEntity>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  String? currentChatUserId;

  @observable
  ObservableMap<String, ObservableList<MessageEntity>> chatMessages =
  ObservableMap<String, ObservableList<MessageEntity>>();

  @observable
  String? currentChatId;

  // Use nullable ao invés de late para evitar o erro
  ReactionDisposer? _reactionDisposer;
  StreamSubscription<List<MessageEntity>>? _currentSubscription;

  String _getChatId(String user1, String user2) {
    final List<String> ids = [user1, user2];
    ids.sort();
    return ids.join('_');
  }

  @action
  void startMessagesListener(String userId, String otherUserId) {
    // Cancela qualquer listener anterior
    disposeMessagesListener();

    // Define o chat atual
    currentChatUserId = otherUserId;
    currentChatId = _getChatId(userId, otherUserId);

    // Limpa as mensagens atuais
    messages.clear();

    // Inicializa a lista para este chat se não existir
    if (!chatMessages.containsKey(currentChatId)) {
      chatMessages[currentChatId!] = ObservableList<MessageEntity>();
    } else {
      // Se já temos mensagens para este chat, mostre-as imediatamente
      messages.addAll(chatMessages[currentChatId!]!);
    }

    // Inicializa o listener usando reaction para controlar o estado
    _reactionDisposer = reaction((_) => currentChatId, (String? chatId) {
      // Cancela a subscrição anterior
      _currentSubscription?.cancel();

      if (chatId != null && currentChatUserId != null) {
        // Cria uma nova subscrição para este chat específico
        _currentSubscription = getMessageUseCase(userId, currentChatUserId!)
            .listen((newMessages) {
          // Verifica se ainda estamos no mesmo chat
          if (currentChatId == chatId) {
            // Atualiza a lista específica deste chat
            chatMessages[chatId]!.clear();
            chatMessages[chatId]!.addAll(newMessages);

            // Atualiza a lista principal
            messages.clear();
            messages.addAll(chatMessages[chatId]!);
          }
        });
      }
    }, fireImmediately: true);
  }

  @action
  void disposeMessagesListener() {
    // Cancela o reaction se existir
    _reactionDisposer?.call();

    // Cancela a subscrição do stream
    _currentSubscription?.cancel();
    _currentSubscription = null;
  }

  @action
  Future<void> sendMessage(MessageEntity message) async {
    isLoading = true;
    try {
      await sendMessageUseCase(message);

      final sentMessage = MessageEntity(
        id: DateTime.now().toString(),
        senderId: message.senderId,
        receiverId: message.receiverId,
        content: message.content,
        timestamp: message.timestamp,
      );

      // obter o chatId correto
      final chatId = _getChatId(message.senderId, message.receiverId);

      // adicionar à lista específica deste chat
      if (!chatMessages.containsKey(chatId)) {
        chatMessages[chatId] = ObservableList<MessageEntity>();
      }
      chatMessages[chatId]!.add(sentMessage);

      // só atualizar a lista principal se for o chat atual
      if (chatId == currentChatId) {
        messages.add(sentMessage);
      }
    } catch (e) {
      errorMessage = 'Erro ao enviar mensagem: $e';
      print(errorMessage);
    } finally {
      isLoading = false;
    }
  }

  @action
  void reloadMessages() {
    if (currentChatUserId != null && currentChatId != null) {
      // Vamos tentar usar um ID que garantidamente existe
      String? senderId;
      if (messages.isNotEmpty) {
        senderId = messages.first.senderId;
      } else if (chatMessages[currentChatId!]?.isNotEmpty ?? false) {
        senderId = chatMessages[currentChatId!]!.first.senderId;
      }

      if (senderId != null) {
        _currentSubscription?.cancel();
        _currentSubscription = getMessageUseCase(senderId, currentChatUserId!)
            .listen((newMessages) {
          // Atualiza apenas se for o chat atual
          if (currentChatId == _getChatId(senderId!, currentChatUserId!)) {
            chatMessages[currentChatId!]!.clear();
            chatMessages[currentChatId!]!.addAll(newMessages);

            messages.clear();
            messages.addAll(chatMessages[currentChatId!]!);
          }
        });
      }
    }
  }
}