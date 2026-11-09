import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _birth = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  DateTime? _birthDate;
  bool _obscure = true;
  bool _terms = false;
  bool _submitting = false;
  String? _error;

  static const _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  @override
  void dispose() {
    _fullName.dispose();
    _username.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    _birth.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    FocusScope.of(context).unfocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1945),
      lastDate: DateTime.now(),
      helpText: 'Pilih tanggal lahir',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.orange,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _birth.text =
            '${picked.day} ${_months[picked.month - 1]} ${picked.year}';
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_terms) {
      setState(() =>
          _error = 'Centang persetujuan syarat & ketentuan untuk melanjutkan.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    FocusScope.of(context).unfocus();
    try {
      final challenge = await AuthService.register(
        fullName: _fullName.text,
        username: _username.text,
        email: _email.text,
        phone: _phone.text,
        address: _address.text,
        birthDate: _birthDate!,
        password: _password.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => VerificationScreen(challenge: challenge),
        ),
      );
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) {
        setState(() =>
            _error = 'Registrasi gagal. Periksa koneksi lalu coba lagi.');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const GradientHeader(
            showBack: true,
            title: 'Buat Akun',
            subtitle:
                'Daftar sekali untuk mengakses seluruh layanan digital Kabupaten Karanganyar.',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data diri',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  const _FieldLabel('Nama lengkap'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fullName,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'Sesuai KTP',
                      prefixIcon: Icon(Icons.badge_outlined, size: 20),
                    ),
                    validator: (v) => (v == null || v.trim().length < 3)
                        ? 'Nama lengkap minimal 3 karakter.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  const _FieldLabel('Tanggal lahir'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _birth,
                    readOnly: true,
                    onTap: _pickBirthDate,
                    decoration: const InputDecoration(
                      hintText: 'Pilih tanggal lahir',
                      prefixIcon:
                          Icon(Icons.cake_outlined, size: 20),
                      suffixIcon: Icon(Icons.calendar_month_outlined, size: 20),
                    ),
                    validator: (_) => _birthDate == null
                        ? 'Tanggal lahir wajib diisi.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  const _FieldLabel('Alamat lengkap'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _address,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText:
                          'Jalan, RT/RW, desa/kelurahan, kecamatan, kabupaten',
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => (v == null || v.trim().length < 10)
                        ? 'Alamat lengkap minimal 10 karakter.'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Data akun',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  const _FieldLabel('Username'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _username,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'mis. budi_santoso',
                      prefixIcon: Icon(Icons.alternate_email_rounded, size: 20),
                    ),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return 'Username wajib diisi.';
                      if (!RegExp(r'^[a-zA-Z0-9_]{4,20}$').hasMatch(value)) {
                        return '4–20 karakter, hanya huruf, angka, dan garis bawah.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const _FieldLabel('Email'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'nama@email.com',
                      prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
                    ),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return 'Email wajib diisi.';
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(value)) {
                        return 'Format email tidak valid.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const _FieldLabel('No. HP'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      hintText: '08xxxxxxxxxx',
                      prefixIcon: Icon(Icons.phone_outlined, size: 20),
                    ),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return 'Nomor HP wajib diisi.';
                      if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                        return 'Nomor HP harus 10–15 digit angka.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const _FieldLabel('Kata sandi'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _password,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Minimal 8 karakter',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 8)
                        ? 'Kata sandi minimal 8 karakter.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  const _FieldLabel('Konfirmasi kata sandi'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirm,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                      hintText: 'Ulangi kata sandi',
                      prefixIcon: Icon(Icons.lock_reset_rounded, size: 20),
                    ),
                    validator: (v) => v != _password.text
                        ? 'Konfirmasi kata sandi tidak sama.'
                        : null,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _terms,
                          activeColor: AppColors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          onChanged: (v) => setState(() {
                            _terms = v ?? false;
                            if (_terms) _error = null;
                          }),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _terms = !_terms;
                            if (_terms) _error = null;
                          }),
                          child: Text(
                            'Saya menyetujui syarat & ketentuan serta kebijakan privasi Pemerintah Kabupaten Karanganyar.',
                            style: TextStyle(
                              fontSize: 11.5,
                              height: 1.5,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDECEC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              size: 18, color: Color(0xFFD33A3A)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFFD33A3A),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Daftar & Verifikasi Email'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: const Text('Sudah punya akun? Masuk'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
    );
  }
}
