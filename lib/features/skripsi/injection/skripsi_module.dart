import 'package:mason_logger/mason_logger.dart';
import '../../mahasiswa/datasource/mahasiswa_datasource.dart';
import '../../mahasiswa/usecases/mahasiswa_usecases.dart';
import '../datasource/skripsi_datasource.dart';
import '../presentation/commands/skripsi_command.dart';
import '../presentation/presenters/skripsi_presenter.dart';
import '../usecases/skripsi_usecases.dart';

class SkripsiModule {
  late final SkripsiCommand command;

  void register(Logger logger, MahasiswaUsecases mahasiswaUsecases) {
    final datasource = SkripsiDatasource();
    final mahasiswaDatasource = MahasiswaDatasource();
    final skripsiUsecases = SkripsiUsecases(datasource, mahasiswaDatasource);
    final presenter = SkripsiPresenter(logger);

    command = SkripsiCommand(
      skripsiUsecases,
      mahasiswaUsecases,
      presenter,
      logger,
    );
  }
}
