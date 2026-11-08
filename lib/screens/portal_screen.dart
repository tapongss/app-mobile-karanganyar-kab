import 'package:flutter/material.dart';

import '../data/catalog_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils.dart';
import '../widgets/portal_tile.dart';

class PortalScreen extends StatelessWidget {
  const PortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: PortalCategory.values.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text('Daftar Portal'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            labelColor: AppColors.orange,
            unselectedLabelColor: cs.onSurfaceVariant,
            indicatorColor: AppColors.orange,
            indicatorWeight: 2.5,
            labelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            unselectedLabelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            tabs: [
              for (final c in PortalCategory.values) Tab(text: c.label),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (final c in PortalCategory.values)
              _PortalList(
                items:
                    portalItems.where((p) => p.category == c).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _PortalList extends StatelessWidget {
  final List<PortalItem> items;
  const _PortalList({required this.items});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (items.isEmpty) {
      return const Center(child: Text('Belum ada portal.'));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        const Text(
          'Daftar Portal Kabupaten Karanganyar',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          'Akses kanal resmi perangkat daerah dan pemerintahan.',
          style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          PortalTile(
            item: items[i],
            onTap: () => openUrl(context, items[i].url),
          ),
        ],
        const SizedBox(height: 20),
        Text(
          'Portal resmi dikelola oleh Pemerintah Kabupaten Karanganyar.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10.5, color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}
