import 'package:flutter/material.dart';

import '../app_state.dart';
import '../data/catalog_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _faq = <(String, String)>[
    (
      'Apa itu SAKTI?',
      'Portal Single Sign-On Pemkab Karanganyar: satu akun untuk masuk ke berbagai layanan OPD.'
    ),
    (
      'Bagaimana cara mengajukan layanan?',
      'Pilih layanan di menu Layanan, lalu tekan "Buka layanan resmi" dan ikuti prosedur pada situs OPD terkait.'
    ),
    (
      'Layanan tidak bisa dibuka?',
      'Server mungkin sedang pemeliharaan atau jaringan lemah. Coba lagi beberapa saat kemudian.'
    ),
  ];

  Future<void> _signOut(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Keluar aplikasi?'),
        content: const Text(
            'Anda dapat masuk kembali kapan saja dengan mengisi nama.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(minimumSize: const Size(100, 44)),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    AppSettings.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showAccountSheet(BuildContext context) {
    final account = AppSettings.currentAccount.value;
    if (account == null) return;
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
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
                    color: Theme.of(ctx).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Data akun',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Informasi yang Anda daftarkan.',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              _DetailRow(label: 'Nama lengkap', value: account.fullName),
              _DetailRow(label: 'Username', value: account.username),
              _DetailRow(label: 'Email', value: account.email),
              _DetailRow(label: 'No. HP', value: account.phone),
              _DetailRow(
                label: 'Tanggal lahir',
                value:
                    '${account.birthDate.day} ${months[account.birthDate.month - 1]} ${account.birthDate.year}',
              ),
              _DetailRow(label: 'Alamat lengkap', value: account.address),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const _ProfileHeader(),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _card(
                context,
                Column(
                  children: [
                    _MenuTile(
                      icon: Icons.badge_outlined,
                      title: 'Data akun',
                      subtitle: 'Nama, email, no. HP, dan alamat',
                      onTap: () => _showAccountSheet(context),
                    ),
                    _divider(cs),
                    _MenuTile(
                      icon: Icons.account_balance_outlined,
                      title: 'Perangkat Daerah',
                      subtitle: 'Daftar OPD & lokasi kantor',
                      onTap: () => openMaps(
                          context, 'Pemerintah Kabupaten Karanganyar'),
                    ),
                    _divider(cs),
                    _MenuTile(
                      icon: Icons.folder_shared_outlined,
                      title: 'PPID Karanganyar',
                      subtitle: 'Keterbukaan informasi publik',
                      onTap: () => openUrl(context, ppidUrl),
                    ),
                    _divider(cs),
                    _MenuTile(
                      icon: Icons.public_rounded,
                      title: 'Portal resmi Pemkab',
                      subtitle: 'Berita dan profil pemerintahan',
                      onTap: () => openUrl(context, portalUrl),
                    ),
                    _divider(cs),
                    const _MenuTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Pusat bantuan',
                      subtitle: 'Pertanyaan yang sering diajukan',
                      showChevron: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Aksesibilitas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              _card(
                context,
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    children: [
                      ValueListenableBuilder<double>(
                        valueListenable: AppSettings.textScale,
                        builder: (_, v, __) => Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.text_fields_rounded,
                                    size: 19, color: AppColors.orange),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Ukuran teks',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${(v * 100).round()}%',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.orangeDeep,
                                  ),
                                ),
                              ],
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: AppColors.orange,
                                thumbColor: AppColors.orange,
                                overlayColor:
                                    AppColors.orange.withValues(alpha: 0.12),
                                trackHeight: 3,
                              ),
                              child: Slider(
                                value: v,
                                min: 0.85,
                                max: 1.5,
                                divisions: 13,
                                label: '${(v * 100).round()}%',
                                onChanged: (x) =>
                                    AppSettings.textScale.value = x,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: cs.outlineVariant),
                      ValueListenableBuilder<ThemeMode>(
                        valueListenable: AppSettings.themeMode,
                        builder: (_, m, __) => SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          secondary: const Icon(Icons.dark_mode_outlined,
                              size: 19, color: AppColors.orange),
                          title: const Text(
                            'Mode gelap',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          value: m == ThemeMode.dark,
                          activeThumbColor: AppColors.orange,
                          onChanged: (on) => AppSettings.themeMode.value =
                              on ? ThemeMode.dark : ThemeMode.light,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pertanyaan umum',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              _card(
                context,
                Column(
                  children: [
                    for (var i = 0; i < _faq.length; i++) ...[
                      if (i > 0) _divider(cs),
                      ExpansionTile(
                        tilePadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        childrenPadding:
                            const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        expandedAlignment: Alignment.centerLeft,
                        shape: const Border(),
                        collapsedShape: const Border(),
                        iconColor: AppColors.orange,
                        title: Text(
                          _faq[i].$1,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        children: [
                          Text(
                            _faq[i].$2,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.55,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => _signOut(context),
                icon: const Icon(Icons.logout_rounded, size: 19),
                label: const Text('Keluar aplikasi'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE04545),
                  side: const BorderSide(color: Color(0xFFF0C4C4)),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Karanganyar Kab v0.1.0',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Dikembangkan untuk Diskominfo Kab. Karanganyar',
                      textAlign: TextAlign.center,
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
        ),
      ],
    );
  }

  Widget _card(BuildContext context, Widget child) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: child,
    );
  }

  Widget _divider(ColorScheme cs) =>
      Divider(height: 1, color: cs.outlineVariant);
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 62,
                    width: 62,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: AppColors.orange, size: 34),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder<String>(
                          valueListenable: AppSettings.userName,
                          builder: (_, name, __) => Text(
                            name.trim().isEmpty ? 'Warga Karanganyar' : name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        ValueListenableBuilder<UserAccount?>(
                          valueListenable: AppSettings.currentAccount,
                          builder: (_, account, __) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              account == null
                                  ? 'Warga Karanganyar'
                                  : '@${account.username}  •  ${account.email}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _stat('0', 'Aduan aktif'),
                  const SizedBox(width: 10),
                  _stat('0', 'Layanan tersimpan'),
                  const SizedBox(width: 10),
                  _stat('1', 'Tahun bersama'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.82),
                fontSize: 9.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showChevron;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.orangeSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.orangeDeep, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (showChevron)
              Icon(Icons.chevron_right_rounded,
                  size: 20, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
