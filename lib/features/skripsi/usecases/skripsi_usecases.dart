import 'package:uuid/uuid.dart';
import '../../../core/error/failure.dart';
import '../../mahasiswa/datasource/mahasiswa_datasource.dart';
import '../datasource/skripsi_datasource.dart';
import '../models/skripsi.dart';

class SkripsiUsecases {
  final SkripsiDatasource _datasource;
  final MahasiswaDatasource _mahasiswaDatasource;
  final _uuid = const Uuid();

  SkripsiUsecases(this._datasource, this._mahasiswaDatasource);

  List<Skripsi> getAll() => _datasource.getAll();

  Skripsi add({required String judul, required String mahasiswaId}) {
    if (judul.trim().isEmpty) {
      throw const ValidationFailure('Judul tidak boleh kosong');
    }

    if (_mahasiswaDatasource.getById(mahasiswaId) == null) {
      throw ValidationFailure('Mahasiswa tidak ditemukan');
    }

    final skripsi = Skripsi(
      id: _uuid.v4(),
      judul: judul.trim(),
      status: StatusSkripsi.proposal,
      mahasiswaId: mahasiswaId,
      createdAt: DateTime.now(),
    );

    _datasource.insert(skripsi);

    return skripsi;
  }

  Skripsi updateStatus({required String id, required StatusSkripsi status}) {
    final skripsi = _datasource.getById(id);

    if (skripsi == null) throw const NotFoundFailure('Skripsi tidak ditemukan');

    final updated = skripsi.copyWith(status: status);

    _datasource.update(updated);

    return updated;
  }

  void delete(String id) {
    final skripsi = _datasource.getById(id);

    if (skripsi == null) throw const NotFoundFailure('Skripsi tidak ditemukan');

    _datasource.delete(id);
  }
}
