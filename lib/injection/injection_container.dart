import 'package:mason_logger/mason_logger.dart';
import 'package:skripsi_manager/features/skripsi/datasource/skripsi_datasource.dart';
import 'package:skripsi_manager/features/skripsi/injection/skripsi_module.dart';
import 'package:skripsi_manager/features/skripsi/usecases/skripsi_usecases.dart';
import '../features/mahasiswa/datasource/mahasiswa_datasource.dart';
import '../features/mahasiswa/injection/mahasiswa_module.dart';
import '../features/mahasiswa/usecases/mahasiswa_usecases.dart';

class InjectionContainer {
  late final Logger logger;
  late final MahasiswaModule mahasiswa;
  late final SkripsiModule skripsi;

  InjectionContainer._();

  static InjectionContainer init() {
    final ic = InjectionContainer._();
    ic._setup();
    return ic;
  }

  void _setup() {
    logger = Logger();

    // Shared usecases (dipakai lintas module)
    final mahasiswaUsecases = MahasiswaUsecases(MahasiswaDatasource());
    final skripsiUsecases = SkripsiUsecases(
      SkripsiDatasource(),
      MahasiswaDatasource(),
    );

    mahasiswa = MahasiswaModule()..register(logger);
    skripsi = SkripsiModule()..register(logger, mahasiswaUsecases);
  }
}
