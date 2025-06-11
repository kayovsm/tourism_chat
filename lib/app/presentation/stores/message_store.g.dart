// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MessageStore on _MessageStore, Store {
  late final _$messagesAtom = Atom(
    name: '_MessageStore.messages',
    context: context,
  );

  @override
  ObservableList<MessageEntity> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<MessageEntity> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  late final _$usersAtom = Atom(name: '_MessageStore.users', context: context);

  @override
  ObservableList<UserEntity> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(ObservableList<UserEntity> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_MessageStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_MessageStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$currentChatUserIdAtom = Atom(
    name: '_MessageStore.currentChatUserId',
    context: context,
  );

  @override
  String? get currentChatUserId {
    _$currentChatUserIdAtom.reportRead();
    return super.currentChatUserId;
  }

  @override
  set currentChatUserId(String? value) {
    _$currentChatUserIdAtom.reportWrite(value, super.currentChatUserId, () {
      super.currentChatUserId = value;
    });
  }

  late final _$chatMessagesAtom = Atom(
    name: '_MessageStore.chatMessages',
    context: context,
  );

  @override
  ObservableMap<String, ObservableList<MessageEntity>> get chatMessages {
    _$chatMessagesAtom.reportRead();
    return super.chatMessages;
  }

  @override
  set chatMessages(ObservableMap<String, ObservableList<MessageEntity>> value) {
    _$chatMessagesAtom.reportWrite(value, super.chatMessages, () {
      super.chatMessages = value;
    });
  }

  late final _$currentChatIdAtom = Atom(
    name: '_MessageStore.currentChatId',
    context: context,
  );

  @override
  String? get currentChatId {
    _$currentChatIdAtom.reportRead();
    return super.currentChatId;
  }

  @override
  set currentChatId(String? value) {
    _$currentChatIdAtom.reportWrite(value, super.currentChatId, () {
      super.currentChatId = value;
    });
  }

  late final _$sendMessageAsyncAction = AsyncAction(
    '_MessageStore.sendMessage',
    context: context,
  );

  @override
  Future<void> sendMessage(MessageEntity message) {
    return _$sendMessageAsyncAction.run(() => super.sendMessage(message));
  }

  late final _$_MessageStoreActionController = ActionController(
    name: '_MessageStore',
    context: context,
  );

  @override
  void startMessagesListener(String userId, String otherUserId) {
    final _$actionInfo = _$_MessageStoreActionController.startAction(
      name: '_MessageStore.startMessagesListener',
    );
    try {
      return super.startMessagesListener(userId, otherUserId);
    } finally {
      _$_MessageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void disposeMessagesListener() {
    final _$actionInfo = _$_MessageStoreActionController.startAction(
      name: '_MessageStore.disposeMessagesListener',
    );
    try {
      return super.disposeMessagesListener();
    } finally {
      _$_MessageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reloadMessages() {
    final _$actionInfo = _$_MessageStoreActionController.startAction(
      name: '_MessageStore.reloadMessages',
    );
    try {
      return super.reloadMessages();
    } finally {
      _$_MessageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
messages: ${messages},
users: ${users},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
currentChatUserId: ${currentChatUserId},
chatMessages: ${chatMessages},
currentChatId: ${currentChatId}
    ''';
  }
}
