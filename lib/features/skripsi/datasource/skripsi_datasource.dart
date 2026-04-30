import 'package:sqlite3/sqlite3.dart';
import '../../../core/db/database.dart';
import '../models/skripsi.dart';

class SkripsiDatasource {
  Database get _db => AppDatabase.instance;

  List<Skripsi> getAll() {
    final rows = _db.select('SELECT * FROM skripsi ORDER BY created_at DESC');

    return rows.map((row) => Skripsi.fromRow(row)).toList();
  }

  List<Skripsi> getByMahasiswaId(String mahasiswaId) {
    final rows = _db.select(
      'SELECT * FROM skripsi WHERE mahasiswa_id = ? ORDER BY created_at DESC',
      [mahasiswaId],
    );

    return rows.map((row) => Skripsi.fromRow(row)).toList();
  }

  Skripsi? getById(String id) {
    final rows = _db.select('SELECT * FROM skripsi WHERE id = ?', [id]);

    if (rows.isEmpty) return null;

    return Skripsi.fromRow(rows.first);
  }

  void insert(Skripsi skripsi) {
    _db.execute(
      'INSERT INTO skripsi (id, judul, status, mahasiswa_id, created_at) VALUES (?, ?, ?, ?, ?)',
      [
        skripsi.id,
        skripsi.judul,
        skripsi.status.name,
        skripsi.mahasiswaId,
        skripsi.createdAt.toIso8601String(),
      ],
    );
  }

  void update(Skripsi skripsi) {
    _db.execute('UPDATE skripsi SET judul = ?, status = ? WHERE id = ?', [
      skripsi.judul,
      skripsi.status.name,
      skripsi.id,
    ]);
  }

  void delete(String id) {
    _db.execute('DELETE FROM skripsi WHERE id = ?', [id]);
  }
}
