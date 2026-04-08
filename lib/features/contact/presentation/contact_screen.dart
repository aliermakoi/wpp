import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              _ContactRow(label: 'Email', value: 'support@dinkadictionary.app'),
              _ContactRow(label: 'Phone', value: '+211 900 000 000'),
              _ContactRow(label: 'Address', value: 'Juba, South Sudan'),
              _ContactRow(label: 'Website', value: 'https://dinkadictionary.app'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}
