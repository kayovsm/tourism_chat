// lib/app/presentation/stores/auth_store.dart
import 'package:mobx/mobx.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  _AuthStore({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  });

  @observable
  UserEntity? user;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;

    try {
      user = await loginUseCase(email, password);
      if (user == null) {
        errorMessage = 'Falha no login';
      }
    } catch (e) {
      errorMessage = 'Erro: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> register(String email, String password) async {
    isLoading = true;
    errorMessage = null;

    try {
      user = await registerUseCase(email, password);
      if (user == null) {
        errorMessage = 'Falha no registro';
      }
    } catch (e) {
      errorMessage = 'Erro: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() async {
    isLoading = true;
    errorMessage = null;

    try {
      await logoutUseCase();
      user = null;
    } catch (e) {
      errorMessage = 'Erro ao sair: $e';
    } finally {
      isLoading = false;
    }
  }
}