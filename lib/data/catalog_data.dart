import 'package:flutter/material.dart';

import '../models/models.dart';

// URL resmi (sumber: hasil wawancara Diskominfo).
const saktiUrl = 'https://sakti.karanganyarkab.go.id/';
const portalUrl = 'https://www.karanganyarkab.go.id/';
const daftarLayananUrl =
    'https://www.karanganyarkab.go.id/daftar-layanan-publik-perangkat-daerah-kabupaten-karanganyar/';
const ppidUrl = 'https://ppid.karanganyarkab.go.id/';

// TODO: ganti url layanan bertanda saktiUrl dengan URL resmi masing-masing
// aplikasi setelah dikonfirmasi ke Diskominfo.
// TODO: lengkapi `requirements` dan `steps` dari OPD terkait (data owner).
const services = <PublicService>[
  PublicService(
    id: 'paklay',
    name: 'Paklay Komplit',
    subtitle: 'Layanan administrasi kependudukan',
    opd: 'Disdukcapil',
    category: ServiceCategory.kependudukan,
    description:
        'Paklay Komplit Disdukcapil Karanganyar: layanan kependudukan dan pencatatan sipil secara daring.',
    url: 'https://paklay-komplit.disdukcapil.karanganyarkab.go.id/',
    keywords: ['ktp', 'kk', 'kartu keluarga', 'akta', 'kelahiran', 'pindah', 'kia'],
    popular: true,
  ),
  PublicService(
    id: 'simpel',
    name: 'SIMPEL',
    subtitle: 'Sistem Informasi Pelayanan Elektronik',
    opd: 'DPMPTSP',
    category: ServiceCategory.perizinan,
    description:
        'Layanan perizinan elektronik Kabupaten Karanganyar melalui Dinas Penanaman Modal dan Pelayanan Terpadu Satu Pintu.',
    url: 'https://simpel.karanganyarkab.go.id/',
    keywords: ['izin', 'usaha', 'imb', 'pbg', 'nib', 'umkm'],
    popular: true,
  ),
  PublicService(
    id: 'sapamas',
    name: 'SAPAMAS GESIT',
    subtitle: 'Aduan publik & aspirasi masyarakat',
    opd: 'Pemkab Karanganyar',
    category: ServiceCategory.pengaduan,
    description:
        'Sistem Aduan Publik dan Aspirasi Masyarakat Karanganyar. Sampaikan keluhan atau aspirasi Anda kepada pemerintah daerah.',
    url: saktiUrl,
    keywords: ['aduan', 'lapor', 'keluhan', 'aspirasi', 'jalan rusak'],
    popular: true,
  ),
  PublicService(
    id: 'pajak',
    name: 'Pajak & Retribusi Daerah',
    subtitle: 'Informasi layanan perpajakan daerah',
    opd: 'BKD',
    category: ServiceCategory.pajak,
    description:
        'Informasi layanan pajak dan retribusi daerah. Lihat daftar layanan publik resmi untuk kanal yang tersedia.',
    url: daftarLayananUrl,
    keywords: ['pajak', 'pbb', 'retribusi', 'bphtb', 'bkd'],
    popular: true,
  ),
  PublicService(
    id: 'kesehatan',
    name: 'Layanan Kesehatan',
    subtitle: 'Informasi layanan Dinas Kesehatan',
    opd: 'Dinkes',
    category: ServiceCategory.kesehatan,
    description:
        'Informasi layanan kesehatan masyarakat. Lihat daftar layanan publik resmi untuk kanal yang tersedia.',
    url: daftarLayananUrl,
    keywords: ['puskesmas', 'rumah sakit', 'bpjs', 'imunisasi', 'sehat'],
  ),
  PublicService(
    id: 'lareimud',
    name: 'LAREIMUD',
    subtitle: 'Layanan Reklame Informatif dan Mudah',
    opd: 'Pemkab Karanganyar',
    category: ServiceCategory.perizinan,
    description: 'Aplikasi layanan reklame informatif dan mudah.',
    url: saktiUrl,
    keywords: ['reklame', 'iklan', 'baliho'],
  ),
  PublicService(
    id: 'sambernyawa',
    name: 'Sambernyawa',
    subtitle: 'Computer Security Incident Response Team',
    opd: 'Diskominfo',
    category: ServiceCategory.pengaduan,
    description:
        'Pelaporan kerentanan dan celah keamanan platform *.karanganyarkab.go.id.',
    url: saktiUrl,
    keywords: ['keamanan', 'siber', 'csirt', 'hack', 'celah'],
  ),
  PublicService(
    id: 'apik',
    name: 'APIK',
    subtitle: 'Aplikasi Permohonan Informasi Karanganyar',
    opd: 'Diskominfo',
    category: ServiceCategory.pemerintahan,
    description: 'Ajukan permohonan informasi publik kepada Pemkab Karanganyar.',
    url: saktiUrl,
    keywords: ['informasi publik', 'ppid', 'permohonan'],
  ),
  PublicService(
    id: 'mantap',
    name: 'MANTAP',
    subtitle: 'Monitoring Aplikasi Terpadu Pemerintahan',
    opd: 'Diskominfo',
    category: ServiceCategory.pemerintahan,
    description: 'Monitoring aplikasi terpadu pemerintahan Karanganyar.',
    url: saktiUrl,
    keywords: ['monitoring', 'aplikasi'],
  ),
  PublicService(
    id: 'tamu',
    name: 'Tamu',
    subtitle: 'Kunjungan Kerja Pemerintah Kabupaten',
    opd: 'Pemkab Karanganyar',
    category: ServiceCategory.pemerintahan,
    description: 'Pendaftaran kunjungan kerja ke Pemerintah Kabupaten Karanganyar.',
    url: saktiUrl,
    keywords: ['kunjungan', 'studi banding', 'tamu'],
  ),
  PublicService(
    id: 'pengenkolakpete',
    name: 'Pengen Kolak Pete',
    subtitle: 'Kolaborasi dan inovasi layanan',
    opd: 'Pemkab Karanganyar',
    category: ServiceCategory.pemerintahan,
    description:
        'Layanan bantuan untuk memfasilitasi kolaborasi dan inovasi.',
    url: saktiUrl,
    keywords: ['inovasi', 'kolaborasi', 'bantuan'],
  ),
];

