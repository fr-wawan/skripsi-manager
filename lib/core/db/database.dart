import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

class AppDatabase {
  static Database? _instance;

  static Database get instance {
    _instance ??= _init();
    return _instance!;
  }

  static Database _init() {
    final dir = Directory('.data');
    if (!dir.existsSync()) dir.createSync();

    final db = sqlite3.open('.data/skripsi.db');

    db.execute('PRAGMA foreign_keys = ON;');

    _createTables(db);
    return db;
  }

  static void _createTables(Database db) {
    db.execute('''
      CREATE TABLE IF NOT EXISTS mahasiswa (
        id      TEXT PRIMARY KEY,
        nim     TEXT UNIQUE NOT NULL,
        nama    TEXT NOT NULL,
        jurusan TEXT NOT NULL,
        email   TEXT NOT NULL,
        created_at TEXT NOT NULL
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS skripsi (
        id           TEXT PRIMARY KEY,
        judul        TEXT NOT NULL,
        status       TEXT NOT NULL DEFAULT 'proposal',
        mahasiswa_id TEXT NOT NULL,
        created_at   TEXT NOT NULL,
        FOREIGN KEY (mahasiswa_id) REFERENCES mahasiswa(id) ON DELETE CASCADE
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS bimbingan (
        id         TEXT PRIMARY KEY,
        tanggal    TEXT NOT NULL,
        catatan    TEXT NOT NULL,
        skripsi_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (skripsi_id) REFERENCES skripsi(id) ON DELETE CASCADE
      );
    ''');
  }

  static void dispose() {
    _instance?.close();
    _instance = null;
  }
}
