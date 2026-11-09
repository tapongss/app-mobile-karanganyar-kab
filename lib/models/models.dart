import 'package:flutter/material.dart';

enum ServiceCategory {
  kependudukan,
  perizinan,
  kesehatan,
  pajak,
  pengaduan,
  pemerintahan,
}

extension ServiceCategoryX on ServiceCategory {
  String get label => switch (this) {
        ServiceCategory.kependudukan => 'Kependudukan',
        ServiceCategory.perizinan => 'Perizinan',
        ServiceCategory.kesehatan => 'Kesehatan',
        ServiceCategory.pajak => 'Pajak & Retribusi',
        ServiceCategory.pengaduan => 'Pengaduan',
        ServiceCategory.pemerintahan => 'Pemerintahan',
      };

  IconData get icon => switch (this) {
        ServiceCategory.kependudukan => Icons.badge_outlined,
        ServiceCategory.perizinan => Icons.assignment_turned_in_outlined,
        ServiceCategory.kesehatan => Icons.local_hospital_outlined,
        ServiceCategory.pajak => Icons.receipt_long_outlined,
        ServiceCategory.pengaduan => Icons.campaign_outlined,
        ServiceCategory.pemerintahan => Icons.account_balance_outlined,
      };
}

class PublicService {
  final String id;
  final String name;
  final String subtitle;
  final String opd;
  final ServiceCategory category;
  final String description;
  final String url;
  final List<String> keywords;
  final List<String> requirements;
  final List<String> steps;
  final bool popular;

  const PublicService({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.opd,
    required this.category,
    required this.description,
    required this.url,
    this.keywords = const [],
    this.requirements = const [],
    this.steps = const [],
    this.popular = false,
  });
}

class Office {
  final String name;
  final String opd;
  final String mapsQuery;
  final String? website;

  const Office({
    required this.name,
    required this.opd,
    required this.mapsQuery,
    this.website,
  });
}

class NewsItem {
  final String id;
  final String category;
  final String title;
  final String excerpt;
  final String date;
  final String body;
  final List<String> paragraphs;
  final Color accent;

  const NewsItem({
    required this.id,
    required this.category,
    required this.title,
    required this.excerpt,
    required this.date,
    required this.body,
    this.paragraphs = const [],
    this.accent = const Color(0xFFFF7733),
  });
}

class AgendaItem {
  final String id;
  final String title;
  final String place;
  final String time;
  final DateTime date;
  final String description;

  const AgendaItem({
    required this.id,
    required this.title,
    required this.place,
    required this.time,
    required this.date,
    required this.description,
  });
}

enum PortalCategory {
  opd,
  kecamatan,
  kelurahan,
  portal,
}

extension PortalCategoryX on PortalCategory {
  String get label => switch (this) {
        PortalCategory.opd => 'OPD',
        PortalCategory.kecamatan => 'Kecamatan',
        PortalCategory.kelurahan => 'Kelurahan',
        PortalCategory.portal => 'Portal',
      };
}

class PortalItem {
  final String name;
  final String description;
  final PortalCategory category;
  final String url;

  const PortalItem({
    required this.name,
    required this.description,
    required this.category,
    required this.url,
  });
}

class UserAccount {
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String address;
  final DateTime birthDate;
  final String password;

  const UserAccount({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    required this.birthDate,
    required this.password,
  });

  String get firstName {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? fullName : parts.first;
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'username': username,
        'email': email,
        'phone': phone,
        'address': address,
        'birthDate': birthDate.toIso8601String(),
        'password': password,
      };

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        fullName: json['fullName'] as String? ?? '',
        username: json['username'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        address: json['address'] as String? ?? '',
        birthDate: DateTime.tryParse(json['birthDate'] as String? ?? '') ??
            DateTime(2000, 1, 1),
        password: json['password'] as String? ?? '',
      );
}
