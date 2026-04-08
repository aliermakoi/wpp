import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../dictionary/domain/dictionary_entry.dart';
import '../../dictionary/presentation/providers/dictionary_providers.dart';

class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({super.key, required this.entryId});

  final int entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(dictionaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Details'),
      ),
      body: entriesAsync.when(
        data: (entries) {
          final index = entries.indexWhere((element) => element.id == entryId);
          if (index == -1) {
            return const Center(child: Text('Entry not found.'));
          }
          final entry = entries[index];
          return _DetailsBody(entry: entry, entries: entries, currentIndex: index);
        },
        error: (error, _) => Center(child: Text('Unable to open entry: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({
    required this.entry,
    required this.entries,
    required this.currentIndex,
  });

  final DictionaryEntry entry;
  final List<DictionaryEntry> entries;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final previous = currentIndex > 0 ? entries[currentIndex - 1] : null;
    final next = currentIndex < entries.length - 1 ? entries[currentIndex + 1] : null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.word, style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 12),
                      _FieldBlock(title: 'Definition', value: entry.definition),
                      _FieldBlock(title: 'Examples', value: entry.examples),
                      _FieldBlock(title: 'Part of Speech', value: entry.partOfSpeech),
                      _FieldBlock(title: 'Synonyms', value: entry.synonyms),
                      _FieldBlock(title: 'Dialect Notes', value: entry.dialects),
                      _FieldBlock(title: 'Raw Entry', value: entry.rawEntry),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: previous == null
                      ? null
                      : () => context.pushReplacement('/details/${previous.id}'),
                  icon: const Icon(Icons.chevron_left),
                  label: const Text('Previous'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: next == null ? null : () => context.pushReplacement('/details/${next.id}'),
                  icon: const Icon(Icons.chevron_right),
                  label: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FieldBlock extends StatelessWidget {
  const _FieldBlock({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value.isEmpty ? '—' : value),
        ],
      ),
    );
  }
}
