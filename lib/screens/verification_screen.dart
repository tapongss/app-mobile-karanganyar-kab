import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import '../data/auth_service.dart';
import '../theme/app_theme.dart';
import 'home_shell.dart';

class VerificationScreen extends StatefulWidget {
  final AuthChallenge challenge;
  const VerificationScreen({super.key, required this.challenge});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _input = TextEditingController();
  late String _code = widget.challenge.code;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _verify() {
    final value = _input.text.trim();
    if (value.length != 6) {
      setState(() => _error = 'Masukkan 6 digit kode verifikasi.');
      return;
    }
    if (value != _code) {
      setState(() => _error = 'Kode verifikasi salah. Periksa kembali email Anda.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    AppSettings.setSession(widget.challenge.account);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (route) => false,
    );
  }

  void _resend() {
    setState(() {
      _code = AuthService.generateCode();
      _input.clear();
      _error = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode baru dikirim ke ${widget.challenge.account.email}.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final account = widget.challenge.account;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Verifikasi Email'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        children: [
          Center(
            child: Container(
              height: 88,
              width: 88,
              decoration: BoxDecoration(
                color: AppColors.orangeSoft,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.orange.withValues(alpha: 0.25),
                  width: 6,
                ),
              ),
              child: const Icon(Icons.mark_email_read_outlined,
                  color: AppColors.orangeDeep, size: 38),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Cek email Anda',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: cs.onSurfaceVariant,
              ),
              children: [
                const TextSpan(text: 'Kami mengirim kode verifikasi 6 digit ke\n'),
                TextSpan(
                  text: account.email,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.orangeDeep,
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          TextField(
            controller: _input,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 12,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '••••••',
              hintStyle: TextStyle(
                fontSize: 26,
                letterSpacing: 12,
                color: cs.onSurfaceVariant.withValues(alpha: 0.4),
              ),
              errorText: _error,
            ),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
            onSubmitted: (_) => _verify(),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.peach,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.orange.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.science_outlined,
                    color: AppColors.orangeDeep, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mode demo — tanpa server email',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.orangeDeep,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Gunakan kode: $_code',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _input.text = _code;
                    setState(() => _error = null);
                  },
                  child: const Text('Isi'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _loading ? null : _verify,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Verifikasi & Masuk'),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _loading ? null : _resend,
            child: const Text('Kirim ulang kode'),
          ),
          const SizedBox(height: 4),
          Text(
            widget.challenge.isRegistration
                ? 'Akun ${account.username} berhasil dibuat. Setelah verifikasi, Anda langsung masuk ke aplikasi.'
                : 'Masuk sebagai ${account.username}. Kode berlaku untuk sesi ini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.5,
              height: 1.5,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
