import 'package:flutter/material.dart';

import '../app_state.dart';
import '../data/catalog_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils.dart';
import '../widgets/common.dart';
import '../widgets/news_card.dart';
import '../widgets/portal_tile.dart';
import 'complaint_screen.dart';
import 'data_screen.dart';
import 'news_detail_screen.dart';
import 'offices_screen.dart';
import 'portal_screen.dart';
import 'search_delegate.dart';
import 'service_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<PublicService> services;
  final List<Office> offices;
  final ValueChanged<int> onNavigateTab;
  final void Function(ServiceCategory?) onCategory;

  const HomeScreen({
    super.key,
    required this.services,
    required this.offices,
    required this.onNavigateTab,
    required this.onCategory,
  });

  Future<void> _openSearch(BuildContext context) async {
    final result = await showSearch<Object?>(
      context: context,
      delegate: ServiceSearchDelegate(services),
    );
    if (!context.mounted || result == null) return;
    if (result is PublicService) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ServiceDetailScreen(service: result)),
      );
    } else if (result is NewsItem) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => NewsDetailScreen(item: result)),
      );
    }
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final popular = services.where((s) => s.popular).toList();

    return ColoredBox(
      color: cs.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _HomeHeader(
            onSearch: () => _openSearch(context),
            onNotification: () => _push(
              context,
              const _NotificationsScreen(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 4),
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 18,
                crossAxisSpacing: 6,
                mainAxisExtent: 100,
              ),
              children: [
                ServiceIconTile(
                  icon: Icons.person_outline_rounded,
                  label: 'Profil',
                  onTap: () => onNavigateTab(4),
                ),
                ServiceIconTile(
                  icon: Icons.account_balance_outlined,
                  label: 'Perangkat Daerah',
                  color: AppColors.blue,
                  onTap: () => _push(context, OfficesScreen(offices: offices)),
                ),
                ServiceIconTile(
                  icon: Icons.article_outlined,
                  label: 'Berita',
                  color: AppColors.green,
                  onTap: () => onNavigateTab(3),
                ),
                ServiceIconTile(
                  icon: Icons.folder_shared_outlined,
                  label: 'PPID',
                  color: AppColors.purple,
                  onTap: () => openUrl(context, ppidUrl),
                ),
                ServiceIconTile(
                  icon: Icons.grid_view_rounded,
                  label: 'Layanan Publik',
                  onTap: () => onCategory(null),
                ),
                ServiceIconTile(
                  icon: Icons.campaign_outlined,
                  label: 'Aduan Masyarakat',
                  color: AppColors.amber,
                  onTap: () => _push(context, const ComplaintScreen()),
                ),
                ServiceIconTile(
                  icon: Icons.bar_chart_rounded,
                  label: 'Data',
                  color: AppColors.green,
                  onTap: () => _push(context, const DataScreen()),
                ),
                ServiceIconTile(
                  icon: Icons.calendar_month_outlined,
                  label: 'Agenda Daerah',
                  color: AppColors.blue,
                  onTap: () => onNavigateTab(2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _ExploreBanner(onTap: () => openUrl(context, portalUrl)),
          SectionHeader(
            title: 'Berita Terbaru',
            actionLabel: 'Lihat semua',
            onAction: () => onNavigateTab(3),
          ),
          SizedBox(
            height: 232,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: newsItems.length.clamp(0, 5),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => NewsCard(
                item: newsItems[i],
                width: 244,
                compact: true,
                onTap: () => _push(
                  context,
                  NewsDetailScreen(item: newsItems[i]),
                ),
              ),
            ),
          ),
          SectionHeader(
            title: 'Agenda Pimpinan Daerah',
            actionLabel: 'Lihat semua',
            onAction: () => onNavigateTab(2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                for (var i = 0; i < agendaItems.length.clamp(0, 3); i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  AgendaCard(item: agendaItems[i]),
                ],
              ],
            ),
          ),
          const SectionHeader(title: 'Suara Masyarakat & Pemerintah'),
          _ComplaintCard(
            onTap: () => _push(context, const ComplaintScreen()),
          ),
          if (popular.isNotEmpty) ...[
            SectionHeader(
              title: 'Layanan Paling Dicari',
              actionLabel: 'Semua layanan',
              onAction: () => onCategory(null),
            ),
            SizedBox(
              height: 108,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: popular.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => _PopularServiceCard(
                  service: popular[i],
                  onTap: () => _push(
                    context,
                    ServiceDetailScreen(service: popular[i]),
                  ),
                ),
              ),
            ),
          ],
          const _PortalSection(),
          const SizedBox(height: 28),
          Center(
            child: Column(
              children: [
                const Icon(Icons.account_balance_rounded,
                    color: AppColors.orange, size: 22),
                const SizedBox(height: 8),
                Text(
                  'Pemerintah Kabupaten Karanganyar',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Sesarengan Mbangun Karanganyar',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onNotification;

  const _HomeHeader({required this.onSearch, required this.onNotification});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppColors.orange,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder<String>(
                          valueListenable: AppSettings.userName,
                          builder: (_, name, __) => Text(
                            'Halo, ${name.trim().isEmpty ? 'Warga' : name.trim().split(RegExp(r'\s+')).first}!',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Ada yang bisa kami bantu?',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Material(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: onNotification,
                          child: const Padding(
                            padding: EdgeInsets.all(11),
                            child: Icon(
                              Icons.notifications_none_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 9,
                        top: 8,
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE14D),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.orange,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onSearch,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded,
                            color: AppColors.inkSoft, size: 21),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Cari berita atau layanan',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                        Container(
                          height: 28,
                          width: 1,
                          color: const Color(0xFFE8E8EE),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.tune_rounded,
                            color: AppColors.orange, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _ExploreBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2B2B33), Color(0xFF16161A)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -28,
                  top: -34,
                  child: Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      color: AppColors.orange.withValues(alpha: 0.22),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: 26,
                  bottom: -30,
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SESARENGAN MBANGUN KARANGANYAR',
                            style: TextStyle(
                              color: AppColors.orange.withValues(alpha: 0.95),
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Jelajahi\nKaranganyar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              height: 1.12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Kunjungi portal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.arrow_outward_rounded,
                                    color: Colors.white, size: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.landscape_rounded,
                      size: 76,
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ComplaintCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.orangeSoft,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.forum_outlined,
                  color: AppColors.orangeDeep, size: 24),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Punya keluhan atau aspirasi?',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Sampaikan lewat SAPAMAS GESIT',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 38),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                textStyle: const TextStyle(
                    fontSize: 11.5, fontWeight: FontWeight.w700),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Tulis'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularServiceCard extends StatelessWidget {
  final PublicService service;
  final VoidCallback onTap;
  const _PopularServiceCard({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 196,
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: AppColors.orangeSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(service.category.icon,
                          size: 17, color: AppColors.orangeDeep),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        service.opd,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  service.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  service.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PortalSection extends StatefulWidget {
  const _PortalSection();

  @override
  State<_PortalSection> createState() => _PortalSectionState();
}

class _PortalSectionState extends State<_PortalSection> {
  PortalCategory _category = PortalCategory.opd;

  @override
  Widget build(BuildContext context) {
    final items =
        portalItems.where((p) => p.category == _category).take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Daftar Portal Kabupaten\nKaranganyar',
          actionLabel: 'Lihat semua',
          onAction: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PortalScreen()),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              for (final c in PortalCategory.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c.label),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = c),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                PortalTile(
                  item: items[i],
                  onTap: () => openUrl(context, items[i].url),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _NotificationsScreen extends StatelessWidget {
  const _NotificationsScreen();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Layanan selesai diproses', 'Permohonan Anda sedang diverifikasi OPD.', '2 jam lalu'),
      ('Agenda besok', 'Rapat Koordinasi Pimpinan Daerah pukul 08.00 WIB.', '5 jam lalu'),
      ('Berita baru', 'Operasi pasar murah digelar di 17 kecamatan.', '1 hari lalu'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final item = items[i];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: AppColors.orangeSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.notifications_active_outlined,
                      size: 19, color: AppColors.orangeDeep),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.$1,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13.5)),
                      const SizedBox(height: 3),
                      Text(item.$2,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          )),
                      const SizedBox(height: 5),
                      Text(item.$3,
                          style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.orange,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
