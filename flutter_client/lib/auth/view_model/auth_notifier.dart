import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_state.dart';

part '_generated/auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  AuthState build() {
    _listenToAuthChanges();
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      return AuthState.authenticated(currentUser, isNewUser: false);
    }
    return const AuthState.unauthenticated();
  }

  void _listenToAuthChanges() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        state = AuthState.authenticated(user, isNewUser: false);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AuthState.loading();
    try {
      await _auth.signInWithEmailAndPassword(
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
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 新規登録の場合はisNewUserをtrueに設定
      if (userCredential.user != null) {
        state = AuthState.authenticated(userCredential.user!, isNewUser: true);
      }
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_getErrorMessage(e));
    } catch (e) {
      state = AuthState.error('予期しないエラーが発生しました: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      state = AuthState.error('ログアウトに失敗しました: ${e.toString()}');
    }
  }

  void clearNewUserFlag() {
    state.whenOrNull(
      authenticated: (user, isNewUser) {
        if (isNewUser == true) {
          state = AuthState.authenticated(user, isNewUser: false);
        }
      },
    );
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