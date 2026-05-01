import 'package:mason_logger/mason_logger.dart';
import '../../skripsi/datasource/skripsi_datasource.dart';
import '../../skripsi/usecases/skripsi_usecases.dart';
import '../datasource/bimbingan_datasource.dart';
import '../presentation/commands/bimbingan_command.dart';
import '../presentation/presenters/bimbingan_presenter.dart';
import '../usecases/bimbingan_usecases.dart';

class BimbinganModule {
  late final BimbinganCommand command;

  void register(Logger logger, SkripsiUsecases skripsiUsecases) {
    final ds = BimbinganDatasource();
    final skripsiDatasource = SkripsiDatasource();
    final usecases = BimbinganUsecases(ds, skripsiDatasource);
    final presenter = BimbinganPresenter(logger);

    command = BimbinganCommand(usecases, skripsiUsecases, presenter, logger);
  }
}
