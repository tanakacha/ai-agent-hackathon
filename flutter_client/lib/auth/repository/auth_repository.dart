
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

part '_generated/auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(FirebaseAuth.instance, GoogleSignIn());
}

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(this._firebaseAuth, this._googleSignIn);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // デバッグログ用
  void _debugLog(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  // デバッグ機能とエラーハンドリングを追加
  Future<UserCredential> signInWithGoogle() async {
    try {
      _debugLog('Google Sign-In開始');

      _debugLog(
          '現在のGoogleSignInアカウント: ${_googleSignIn.currentUser?.email ?? "なし"}');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _debugLog('ユーザーがGoogle Sign-Inをキャンセルしました');
        throw Exception('Google Sign In cancelled');
      }

      _debugLog('Google Sign-In ダイアログ成功: ${googleUser.email}');
      _debugLog('Google認証情報を取得中...');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      _debugLog(
          'AccessToken: ${googleAuth.accessToken != null ? "取得済み(${googleAuth.accessToken?.substring(0, 10)}...)" : "なし"}');
      _debugLog(
          'IdToken: ${googleAuth.idToken != null ? "取得済み(${googleAuth.idToken?.substring(0, 10)}...)" : "なし"}');

      // Access Tokenのチェック
      if (googleAuth.accessToken == null) {
        throw Exception('Access Token が取得できませんでした');
      }

      // ID Tokenのチェック
      if (googleAuth.idToken == null) {
        throw Exception('ID Token が取得できませんでした');
      }

      _debugLog('Firebase認証情報を作成');

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // デバッグログでび確認を追加（機能の変更なし）
      _debugLog('Firebaseにサインイン中');
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      _debugLog('Firebase認証成功: ${userCredential.user?.email}');
      _debugLog('UID: ${userCredential.user?.uid}');

      return userCredential;
    } catch (e, stackTrace) {
      _debugLog('Google Sign-In エラー詳細:');
      _debugLog('エラー型: ${e.runtimeType}');
      _debugLog('エラー内容: $e');
      _debugLog('StackTrace: $stackTrace');
      rethrow; // エラーを再度投げる
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
