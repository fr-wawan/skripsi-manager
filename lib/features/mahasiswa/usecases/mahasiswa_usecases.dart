import 'package:uuid/uuid.dart';
import '../../../core/error/failure.dart';
import '../datasource/mahasiswa_datasource.dart';
import '../models/mahasiswa.dart';

class MahasiswaUsecases {
  final MahasiswaDatasource _datasource;
  final _uuid = const Uuid();

  MahasiswaUsecases(this._datasource);

  List<Mahasiswa> getAll() => _datasource.getAll();

  Mahasiswa add({
    required String nim,
    required String nama,
    required String jurusan,
    required String email,
  }) {
    if (nim.trim().isEmpty || nama.trim().isEmpty) {
      throw const ValidationFailure('NIM dan nama tidak boleh kosong');
    }

    if (_datasource.getByNim(nim) != null) {
      throw ValidationFailure('NIM $nim sudah terdaftar');
    }

    final mahasiswa = Mahasiswa(
      id: _uuid.v4(),
      nim: nim.trim(),
      nama: nama.trim(),
      jurusan: jurusan.trim(),
      email: email.trim(),
      createdAt: DateTime.now(),
    );

    _datasource.insert(mahasiswa);
    return mahasiswa;
  }

  Mahasiswa update({
    required String id,
    required String nim,
    required String nama,
    required String jurusan,
    required String email,
  }) {
    final existing = getOrThrow(id);

    // Cek NIM duplicate, kecuali NIM milik sendiri
    final byNim = _datasource.getByNim(nim);
    if (byNim != null && byNim.id != id) {
      throw ValidationFailure('NIM $nim sudah dipakai mahasiswa lain');
    }

    final updated = Mahasiswa(
      id: existing.id,
      nim: nim.trim(),
      nama: nama.trim(),
      jurusan: jurusan.trim(),
      email: email.trim(),
      createdAt: existing.createdAt,
    );

    _datasource.update(updated);
    return updated;
  }

  Mahasiswa getOrThrow(String id) {
    final mahasiswa = _datasource.getById(id);

    if (mahasiswa == null) {
      throw NotFoundFailure('Mahasiswa dengan ID $id tidak ditemukan');
    }

    return mahasiswa;
  }

  void delete(String id) {
    final mahasiswa = getOrThrow(id);
    _datasource.delete(mahasiswa.id);
  }
}
