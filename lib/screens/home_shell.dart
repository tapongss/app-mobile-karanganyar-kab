import 'package:flutter/material.dart';

import '../data/service_repository.dart';
import '../models/models.dart';
import 'agenda_screen.dart';
import 'catalog_screen.dart';
import 'home_screen.dart';
import 'news_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final ServiceRepository _repo = LocalServiceRepository();
  final _filter = ValueNotifier<ServiceCategory?>(null);
  int _index = 0;
  List<PublicService>? _services;
  List<Office>? _offices;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final s = await _repo.getServices();
      final o = await _repo.getOffices();
      if (mounted) {
        setState(() {
          _services = s;
          _offices = o;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  void _select(int i) => setState(() => _index = i);

  void _goCatalog(ServiceCategory? c) {
    _filter.value = c;
    _select(1);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Gagal memuat data layanan.'),
            const SizedBox(height: 12),
            FilledButton(onPressed: _load, child: const Text('Coba lagi')),
          ]),
        ),
      );
    }
    if (_services == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final cs = Theme.of(context).colorScheme;
    final pages = [
      HomeScreen(
        services: _services!,
        offices: _offices ?? const [],
        onNavigateTab: _select,
        onCategory: _goCatalog,
      ),
      CatalogScreen(services: _services!, filter: _filter),
      const AgendaScreen(),
      const NewsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(top: BorderSide(color: cs.outlineVariant)),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _select,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded),
              label: 'Layanan',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_today_rounded),
              label: 'Agenda',
            ),
            NavigationDestination(
              icon: Icon(Icons.article_outlined),
              selectedIcon: Icon(Icons.article_rounded),
              label: 'Berita',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
