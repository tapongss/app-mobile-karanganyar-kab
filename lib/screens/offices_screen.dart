import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils.dart';
import '../widgets/common.dart';

class OfficesScreen extends StatefulWidget {
  final List<Office> offices;
  const OfficesScreen({super.key, required this.offices});

  @override
  State<OfficesScreen> createState() => _OfficesScreenState();
}

class _OfficesScreenState extends State<OfficesScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final q = _q.trim().toLowerCase();
    final items = widget.offices
        .where((o) =>
            q.isEmpty ||
            '${o.name} ${o.opd}'.toLowerCase().contains(q))
        .toList();

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GradientHeader(
          showBack: true,
          title: 'Perangkat Daerah',
          subtitle:
              'Temukan kantor dan layanan Organisasi Perangkat Daerah Kabupaten Karanganyar.',
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              onChanged: (v) => setState(() => _q = v),
              style: const TextStyle(fontSize: 13.5),
              decoration: const InputDecoration(
                hintText: 'Cari perangkat daerah',
                hintStyle: TextStyle(color: AppColors.inkSoft, fontSize: 13),
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
        if (items.isEmpty)
          const EmptyState(
            icon: Icons.search_off_rounded,
            title: 'Perangkat daerah tidak ditemukan',
            subtitle: 'Coba kata kunci lain.',
          )
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  Material(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => openMaps(context, items[i].mapsQuery),
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 46,
                              width: 46,
                              decoration: BoxDecoration(
                                color: AppColors.orangeSoft,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.account_balance_outlined,
                                  color: AppColors.orangeDeep, size: 23),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    items[i].name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    items[i].opd,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                color: AppColors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.directions_rounded,
                                      size: 14, color: AppColors.orangeDeep),
                                  SizedBox(width: 4),
                                  Text(
                                    'Peta',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.orangeDeep,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
