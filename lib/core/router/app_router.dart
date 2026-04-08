import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/about/presentation/about_screen.dart';
import '../../features/contact/presentation/contact_screen.dart';
import '../../features/details/presentation/details_screen.dart';
import '../../features/home/presentation/home_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/about', builder: (_, __) => const AboutScreen()),
      GoRoute(path: '/contact', builder: (_, __) => const ContactScreen()),
      GoRoute(
        path: '/details/:id',
        builder: (_, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return DetailsScreen(entryId: id ?? -1);
        },
      ),
      GoRoute(path: '/rate-us', builder: (_, __) => const _RateUsPage()),
      GoRoute(path: '/share', builder: (_, __) => const _SharePage()),
    ],
  );
});

class _RateUsPage extends StatelessWidget {
  const _RateUsPage();

  @override
  Widget build(BuildContext context) {
    return _ActionPage(
      title: 'Rate Us',
      message: 'Tap the button below to open the app rating page.',
      buttonText: 'Open Store Rating',
      onPressed: () async {
        final url = Uri.parse('https://example.com/app-store-link');
        await launchUrl(url, mode: LaunchMode.externalApplication);
      },
    );
  }
}

class _SharePage extends StatelessWidget {
  const _SharePage();

  @override
  Widget build(BuildContext context) {
    return _ActionPage(
      title: 'Share',
      message: 'Share the dictionary app link with others.',
      buttonText: 'Share App Link',
      onPressed: () async {
        await Share.share('Try the Dinka-English Dictionary app: https://example.com/app-link');
      },
    );
  }
}

class _ActionPage extends StatelessWidget {
  const _ActionPage({
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: 14),
                  FilledButton(onPressed: onPressed, child: Text(buttonText)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
