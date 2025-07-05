import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repository/auth_repository.dart';
import 'auth_state.dart';

part '_generated/auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final AuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);
    _listenToAuthChanges();
    return const AuthState.unauthenticated();
  }

  void _listenToAuthChanges() {
    _authRepository.authStateChanges.listen((User? user) {
      if (user != null) {
        state = AuthState.authenticated(user, isNewUser: false);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();
    try {
      await _authRepository.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_getErrorMessage(e));
    } catch (e) {
      state = AuthState.error('Googleサインインに失敗しました: ${e.toString()}');
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AuthState.loading();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_getErrorMessage(e));
    } catch (e) {
      state = AuthState.error('予期しないエラーが発生しました: ${e.toString()}');
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    state = const AuthState.loading();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_getErrorMessage(e));
    } catch (e) {
      state = AuthState.error('予期しないエラーが発生しました: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      state = AuthState.error('ログアウトに失敗しました: ${e.toString()}');
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'ユーザーが見つかりません';
      case 'wrong-password':
        return 'パスワードが間違っています';
      case 'email-already-in-use':
        return 'このメールアドレスは既に使用されています';
      case 'weak-password':
        return 'パスワードが弱すぎます';
      case 'invalid-email':
        return 'メールアドレスの形式が正しくありません';
      default:
        return '認証エラー: ${e.message}';
    }
  }
}