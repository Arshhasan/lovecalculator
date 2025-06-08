import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final int? creatorId;

  const HomePage({super.key, this.creatorId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController yourNameController = TextEditingController();
  final TextEditingController crushNameController = TextEditingController();

  void _submit() async {
    final yourName = yourNameController.text.trim();
    final crushName = crushNameController.text.trim();
    final creatorId = widget.creatorId;

    if (yourName.isEmpty || crushName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both names')),
      );
      return;
    }

    if (creatorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Creator ID is missing in the link')),
      );
      return;
    }
    final url = Uri.parse(
      'https://backend-production-9731.up.railway.app/api/entry/submit',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'your_name': yourName,
        'crush_name': crushName,
        'creator_id': creatorId,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pushNamed(
        context,
        '/result',
        arguments: {
          'yourName': yourName,
          'crushName': crushName,
          'creatorName': 'Your Friend', // Optional
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${jsonDecode(response.body)['error']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crush Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: yourNameController,
              decoration: const InputDecoration(labelText: 'Your Name'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: crushNameController,
              decoration: const InputDecoration(labelText: "Crush's Name"),
            ),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: _submit, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
