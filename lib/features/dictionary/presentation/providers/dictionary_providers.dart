import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/dictionary_repository.dart';
import '../../domain/dictionary_entry.dart';

final dictionaryRepositoryProvider = Provider<DictionaryRepository>((ref) {
  return const DictionaryRepository();
});

final dictionaryProvider = FutureProvider<List<DictionaryEntry>>((ref) async {
  final repo = ref.watch(dictionaryRepositoryProvider);
  return repo.loadEntries();
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final listScrollOffsetProvider = StateProvider<double>((ref) => 0);

final filteredEntriesProvider = Provider<AsyncValue<List<DictionaryEntry>>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final asyncEntries = ref.watch(dictionaryProvider);

  return asyncEntries.whenData((entries) {
    if (query.isEmpty) return entries;
    return entries.where((entry) {
      final wordMatch = entry.word.toLowerCase().contains(query);
      final keyMatch = entry.searchKey.toLowerCase().contains(query);
      return wordMatch || keyMatch;
    }).toList(growable: false);
  });
});

final currentIndexProvider = Provider.family<int?, int>((ref, entryId) {
  final entries = ref.watch(dictionaryProvider).valueOrNull;
  if (entries == null) return null;
  final index = entries.indexWhere((element) => element.id == entryId);
  return index >= 0 ? index : null;
});