// TODO: tambahkan alamat/telepon resmi. Saat ini lokasi dicari lewat nama kantor.
const offices = <Office>[
  Office(name: 'Dinas Komunikasi dan Informatika', opd: 'Diskominfo', mapsQuery: 'Dinas Komunikasi dan Informatika Kabupaten Karanganyar'),
  Office(name: 'Dinas Kependudukan dan Pencatatan Sipil', opd: 'Disdukcapil', mapsQuery: 'Disdukcapil Kabupaten Karanganyar'),
  Office(name: 'Dinas Penanaman Modal dan PTSP', opd: 'DPMPTSP', mapsQuery: 'DPMPTSP Kabupaten Karanganyar'),
  Office(name: 'Dinas Kesehatan', opd: 'Dinkes', mapsQuery: 'Dinas Kesehatan Kabupaten Karanganyar'),
  Office(name: 'Badan Keuangan Daerah', opd: 'BKD', mapsQuery: 'Badan Keuangan Daerah Kabupaten Karanganyar'),
  Office(name: 'Satpol PP', opd: 'Satpol PP', mapsQuery: 'Satpol PP Kabupaten Karanganyar'),
  Office(name: 'BKPSDM', opd: 'BKPSDM', mapsQuery: 'BKPSDM Kabupaten Karanganyar'),
  Office(name: 'Bappeda', opd: 'Bappeda', mapsQuery: 'Bappeda Kabupaten Karanganyar'),
];

