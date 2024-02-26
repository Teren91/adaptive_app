
import 'package:adaptive_app/src/adaptive_login.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:provider/provider.dart';

import 'src/adaptive_playlists.dart';
import 'src/app_state.dart';
import 'src/playlist_details.dart';

final scopes = [
  'https://www.googleapis.com/auth/youtube.readonly',
  //'https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw',
];

final clientId = ClientId(
  '316226658330-jk2irf4khhqedadto8ojcjt7p9ao610u.apps.googleusercontent.com',
  //'316226658330-8bsl7g32andje7hrkjcl5efemvbg5ucs.apps.googleusercontent.com',
  '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',
);

final _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const AdaptivePlaylists();
      },
      redirect: (context, state)
      {
        if(!context.read<AuthedUserPlaylists>().isLoggedIn)
        {
          return '/login';
        }else
        {
          return null;
        }
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (context, state)
          {
            return AdaptiveLogin(
              clientId: clientId, 
              scopes: scopes, 
              loginButtonChild: const Text('Login to YouTube!'),
            );
          },
        ),
        GoRoute(
          path: 'playlist/:id',
          builder: (context, state) {
            final title = state.uri.queryParameters['title']!;
            final id = state.pathParameters['id']!;
            return Scaffold(
              appBar: AppBar(title: Text(title)),
              body: PlaylistDetails(
                playlistId: id,
                playlistName: title,
              ),
            );
          },
        ),
      ],
    ),
  ],
);

void main() {
  runApp(ChangeNotifierProvider<AuthedUserPlaylists>(
    
    create: (context) => AuthedUserPlaylists(),
    child: const PlaylistsApp(),
  ));
}

class PlaylistsApp extends StatelessWidget {
  const PlaylistsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Your Playlists',
      theme: FlexColorScheme.light(
        scheme: FlexScheme.red,
        useMaterial3: true,
      ).toTheme,
      darkTheme: FlexColorScheme.dark(
        scheme: FlexScheme.red,
        useMaterial3: true,
      ).toTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}