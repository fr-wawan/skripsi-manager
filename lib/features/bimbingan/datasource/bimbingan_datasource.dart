import 'package:sqlite3/sqlite3.dart';
import '../../../core/db/database.dart';
import '../models/bimbingan.dart';

class BimbinganDatasource {
  Database get _db => AppDatabase.instance;

  Bimbingan? getById(String id) {
    final rows = _db.select('SELECT * FROM bimbingan WHERE id = ?', [id]);

    if (rows.isEmpty) return null;

    return Bimbingan.fromRow(rows.first);
  }

  List<Bimbingan> getBySkripsiId(String skripsiId) {
    final rows = _db.select(
      'SELECT * FROM bimbingan WHERE skripsi_id = ? ORDER BY tanggal DESC',
      [skripsiId],
    );

    return rows.map((r) => Bimbingan.fromRow(r)).toList();
  }

  void insert(Bimbingan bimbingan) {
    _db.execute('INSERT INTO bimbingan VALUES (?, ?, ?, ?, ?)', [
      bimbingan.id,
      bimbingan.tanggal.toIso8601String(),
      bimbingan.catatan,
      bimbingan.skripsiId,
      bimbingan.createdAt.toIso8601String(),
    ]);
  }

  void update(Bimbingan b) {
    _db.execute('UPDATE bimbingan SET tanggal=?, catatan=? WHERE id=?', [
      b.tanggal.toIso8601String(),
      b.catatan,
      b.id,
    ]);
  }

  void delete(String id) {
    _db.execute('DELETE FROM bimbingan WHERE id = ?', [id]);
  }

  int count() {
    final row = _db.select('SELECT COUNT(*) as total FROM bimbingan');
    return row.first['total'] as int;
  }
}