const newsItems = <NewsItem>[
  NewsItem(
    id: 'jambore-2026',
    category: 'Karanganyar',
    title:
        'Lepas Kontingen Jambore Nasional 2026, Ketua Kwarcab Karanganyar Tekankan Kedisiplinan',
    excerpt:
        'Sebanyak 32 anggota Pramuka perwakilan Kabupaten Karanganyar dilepas untuk mengikuti Jambore Nasional 2026.',
    date: '6 Agustus 2026',
    body:
        'Pemerintah Kabupaten Karanganyar melepas kontingen Gerakan Pramuka Kwartir Cabang Karanganyar untuk mengikuti Jambore Nasional 2026.',
    paragraphs: [
      'Kegiatan pelepasan berlangsung di halaman Pendopo Kabupaten Karanganyar dan dihadiri oleh jajaran Forkopimda, pengurus Kwarcab, serta orang tua peserta.',
      'Ketua Kwarcab Karanganyar menekankan pentingnya kedisiplinan, kemandirian, dan semangat kebersamaan selama mengikuti kegiatan di tingkat nasional.',
      'Kontingen Karanganyar terdiri atas 32 anggota penggalang dan penegak yang telah melalui seleksi di tingkat kecamatan.',
    ],
    accent: Color(0xFFFF7733),
  ),
  NewsItem(
    id: 'pasar-murah',
    category: 'Ekonomi',
    title: 'Kendalikan Inflasi, Pemkab Karanganyar Gelar Operasi Pasar Murah',
    excerpt:
        'Operasi pasar menyediakan beras, minyak, dan gula dengan harga di bawah pasar di 17 kecamatan.',
    date: '4 Agustus 2026',
    body:
        'Dalam rangka menjaga daya beli masyarakat, Pemkab Karanganyar menggelar operasi pasar murah secara bergilir.',
    paragraphs: [
      'Operasi pasar menyediakan komoditas pokok seperti beras, minyak goreng, gula pasir, dan telur dengan harga terjangkau.',
      'Kegiatan menyasar 17 kecamatan dengan prioritas wilayah yang memiliki angka inflasi tertinggi.',
      'Masyarakat diimbau membeli sesuai kebutuhan dan tidak melakukan penimbunan.',
    ],
    accent: Color(0xFF2FA36B),
  ),
  NewsItem(
    id: 'layak-anak',
    category: 'Prestasi',
    title: 'Karanganyar Raih Penghargaan Kabupaten Layak Anak Tahun 2026',
    excerpt:
        'Penghargaan diberikan atas komitmen pemenuhan hak anak dan penguatan layanan ramah anak.',
    date: '1 Agustus 2026',
    body:
        'Kabupaten Karanganyar kembali menerima penghargaan Kabupaten Layak Anak tingkat nasional.',
    paragraphs: [
      'Penilaian mencakup pemenuhan hak sipil, kesehatan, pendidikan, dan perlindungan khusus anak.',
      'Pemkab Karanganyar terus mendorong penguatan puskesmas ramah anak dan ruang bermain di ruang publik.',
      'Penghargaan menjadi motivasi untuk meningkatkan kualitas layanan bagi anak dan keluarga.',
    ],
    accent: Color(0xFF7A5AF8),
  ),
  NewsItem(
    id: 'sakti-digital',
    category: 'Pemerintahan',
    title: 'Perkuat Layanan Digital, SAKTI Karanganyar Terus Dikembangkan',
    excerpt:
        'Satu akun untuk semua layanan OPD, SAKTI hadir untuk mempermudah akses masyarakat.',
    date: '28 Juli 2026',
    body:
        'Diskominfo Karanganyar terus mengembangkan portal SAKTI sebagai gerbang layanan digital terpadu.',
    paragraphs: [
      'SAKTI memungkinkan masyarakat mengakses berbagai layanan perangkat daerah dengan satu akun.',
      'Pengembangan diarahkan pada integrasi data, kemudahan antarmuka, dan keamanan informasi.',
      'Masyarakat dapat memberikan masukan melalui kanal aduan resmi yang tersedia.',
    ],
    accent: Color(0xFF3D7BF7),
  ),
];

