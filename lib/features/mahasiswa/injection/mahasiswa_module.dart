import 'package:mason_logger/mason_logger.dart';
import '../datasource/mahasiswa_datasource.dart';
import '../presentation/commands/mahasiswa_command.dart';
import '../presentation/presenters/mahasiswa_presenter.dart';
import '../usecases/mahasiswa_usecases.dart';

class MahasiswaModule {
  late final MahasiswaCommand command;

  void register(Logger logger) {
    final ds = MahasiswaDatasource();
    final usecases = MahasiswaUsecases(ds);
    final presenter = MahasiswaPresenter(logger);

    command = MahasiswaCommand(usecases, presenter, logger);
  }
}
