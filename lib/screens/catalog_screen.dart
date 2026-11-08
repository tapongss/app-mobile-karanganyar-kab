import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/service_tile.dart';

class CatalogScreen extends StatefulWidget {
  final List<PublicService> services;
  final ValueNotifier<ServiceCategory?> filter;

  const CatalogScreen({super.key, required this.services, required this.filter});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ServiceCategory?>(
      valueListenable: widget.filter,
      builder: (context, cat, _) {
        final q = _q.trim().toLowerCase();
        final items = widget.services.where((s) {
          if (cat != null && s.category != cat) return false;
          if (q.isEmpty) return true;
          return [s.name, s.subtitle, s.opd, ...s.keywords]
              .join(' ')
              .toLowerCase()
              .contains(q);
        }).toList();

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            GradientHeader(
              title: 'Layanan Publik',
              subtitle:
                  'Temukan layanan digital perangkat daerah Kabupaten Karanganyar.',
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _q = v),
                  style: const TextStyle(fontSize: 13.5),
                  decoration: const InputDecoration(
                    hintText: 'Cari layanan, mis. KTP, izin, aduan',
                    hintStyle:
                        TextStyle(color: AppColors.inkSoft, fontSize: 13),
                    prefixIcon: Icon(Icons.search_rounded,
                        color: AppColors.inkSoft, size: 21),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('Semua'),
                      selected: cat == null,
                      onSelected: (_) => widget.filter.value = null,
                    ),
                  ),
                  for (final c in ServiceCategory.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(c.label),
                        selected: cat == c,
                        onSelected: (_) => widget.filter.value = c,
                      ),
                    ),
                ],
              ),
            ),
            if (items.isEmpty)
              const EmptyState(
                icon: Icons.search_off_rounded,
                title: 'Layanan tidak ditemukan',
                subtitle: 'Coba kata kunci atau kategori lain.',
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
                child: Column(
                  children: [
                    for (var i = 0; i < items.length; i++) ...[
                      if (i > 0) const SizedBox(height: 10),
                      ServiceTile(service: items[i]),
                    ],
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
