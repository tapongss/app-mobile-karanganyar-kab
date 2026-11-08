import 'package:flutter/material.dart';

import '../data/catalog_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/news_card.dart';
import '../widgets/service_tile.dart';

class ServiceSearchDelegate extends SearchDelegate<Object?> {
  final List<PublicService> services;

  ServiceSearchDelegate(this.services)
      : super(searchFieldLabel: 'Cari berita atau layanan');

  List<PublicService> _matchServices(String q) {
    final t = q.trim().toLowerCase();
    if (t.isEmpty) return [];
    return services.where((s) {
      final hay = [
        s.name,
        s.subtitle,
        s.opd,
        s.description,
        s.category.label,
        ...s.keywords,
      ].join(' ').toLowerCase();
      return t.split(RegExp(r'\s+')).every(hay.contains);
    }).toList();
  }

  List<NewsItem> _matchNews(String q) {
    final t = q.trim().toLowerCase();
    if (t.isEmpty) return [];
    return newsItems.where((n) {
      final hay = [n.title, n.excerpt, n.category, n.body, ...n.paragraphs]
          .join(' ')
          .toLowerCase();
      return t.split(RegExp(r'\s+')).every(hay.contains);
    }).toList();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70, fontSize: 15),
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.close_rounded),
            color: Colors.white,
            onPressed: () => query = '',
          ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        color: Colors.white,
        onPressed: () => close(context, null),
      );

  Widget _header(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 10),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      );

  @override
  Widget buildResults(BuildContext context) {
    final s = _matchServices(query);
    final n = _matchNews(query);
    if (s.isEmpty && n.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 42, color: AppColors.orange),
              SizedBox(height: 12),
              Text(
                'Tidak ada hasil',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 4),
              Text(
                'Coba kata kunci lain, misalnya "KTP" atau "berita".',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        if (s.isNotEmpty) ...[
          _header(context, 'LAYANAN'),
          for (var i = 0; i < s.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            ServiceTile(service: s[i]),
          ],
        ],
        if (n.isNotEmpty) ...[
          _header(context, 'BERITA'),
          for (var i = 0; i < n.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            NewsListTile(item: n[i], onTap: () => close(context, n[i])),
          ],
        ],
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      final popular = services.where((s) => s.popular).toList();
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          _header(context, 'SARAN PENCARIAN'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final term in const ['KTP', 'Izin usaha', 'Aduan', 'Kesehatan'])
                ActionChip(
                  label: Text(term),
                  onPressed: () => query = term,
                ),
            ],
          ),
          _header(context, 'LAYANAN POPULER'),
          for (var i = 0; i < popular.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            ServiceTile(service: popular[i]),
          ],
          _header(context, 'BERITA TERBARU'),
          for (var i = 0; i < newsItems.length && i < 3; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            NewsListTile(
              item: newsItems[i],
              onTap: () => close(context, newsItems[i]),
            ),
          ],
        ],
      );
    }
    return buildResults(context);
  }
}
