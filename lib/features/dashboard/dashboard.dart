import 'package:mason_logger/mason_logger.dart';
import '../bimbingan/datasource/bimbingan_datasource.dart';
import '../mahasiswa/datasource/mahasiswa_datasource.dart';
import '../skripsi/datasource/skripsi_datasource.dart';
import '../skripsi/models/skripsi.dart';

class Dashboard {
  final Logger _logger;
  final MahasiswaDatasource _mahasiswaDatasource;
  final SkripsiDatasource _skripsiDatasource;
  final BimbinganDatasource _bimbinganDatasource;

  Dashboard(this._logger)
    : _mahasiswaDatasource = MahasiswaDatasource(),
      _skripsiDatasource = SkripsiDatasource(),
      _bimbinganDatasource = BimbinganDatasource();

  void show() {
    final totalMahasiswa = _mahasiswaDatasource.count();
    final totalBimbingan = _bimbinganDatasource.count();

    final totalProposal = _skripsiDatasource.countByStatus(
      StatusSkripsi.proposal.name,
    );

    final totalBerjalan = _skripsiDatasource.countByStatus(
      StatusSkripsi.berjalan.name,
    );

    final totalRevisi = _skripsiDatasource.countByStatus(
      StatusSkripsi.revisi.name,
    );

    final totalSelesai = _skripsiDatasource.countByStatus(
      StatusSkripsi.selesai.name,
    );

    final totalSkripsi =
        totalProposal + totalBerjalan + totalRevisi + totalSelesai;

    _logger.info('''
${'═' * 46}
  REKAP DATA
${'─' * 46}
  Total Mahasiswa  : $totalMahasiswa
${'─' * 46}
  Total Skripsi    : $totalSkripsi
    ↳ Proposal     : $totalProposal
    ↳ Berjalan     : $totalBerjalan
    ↳ Revisi       : $totalRevisi
    ↳ Selesai      : $totalSelesai
${'─' * 46}
  Total Bimbingan  : $totalBimbingan
${'═' * 46}
    ''');
  }
}
