import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../app/route_observer.dart';
import '../core/widgets/station_text_scale.dart';
import '../features/auth/auth_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/avatar/avatar_select_screen.dart';
import '../features/basecamp/basecamp_screen.dart';
import '../features/basecamp/general_instructions_screen.dart';
import '../features/basecamp/instructional_objectives_screen.dart';
import '../features/basecamp/short_overview_screen.dart';
import '../features/map/expedition_map_screen.dart';
import '../features/pretest/pretest_screen.dart';
import '../features/station/badge_screen.dart';
import '../features/station/checkpoint_screen.dart';
import '../features/station/discovery_screen.dart';
import '../features/station/station_intro_screen.dart';
import '../features/station/station_splash_screen.dart';
import '../features/station/takeaway_screen.dart';
import '../features/station/widgets/station_step_gate.dart';
import '../features/station1/badge_screen.dart';
import '../features/station1/checkpoint_screen.dart';
import '../features/station2/checkpoint_screen.dart';
import '../features/station2/badge_screen.dart';
import '../features/station1/discovery_screen.dart';
import '../features/station1/mission_screen.dart';
import '../features/station1/takeaway_screen.dart';
import '../features/station2/takeaway_screen.dart';
import '../features/station3/takeaway_screen.dart';
import '../features/station4/badge_screen.dart';
import '../features/station4/checkpoint_screen.dart';
import '../features/station4/takeaway_screen.dart';
import '../features/station3/checkpoint_screen.dart';
import '../features/station3/badge_screen.dart';
import '../features/station2/discovery_screen.dart';
import '../features/station2/mission_screen.dart';
import '../features/station3/mission_screen.dart';
import '../features/station3/discovery_screen.dart';
import '../features/station4/discovery_screen.dart';
import '../features/station4/mission_screen.dart';
import '../features/station5/discovery_screen.dart';
import '../features/station5/mission_screen.dart';
import '../features/station5/takeaway_screen.dart';
import '../features/station5/checkpoint_screen.dart';
import '../features/station5/badge_screen.dart';
import '../features/summit/summit_screen.dart';
import '../services/auth_service.dart';
import '../services/progress_service.dart';

/// Maps a station key to its interactive mission screen.
Widget _missionFor(String key) {
  switch (key) {
    case 'station1':
      return const Station1MissionScreen();
    case 'station2':
      return const Station2MissionScreen();
    case 'station3':
      return const Station3MissionScreen();
    case 'station4':
      return const Station4MissionScreen();
    case 'station5':
      return const Station5MissionScreen();
    default:
      return StationIntroScreen(stationKey: key);
  }
}

/// Station pages get the larger small-text scaling ([StationTextScale]).
List<RouteBase> get _appRoutes =>
    [for (final r in _baseRoutes) _withStationText(r)];

RouteBase _withStationText(RouteBase route) {
  if (route is GoRoute &&
      route.path.startsWith('/station') &&
      route.builder != null &&
      route.routes.isEmpty) {
    final build = route.builder!;
    return GoRoute(
      path: route.path,
      builder: (c, s) => StationTextScale(child: build(c, s)),
    );
  }
  return route;
}

