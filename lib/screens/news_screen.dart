import 'package:flutter/material.dart';

import '../data/catalog_data.dart';
import '../widgets/common.dart';
import '../widgets/news_card.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String _category = 'Semua';

  List<String> get _categories {
    final set = <String>{'Semua'};
    for (final n in newsItems) {
      set.add(n.category);
    }
    return set.toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _category == 'Semua'
        ? newsItems
        : newsItems.where((n) => n.category == _category).toList();

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const GradientHeader(
          title: 'Berita Karanganyar',
          subtitle:
              'Ikuti kabar terbaru seputar pembangunan dan layanan publik di Kabupaten Karanganyar.',
        ),
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            children: [
              for (final c in _categories)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = c),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const EmptyState(
            icon: Icons.article_outlined,
            title: 'Belum ada berita',
            subtitle: 'Coba pilih kategori lain.',
          )
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  NewsListTile(
                    item: items[i],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NewsDetailScreen(item: items[i]),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
