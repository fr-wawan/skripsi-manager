import 'package:uuid/uuid.dart';
import '../../../core/error/failure.dart';
import '../../skripsi/datasource/skripsi_datasource.dart';
import '../datasource/bimbingan_datasource.dart';
import '../models/bimbingan.dart';

class BimbinganUsecases {
  final BimbinganDatasource _datasource;
  final SkripsiDatasource _skripsiDatasource;
  final _uuid = const Uuid();

  BimbinganUsecases(this._datasource, this._skripsiDatasource);

  List<Bimbingan> getBySkripsiId(String skripsiId) =>
      _datasource.getBySkripsiId(skripsiId);

  Bimbingan add({
    required String skripsiId,
    required DateTime tanggal,
    required String catatan,
  }) {
    if (_skripsiDatasource.getById(skripsiId) == null) {
      throw const NotFoundFailure('Skripsi tidak ditemukan');
    }

    if (catatan.trim().isEmpty) {
      throw const ValidationFailure('Catatan tidak boleh kosong');
    }

    final bimbingan = Bimbingan(
      id: _uuid.v4(),
      tanggal: tanggal,
      catatan: catatan.trim(),
      skripsiId: skripsiId,
      createdAt: DateTime.now(),
    );

    _datasource.insert(bimbingan);
    return bimbingan;
  }

  Bimbingan update({
    required String id,
    required DateTime tanggal,
    required String catatan,
  }) {
    final existing = _datasource.getById(id);

    if (existing == null) {
      throw const NotFoundFailure('Bimbingan tidak ditemukan');
    }

    if (catatan.trim().isEmpty) {
      throw const ValidationFailure('Catatan tidak boleh kosong');
    }

    final updated = Bimbingan(
      id: existing.id,
      tanggal: tanggal,
      catatan: catatan.trim(),
      skripsiId: existing.skripsiId,
      createdAt: existing.createdAt,
    );

    _datasource.update(updated);
    return updated;
  }
}
