import 'package:mason_logger/mason_logger.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../models/skripsi.dart';

class SkripsiPresenter {
  final Logger logger;
  SkripsiPresenter(this.logger);

  void showList(List<Skripsi> list, {Map<String, String>? namaMahasiswa}) {
    if (list.isEmpty) {
      logger.warn('Belum ada skripsi terdaftar.');
      return;
    }
    logger.info('\n${'═' * 80}');
    logger.info('  DAFTAR SKRIPSI');
    logger.info('═' * 80);
    logger.info(
      '${'No'.padRight(5)}${'Judul'.padRight(40)}${'Status'.padRight(12)}${'Mahasiswa'}',
    );

    logger.info('─' * 80);

    for (var i = 0; i < list.length; i++) {
      final skripsi = list[i];
      final nama = namaMahasiswa?[skripsi.mahasiswaId] ?? skripsi.mahasiswaId;
      logger.info(
        '${(i + 1).toString().padRight(5)}${skripsi.judul.padRight(40)}${skripsi.status.label.padRight(12)}$nama',
      );
    }
    logger.info('${'═' * 80}\n');
  }
}
