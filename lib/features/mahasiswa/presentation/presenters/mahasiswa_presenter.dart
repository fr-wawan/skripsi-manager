import 'package:mason_logger/mason_logger.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../models/mahasiswa.dart';

class MahasiswaPresenter {
  final Logger logger;

  MahasiswaPresenter(this.logger);

  void showList(List<Mahasiswa> list) {
    if (list.isEmpty) {
      logger.warn('Belum ada mahasiswa terdaftar.');
      return;
    }

    logger.info('\n${'═' * 72}');
    logger.info('  DAFTAR MAHASISWA');
    logger.info('═' * 72);
    logger.info(
      '${'No'.padRight(5)}${'NIM'.padRight(14)}${'Nama'.padRight(28)}Jurusan',
    );
    logger.info('═' * 72);

    for (var i = 0; i < list.length; i++) {
      final m = list[i];
      logger.info(
        '${(i + 1).toString().padRight(5)}${m.nim.padRight(14)}${m.nama.padRight(28)}${m.jurusan}',
      );
    }

    logger.info('${'═' * 72}\n');
  }

  void showDetail(Mahasiswa m) {
    logger.info('\n${'═' * 50}');
    logger.info('  DETAIL MAHASISWA');
    logger.info('═' * 50);
    logger.info('  ID      : ${m.id}');
    logger.info('  NIM     : ${m.nim}');
    logger.info('  Nama    : ${m.nama}');
    logger.info('  Jurusan : ${m.jurusan}');
    logger.info('  Email   : ${m.email}');
    logger.info('  Dibuat  : ${DateFormatter.format(m.createdAt)}');
    logger.info('${'═' * 50}\n');
  }
}
