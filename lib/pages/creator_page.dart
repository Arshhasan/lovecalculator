import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http show post;

class CreatorPage extends StatefulWidget {
  const CreatorPage({super.key});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  final TextEditingController creatorNameController = TextEditingController();
  bool _isRegistered = false;

  // Mock creator ID and entries after registration
  int? creatorId;
  String? creatorName;

  // Mock data: list of crush entries
  final List<Map<String, String>> crushEntries = [
    {'friend': 'John', 'crush': 'Lisa', 'submittedAt': '2025-06-04 18:23'},
    {'friend': 'Maria', 'crush': 'Jake', 'submittedAt': '2025-06-04 18:31'},
    // Add more if needed
  ];

  void _register() async {
    final name = creatorNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name')));
      return;
    }

    final url = Uri.parse('http://localhost:3000/api/creator/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      setState(() {
        creatorName = data['name'];
        creatorId = data['id'];
        _isRegistered = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${jsonDecode(response.body)['error']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isRegistered) {
      // Show registration form
      return Scaffold(
        appBar: AppBar(title: const Text('Creator Registration')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: creatorNameController,
                decoration: const InputDecoration(labelText: 'Enter your name'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      );
    } else {
      // Show creator dashboard with table and share link
      return Scaffold(
        appBar: AppBar(title: const Text('Creator Dashboard')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $creatorName!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Share this link with your friends:',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SelectableText(
                'https://yourapp.com/?creator_id=$creatorId',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Friends and their crushes:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: crushEntries.length,
                  itemBuilder: (context, index) {
                    final entry = crushEntries[index];
                    return ListTile(
                      title: Text(entry['friend'] ?? ''),
                      subtitle: Text('Crush: ${entry['crush']}'),
                      trailing: Text(entry['submittedAt'] ?? ''),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
