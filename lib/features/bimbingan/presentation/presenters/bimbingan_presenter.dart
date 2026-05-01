import 'package:mason_logger/mason_logger.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../models/bimbingan.dart';

class BimbinganPresenter {
  final Logger logger;
  BimbinganPresenter(this.logger);

  void showList(List<Bimbingan> list) {
    if (list.isEmpty) {
      logger.warn('Belum ada bimbingan tercatat.');
      return;
    }

    logger.info('\n${'═' * 65}');
    logger.info('  RIWAYAT BIMBINGAN');
    logger.info('═' * 65);
    logger.info('${'No'.padRight(5)}${'Tanggal'.padRight(15)}Catatan');
    logger.info('═' * 65);

    for (var i = 0; i < list.length; i++) {
      final b = list[i];
      logger.info(
        '${(i + 1).toString().padRight(5)}${DateFormatter.format(b.tanggal).padRight(15)}${b.catatan}',
      );
    }

    logger.info('${'═' * 65}\n');
  }
}
