import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'This application provides a searchable Dinka-English dictionary for learners and researchers. It allows users to browse words, search quickly, and read meanings from the original source.',
              style: TextStyle(fontSize: 16, height: 1.45),
            ),
          ),
        ),
      ),
    );
  }
}
