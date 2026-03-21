import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_settings_provider.dart';
import '../views/tab/main_tab_view.dart';
import '../views/onboarding/onboarding_page.dart';

/// オンボーディング完了状態だけを監視するプロバイダー
final _onboardingCompletedProvider = Provider<bool>((ref) {
  return ref.watch(
    userSettingsProvider.select((s) => s.onboardingCompleted),
  );
});

/// ルーター（onboardingCompleted の変更のみで再構築）
final appRouterProvider = Provider<GoRouter>((ref) {
  final onboarded = ref.watch(_onboardingCompletedProvider);

  return GoRouter(
    initialLocation: '/onboarding',
    redirect: (context, state) {
      final isOnboarding = state.matchedLocation == '/onboarding';

      if (onboarded && isOnboarding) return '/';
      if (!onboarded && !isOnboarding) return '/onboarding';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainTabView(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
    ],
  );
});
