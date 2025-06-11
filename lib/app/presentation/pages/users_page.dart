// lib/app/presentation/pages/users_page.dart
import 'package:flutter/material.dart';
import '../../domain/repositories/message_repository.dart';
import '../stores/auth_store.dart';
import '../../domain/entities/user_entity.dart';
import '../../injection_container.dart';
import 'chat_page.dart';
import 'login_page.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _authStore = sl<AuthStore>();
  final _messageRepository = sl<MessageRepository>();

  @override
  Widget build(BuildContext context) {
    final currentUser = _authStore.user;

    if (currentUser == null) {
      return const LoginPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authStore.logout();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<UserEntity>>(
        stream: _messageRepository.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!
              .where((user) => user.id != currentUser.id)
              .toList();

          if (users.isEmpty) {
            return const Center(child: Text('Nenhum usuário disponível'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(child: Text(user.email[0].toUpperCase())),
                title: Text(user.displayName ?? user.email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        receiverId: user.id,
                        receiverName: user.displayName ?? user.email,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
