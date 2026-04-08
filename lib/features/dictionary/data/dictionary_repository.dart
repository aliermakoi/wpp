import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/dictionary_entry.dart';

class DictionaryRepository {
  const DictionaryRepository();

  Future<List<DictionaryEntry>> loadEntries() async {
    final raw = await rootBundle.loadString('assets/data/dictionary.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .cast<Map<String, dynamic>>()
        .map(DictionaryEntry.fromJson)
        .toList(growable: false);
  }
}
