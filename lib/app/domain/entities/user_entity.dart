// lib/app/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });
}