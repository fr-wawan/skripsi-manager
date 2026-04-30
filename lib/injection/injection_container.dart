import 'package:mason_logger/mason_logger.dart';
import '../features/mahasiswa/datasource/mahasiswa_datasource.dart';
import '../features/mahasiswa/injection/mahasiswa_module.dart';
import '../features/mahasiswa/usecases/mahasiswa_usecases.dart';

class InjectionContainer {
  late final Logger logger;
  late final MahasiswaModule mahasiswa;

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

    mahasiswa = MahasiswaModule()..register(logger);
  }
}
