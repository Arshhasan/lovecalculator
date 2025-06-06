import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final yourName = args?['yourName'] ?? 'Friend';
    final crushName = args?['crushName'] ?? 'Someone';
    final creatorName =
        args?['creatorName'] ?? 'The Creator'; // Replace with real data later

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have been pranked by $creatorName!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/creator');
              },
              child: const Text("Wanna know your friends' crush?"),
            ),
          ],
        ),
      ),
    );
  }
}
