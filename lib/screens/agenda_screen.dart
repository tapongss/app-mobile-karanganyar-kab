import 'package:flutter/material.dart';

import '../data/catalog_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/news_card.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  static const _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  void _showDetail(BuildContext context, AgendaItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _AgendaSheet(item: item, months: _months),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<AgendaItem>>{};
    for (final a in agendaItems) {
      final key = '${_months[a.date.month - 1]} ${a.date.year}';
      groups.putIfAbsent(key, () => []).add(a);
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const GradientHeader(
          title: 'Agenda Daerah',
          subtitle:
              'Jadwal kegiatan pimpinan dan perangkat daerah Kabupaten Karanganyar.',
        ),
        for (final entry in groups.entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
            child: Row(
              children: [
                Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                for (var i = 0; i < entry.value.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  AgendaCard(
                    item: entry.value[i],
                    onTap: () => _showDetail(context, entry.value[i]),
                  ),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 32),
      ],
    );
  }
}

class _AgendaSheet extends StatelessWidget {
  final AgendaItem item;
  final List<String> months;

  const _AgendaSheet({required this.item, required this.months});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 42,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.orangeSoft,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                '${item.date.day} ${months[item.date.month - 1]} ${item.date.year}',
                style: const TextStyle(
                  color: AppColors.orangeDeep,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 21,
                height: 1.3,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 16),
            _row(cs, Icons.schedule_rounded, item.time),
            const SizedBox(height: 10),
            _row(cs, Icons.place_outlined, item.place),
            const SizedBox(height: 18),
            Text(
              item.description,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.6,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Agenda ditambahkan ke pengingat.'),
                  ),
                );
              },
              icon: const Icon(Icons.notifications_active_outlined, size: 19),
              label: const Text('Ingatkan saya'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(ColorScheme cs, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.orange),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
