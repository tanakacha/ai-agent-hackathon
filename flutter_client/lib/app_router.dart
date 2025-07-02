import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'auth/view/auth_screen.dart';
import 'auth/view_model/auth_notifier.dart';
import 'maps_list/view/maps_list_screen.dart';
import 'goal_input/view/goal_input_screen.dart';
import 'user_profile/view/user_profile_input_screen.dart';
import 'roadmap_display/view/roadmap_display_screen.dart';

// ルート定義
class AppRoutes {
  static const String auth = '/auth';
  static const String mapsList = '/maps';
  static const String goalInput = '/goal-input';
  static const String userProfile = '/user-profile';
  static const String roadmapDisplay = '/roadmap';
}

// GoRouterプロバイダー
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  
  return GoRouter(
    initialLocation: AppRoutes.auth,
    redirect: (context, state) {
      final isAuthRoute = state.fullPath == AppRoutes.auth;
      
      return authState.when(
        initial: () => AppRoutes.auth,
        loading: () => AppRoutes.auth,
        authenticated: (user, isNewUser) {
          if (isAuthRoute) {
            // 新規登録の場合はユーザー情報入力画面へ
            if (isNewUser == true) {
              return '${AppRoutes.userProfile}?uid=${user.uid}';
            }
            // 既存ユーザーの場合はマップ一覧に移動
            return '${AppRoutes.mapsList}?uid=${user.uid}';
          }
          return null; // 認証済みで認証ルート以外の場合は現在のルートのまま
        },
        unauthenticated: () => isAuthRoute ? null : AppRoutes.auth,
        error: (message) => AppRoutes.auth,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.mapsList,
        builder: (context, state) {
          final uid = state.uri.queryParameters['uid'];
          if (uid == null) return const AuthScreen();
          return MapsListScreen(uid: uid);
        },
      ),
      GoRoute(
        path: AppRoutes.goalInput,
        builder: (context, state) {
          final uid = state.uri.queryParameters['uid'];
          if (uid == null) return const AuthScreen();
          return GoalInputScreen(uid: uid);
        },
      ),
      GoRoute(
        path: AppRoutes.userProfile,
        builder: (context, state) {
          final uid = state.uri.queryParameters['uid'];
          if (uid == null) return const AuthScreen();
          return UserProfileInputScreen(uid: uid);
        },
      ),
      GoRoute(
        path: AppRoutes.roadmapDisplay,
        builder: (context, state) {
          final mapId = state.uri.queryParameters['mapId'];
          if (mapId == null) {
            // mapIdがない場合はマップ一覧に戻る
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(AppRoutes.mapsList);
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return RoadmapDisplayScreen(mapId: mapId);
        },
      ),
    ],
  );
});

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'RoadMap App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: router,
    );
  }
}
