import 'package:flutter/material.dart';

class DinkaHeader extends StatelessWidget {
  const DinkaHeader({
    super.key,
    required this.onMenuPressed,
  });

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0C63D6),
      padding: const EdgeInsets.only(top: 8, left: 6, right: 12, bottom: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: onMenuPressed,
              icon: const Icon(Icons.menu, color: Colors.white),
            ),
            const Expanded(
              child: Text(
                'DINKA - ENGLISH DICTIONARY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            const Text('🇸🇸', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
