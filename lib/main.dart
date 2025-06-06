import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/result_page.dart';
import 'pages/creator_page.dart';

void main() {
  final uri = Uri.base; // Get full URL
  final creatorId = int.tryParse(uri.queryParameters['creator_id'] ?? '');

  runApp(MyApp(creatorId: creatorId));
}

class MyApp extends StatelessWidget {
  final int? creatorId;

  const MyApp({super.key, this.creatorId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crush Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(creatorId: creatorId),
        '/result': (context) => const ResultPage(),
        '/creator': (context) => const CreatorPage(),
      },
    );
  }
}
