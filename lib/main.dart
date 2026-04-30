import 'package:mason_logger/mason_logger.dart';
import 'core/db/database.dart';
import 'injection/injection_container.dart';

Future<void> main() async {
  final ic = InjectionContainer.init();
  final logger = ic.logger;

  logger.info('''
╔══════════════════════════════════════════╗
║     SISTEM MANAJEMEN TUGAS AKHIR         ║
╚══════════════════════════════════════════╝''');

  try {
    await _runApp(ic, logger);
  } finally {
    AppDatabase.dispose();
  }
}

Future<void> _runApp(InjectionContainer ic, Logger logger) async {
  while (true) {
    logger.info('''
\nMenu Utama:
  [1] Manajemen Mahasiswa
  [2] Manajemen Skripsi
  [3] Manajemen Bimbingan
  [0] Keluar
''');

    switch (logger.prompt('Pilih:')) {
      case '1':
        _mahasiswaMenu(ic, logger);
      case '2':
        _skripsiMenu(ic, logger);
      case '3':
        logger.warn('Fitur manajemen bimbingan belum tersedia.');
      case '0':
        logger.success('Sampai jumpa! 👋');
        return;
      default:
        logger.err('Pilihan tidak valid.');
    }
  }
}

void _mahasiswaMenu(InjectionContainer ic, Logger logger) {
  while (true) {
    logger.info('''
\n── Mahasiswa ──
  [1] Daftar Mahasiswa
  [2] Tambah Mahasiswa
  [3] Edit Mahasiswa
  [4] Hapus Mahasiswa
  [0] Kembali
''');
    switch (logger.prompt('Pilih:')) {
      case '1':
        ic.mahasiswa.command.list();
      case '2':
        ic.mahasiswa.command.add();
      case '3':
        ic.mahasiswa.command.edit();
      case '4':
        ic.mahasiswa.command.delete();
      case '0':
        return;
      default:
        logger.err('Pilihan tidak valid.');
    }
  }
}

void _skripsiMenu(InjectionContainer ic, Logger logger) {
  while (true) {
    logger.info('''
\n── Skripsi ──
  [1] Daftar Skripsi
  [2] Tambah Skripsi
  [3] Update Status
  [0] Kembali
''');
    switch (logger.prompt('Pilih:')) {
      case '1':
        ic.skripsi.command.list();
      case '2':
        ic.skripsi.command.add();
      case '3':
        ic.skripsi.command.updateStatus();
      case '0':
        return;
      default:
        logger.err('Pilihan tidak valid.');
    }
  }
}
