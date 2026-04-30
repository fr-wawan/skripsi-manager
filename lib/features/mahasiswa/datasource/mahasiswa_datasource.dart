import 'package:sqlite3/sqlite3.dart';
import '../../../core/db/database.dart';
import '../models/mahasiswa.dart';

class MahasiswaDatasource {
  Database get _db => AppDatabase.instance;

  List<Mahasiswa> getAll() {
    final rows = _db.select('SELECT * FROM mahasiswa ORDER BY nama ASC');

    return rows.map((row) => Mahasiswa.fromRow(row)).toList();
  }

  Mahasiswa? getById(String id) {
    final rows = _db.select('SELECT * FROM mahasiswa WHERE id = ?', [id]);

    if (rows.isEmpty) return null;

    return Mahasiswa.fromRow(rows.first);
  }

  Mahasiswa? getByNim(String nim) {
    final rows = _db.select('SELECT * FROM mahasiswa WHERE nim = ?', [nim]);

    if (rows.isEmpty) return null;

    return Mahasiswa.fromRow(rows.first);
  }

  void insert(Mahasiswa mahasiswa) {
    _db.execute(
      'INSERT INTO mahasiswa (id, nim, nama, jurusan, email, created_at) VALUES (?, ?, ?, ?, ?, ?)',
      [
        mahasiswa.id,
        mahasiswa.nim,
        mahasiswa.nama,
        mahasiswa.jurusan,
        mahasiswa.email,
        mahasiswa.createdAt.toIso8601String(),
      ],
    );
  }

  void update(Mahasiswa mahasiswa) {
    _db.execute(
      'UPDATE mahasiswa SET nim = ?, nama = ?, jurusan = ?, email = ? WHERE id = ?',
      [
        mahasiswa.nim,
        mahasiswa.nama,
        mahasiswa.jurusan,
        mahasiswa.email,
        mahasiswa.id,
      ],
    );
  }

  void delete(String id) {
    _db.execute('DELETE FROM mahasiswa WHERE id = ?', [id]);
  }
}