List<RouteBase> get _baseRoutes => [
    GoRoute(path: '/', builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/auth', builder: (c, s) => const AuthScreen()),
    GoRoute(path: '/avatar', builder: (c, s) => const AvatarSelectScreen()),
    GoRoute(
      path: '/basecamp',
      builder: (c, s) => BasecampScreen(
        fromMap: s.uri.queryParameters['fromMap'] == '1',
      ),
    ),
    GoRoute(
      path: '/basecamp/overview',
      builder: (c, s) => const ShortOverviewScreen(),
    ),
    GoRoute(
      path: '/basecamp/instructions',
      builder: (c, s) => const GeneralInstructionsScreen(),
    ),
    GoRoute(
      path: '/basecamp/objectives',
      builder: (c, s) => const InstructionalObjectivesScreen(),
    ),
    GoRoute(path: '/pretest', builder: (c, s) => const PretestScreen()),
    GoRoute(path: '/map', builder: (c, s) => const ExpeditionMapScreen()),

    // Per-station flow (shared param routes).
    GoRoute(
      path: '/station/:key/splash',
      builder: (c, s) =>
          StationSplashScreen(stationKey: s.pathParameters['key']!),
    ),
    GoRoute(
      path: '/station/:key/intro',
      builder: (c, s) => StationIntroScreen(stationKey: s.pathParameters['key']!),
    ),
    GoRoute(
      path: '/station/:key/discovery',
      builder: (c, s) {
        final key = s.pathParameters['key']!;
        return switch (key) {
          'station1' => const Station1DiscoveryScreen(),
          'station2' => const Station2DiscoveryScreen(),
          'station3' => const Station3DiscoveryScreen(),
          'station4' => const Station4DiscoveryScreen(),
          'station5' => const Station5DiscoveryScreen(),
          _ => StationDiscoveryScreen(stationKey: key),
        };
      },
    ),

    // Station 1 keeps its dedicated screens.
    GoRoute(
      path: '/station1/mission',
      builder: (c, s) => const StationStepGate(
        stationKey: 'station1',
        step: StationStep.mission,
        child: Station1MissionScreen(),
      ),
    ),
    GoRoute(path: '/station1/takeaway', builder: (c, s) => const Station1TakeawayScreen()),
    GoRoute(
      path: '/station1/checkpoint',
      builder: (c, s) => const StationStepGate(
        stationKey: 'station1',
        step: StationStep.checkpoint,
        child: Station1CheckpointScreen(),
      ),
    ),
    GoRoute(path: '/station1/badge', builder: (c, s) => const Station1BadgeScreen()),

    // Stations 2-5 use the per-station mission + generic takeaway/checkpoint/badge.
    for (final key in ['station2', 'station3', 'station4', 'station5']) ...[
      GoRoute(
        path: '/$key/mission',
        builder: (c, s) => StationStepGate(
          stationKey: key,
          step: StationStep.mission,
          child: _missionFor(key),
        ),
      ),
      GoRoute(
        path: '/$key/takeaway',
        builder: (c, s) => switch (key) {
              'station2' => const Station2TakeawayScreen(),
              'station3' => const Station3TakeawayScreen(),
              'station4' => const Station4TakeawayScreen(),
              'station5' => const Station5TakeawayScreen(),
              _ => StationTakeawayScreen(stationKey: key),
            },
      ),
      GoRoute(
        path: '/$key/checkpoint',
        builder: (c, s) => StationStepGate(
          stationKey: key,
          step: StationStep.checkpoint,
          child: switch (key) {
            'station2' => const Station2CheckpointScreen(),
            'station3' => const Station3CheckpointScreen(),
            'station4' => const Station4CheckpointScreen(),
            'station5' => const Station5CheckpointScreen(),
            _ => StationCheckpointScreen(stationKey: key),
          },
        ),
      ),
      GoRoute(
        path: '/$key/badge',
        builder: (c, s) => switch (key) {
              'station2' => const Station2BadgeScreen(),
              'station3' => const Station3BadgeScreen(),
              'station4' => const Station4BadgeScreen(),
              'station5' => const Station5BadgeScreen(),
              _ => StationBadgeScreen(stationKey: key),
            },
      ),
    ],

    // Summit — summative test and certificate on one screen.
    GoRoute(path: '/summit', builder: (c, s) => const SummitScreen()),
  ];

/// Builds the app router with auth-aware redirects so offline sessions resume
/// to the right screen and protected routes require a logged-in user.
GoRouter createAppRouter({
  required AuthService auth,
  required ProgressService progress,
}) {
  String? homeForLoggedInUser() {
    final user = auth.currentUser;
    if (user == null) return null;
    if (!user.avatarChosen) return '/avatar';
    if (!progress.hasTakenPretest) return '/basecamp';
    return '/map';
  }

  return GoRouter(
    initialLocation: '/',
    refreshListenable: auth,
    observers: [appRouteObserver],
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final onSplash = loc == '/';
      final onAuth = loc == '/auth';
      final onAvatar = loc == '/avatar';

      if (!auth.isLoggedIn) {
        if (onSplash || onAuth) return null;
        return '/auth';
      }

      final home = homeForLoggedInUser();
      if (home == null) return onSplash || onAuth ? null : '/';

      if (onSplash) return null;
      if (onAuth) return home;
      if (onAvatar && auth.currentUser!.avatarChosen) return home;
      if (!onAvatar && !auth.currentUser!.avatarChosen) return '/avatar';

      return null;
    },
    routes: _appRoutes,
  );
}
