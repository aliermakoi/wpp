import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dinka_english_dictionary/features/dictionary/data/dictionary_repository.dart';
import 'package:dinka_english_dictionary/features/dictionary/presentation/providers/dictionary_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sampleJson = '''
[
  {"id":1,"word":"yɛ̈n","definition":"we","examples":"","partOfSpeech":"pronoun","synonyms":"","dialects":"","searchKey":"yen","rawEntry":""},
  {"id":2,"word":"ŋɔ̈k","definition":"cow","examples":"","partOfSpeech":"noun","synonyms":"","dialects":"","searchKey":"ngok","rawEntry":""}
]
''';

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (message) async {
        final key = utf8.decode(message!.buffer.asUint8List());
        if (key == 'assets/data/dictionary.json') {
          return const StandardMethodCodec().encodeSuccessEnvelope(sampleJson);
        }
        return null;
      },
    );
  });

  test('data loading returns entries', () async {
    final repo = DictionaryRepository();
    final data = await repo.loadEntries();
    expect(data.length, 2);
    expect(data.first.word, 'yɛ̈n');
  });

  test('search filters by word and searchKey', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(dictionaryProvider.future);

    container.read(searchQueryProvider.notifier).state = 'ŋɔ';
    final byWord = container.read(filteredEntriesProvider).value!;
    expect(byWord.length, 1);

    container.read(searchQueryProvider.notifier).state = 'yen';
    final byKey = container.read(filteredEntriesProvider).value!;
    expect(byKey.single.word, 'yɛ̈n');
  });

  test('word switching indexes are computed', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(dictionaryProvider.future);
    expect(container.read(currentIndexProvider(1)), 0);
    expect(container.read(currentIndexProvider(2)), 1);
  });
}