final agendaItems = <AgendaItem>[
  AgendaItem(
    id: 'rakorpim',
    title: 'Rapat Koordinasi Pimpinan Daerah',
    place: 'Pendopo Kabupaten Karanganyar',
    time: '08.00 WIB',
    date: DateTime(2026, 8, 10),
    description:
        'Rapat koordinasi pimpinan daerah membahas evaluasi program dan percepatan realisasi anggaran.',
  ),
  AgendaItem(
    id: 'musrenbang',
    title: 'Musrenbang Tingkat Kecamatan',
    place: 'Aula Kecamatan Jaten',
    time: '09.00 WIB',
    date: DateTime(2026, 8, 12),
    description:
        'Musyawarah perencanaan pembangunan untuk menjaring usulan prioritas masyarakat.',
  ),
  AgendaItem(
    id: 'kunjungan',
    title: 'Kunjungan Kerja Gubernur Jawa Tengah',
    place: 'Kantor Bupati Karanganyar',
    time: '10.30 WIB',
    date: DateTime(2026, 8, 18),
    description:
        'Kunjungan kerja dalam rangka monitoring pembangunan dan layanan publik.',
  ),
  AgendaItem(
    id: 'halal-bihalal',
    title: 'Silaturahmi Forkopimda & OPD',
    place: 'Pendopo Kabupaten Karanganyar',
    time: '13.00 WIB',
    date: DateTime(2026, 9, 2),
    description:
        'Silaturahmi bersama jajaran forkopimda, perangkat daerah, dan tokoh masyarakat.',
  ),
];

const portalItems = <PortalItem>[
  PortalItem(
    name: 'Dinas Komunikasi dan Informatika',
    description: 'Informasi publik & layanan keterbukaan informasi',
    category: PortalCategory.opd,
    url: portalUrl,
  ),
  PortalItem(
    name: 'Dinas Kependudukan dan Pencatatan Sipil',
    description: 'Administrasi kependudukan & pencatatan sipil',
    category: PortalCategory.opd,
    url: portalUrl,
  ),
  PortalItem(
    name: 'Dinas Penanaman Modal dan PTSP',
    description: 'Perizinan dan pelayanan terpadu satu pintu',
    category: PortalCategory.opd,
    url: portalUrl,
  ),
  PortalItem(
    name: 'Dinas Kesehatan',
    description: 'Informasi layanan kesehatan masyarakat',
    category: PortalCategory.opd,
    url: portalUrl,
  ),
  PortalItem(
    name: 'Dinas Pendidikan dan Kebudayaan',
    description: 'Layanan pendidikan dasar dan kebudayaan',
    category: PortalCategory.opd,
    url: portalUrl,
  ),
  PortalItem(
    name: 'Dinas Sosial',
    description: 'Bantuan sosial dan pemberdayaan masyarakat',
    category: PortalCategory.opd,
    url: portalUrl,
  ),
  PortalItem(
    name: 'Kecamatan Jaten',
    description: 'Layanan administrasi tingkat kecamatan',
    category: PortalCategory.kecamatan,
    url: portalUrl,
  ),
  PortalItem(
    name: 'Kecamatan Karanganyar',
    description: 'Layanan administrasi tingkat kecamatan',
    category: PortalCategory.kecamatan,
    url: portalUrl,
  ),
  PortalItem(
    name: 'Kecamatan Tawangmangu',
    description: 'Layanan administrasi tingkat kecamatan',
    category: PortalCategory.kecamatan,
    url: portalUrl,
  ),
  PortalItem(
    name: 'Kecamatan Colomadu',
    description: 'Layanan administrasi tingkat kecamatan',
    category: PortalCategory.kecamatan,
    url: portalUrl,
  ),
  PortalItem(
    name: 'Kelurahan Karanganyar',
    description: 'Layanan administrasi tingkat kelurahan',
    category: PortalCategory.kelurahan,
    url: portalUrl,
  ),
  PortalItem(
    name: 'Kelurahan Bejen',
    description: 'Layanan administrasi tingkat kelurahan',
    category: PortalCategory.kelurahan,
    url: portalUrl,
  ),
  PortalItem(
    name: 'Kelurahan Lalung',
    description: 'Layanan administrasi tingkat kelurahan',
    category: PortalCategory.kelurahan,
    url: portalUrl,
  ),
  PortalItem(
    name: 'Portal Resmi Pemkab Karanganyar',
    description: 'Berita, profil, dan informasi pemerintahan',
    category: PortalCategory.portal,
    url: portalUrl,
  ),
  PortalItem(
    name: 'SAKTI Karanganyar',
    description: 'Satu akun untuk semua layanan digital OPD',
    category: PortalCategory.portal,
    url: saktiUrl,
  ),
  PortalItem(
    name: 'PPID Karanganyar',
    description: 'Keterbukaan informasi publik',
    category: PortalCategory.portal,
    url: portalUrl,
  ),
];
