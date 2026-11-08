import '../models/models.dart';
import 'catalog_data.dart' as data;

/// Lapisan sumber data. Saat API Diskominfo disetujui, buat implementasi
/// `ApiServiceRepository` (dio) tanpa mengubah UI.
abstract class ServiceRepository {
  Future<List<PublicService>> getServices();
  Future<List<Office>> getOffices();
}

class LocalServiceRepository implements ServiceRepository {
  @override
  Future<List<PublicService>> getServices() async => data.services;

  @override
  Future<List<Office>> getOffices() async => data.offices;
}
