import 'package:cinemapedia/config/router/app_routes.dart';
import 'package:cinemapedia/presentation/screens/movies/movie_screen.dart';
import 'package:cinemapedia/presentation/views/movies/categories_view.dart';
import 'package:cinemapedia/presentation/views/movies/favorites_view.dart';
import 'package:cinemapedia/presentation/views/movies/home_view.dart';
import 'package:cinemapedia/presentation/widgets/shared/scaffold_with_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNavbar(navigationShell: navigationShell),

      branches: [
        StatefulShellBranch(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              name: AppRoute.home.name,
              builder: (context, state) => const HomeView(),
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'movie/:id',
                  name: AppRoute.movieScreen.name,
                  pageBuilder: (context, state) => buildPageWithSlide(
                    MovieScreen(movieId: state.pathParameters['id'] ?? 'no-id'),
                    state,
                  ),
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/categories',
              name: AppRoute.categories.name,
              builder: (context, state) => CategoriesView(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              name: AppRoute.favorites.name,
              builder: (context, state) => FavoritesView(),
            ),
          ],
        ),
      ],
    ),
  ],
);

Page<T> buildPageWithFade<T>(Widget child, GoRouterState state) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    child: child,
  );
}

Page<T> buildPageWithSlide<T>(
  Widget child,
  GoRouterState state, [
  bool isGoingRight = true,
]) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
          position: Tween(
            begin: Offset(isGoingRight ? 1 : -1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
    child: child,
  );
}
