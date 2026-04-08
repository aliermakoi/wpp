import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/dinka_header.dart';
import '../../dictionary/domain/dictionary_entry.dart';
import '../../dictionary/presentation/providers/dictionary_providers.dart';
import '../../dictionary/presentation/widgets/word_list_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final initialOffset = ref.read(listScrollOffsetProvider);
    _scrollController = ScrollController(initialScrollOffset: initialOffset)
      ..addListener(() {
        ref.read(listScrollOffsetProvider.notifier).state = _scrollController.offset;
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openDetails(DictionaryEntry entry) {
    context.push('/details/${entry.id}');
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = ref.watch(filteredEntriesProvider);

    return Scaffold(
      drawer: _buildDrawer(context),
      body: CustomScrollView(
        key: const PageStorageKey<String>('home-scroll'),
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _HeaderDelegate(
              child: Builder(
                builder: (context) => DinkaHeader(
                  onMenuPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _HeaderDelegate(
              minHeight: 76,
              maxHeight: 76,
              child: Container(
                color: const Color(0xFFF5F8FE),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: TextField(
                  onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
                  decoration: const InputDecoration(
                    hintText: 'Search Dinka word…',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          filteredEntries.when(
            data: (entries) => SliverList.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return WordListItem(
                  entry: entry,
                  onTap: () => _openDetails(entry),
                );
              },
            ),
            error: (error, _) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('Failed to load dictionary: $error')),
            ),
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        ),
        child: const Icon(Icons.vertical_align_top),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0C63D6)),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Dictionary Menu',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => context.go('/'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () => context.push('/about'),
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail_outlined),
            title: const Text('Contact Us'),
            onTap: () => context.push('/contact'),
          ),
          ListTile(
            leading: const Icon(Icons.star_border),
            title: const Text('Rate Us'),
            onTap: () => context.push('/rate-us'),
          ),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('Share'),
            onTap: () => context.push('/share'),
          ),
        ],
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate({required this.child, this.minHeight = 78, this.maxHeight = 78});

  final Widget child;
  final double minHeight;
  final double maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight;
  }
}
