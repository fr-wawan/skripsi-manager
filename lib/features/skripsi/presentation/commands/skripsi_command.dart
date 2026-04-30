import 'package:mason_logger/mason_logger.dart';
import '../../../../core/error/failure.dart';
import '../../../mahasiswa/usecases/mahasiswa_usecases.dart';
import '../../models/skripsi.dart';
import '../../usecases/skripsi_usecases.dart';
import '../presenters/skripsi_presenter.dart';

class SkripsiCommand {
  final SkripsiUsecases _usecases;
  final MahasiswaUsecases _mahasiswaUsecases;
  final SkripsiPresenter _presenter;
  final Logger _logger;

  SkripsiCommand(
    this._usecases,
    this._mahasiswaUsecases,
    this._presenter,
    this._logger,
  );

  void list() {
    final skripsiList = _usecases.getAll();
    final mahasiswaList = _mahasiswaUsecases.getAll();
    final namaMap = {for (final m in mahasiswaList) m.id: m.nama};
    _presenter.showList(skripsiList, namaMahasiswa: namaMap);
  }

  void add() {
    final mahasiswaList = _mahasiswaUsecases.getAll();
    if (mahasiswaList.isEmpty) {
      _logger.warn('Tambahkan mahasiswa terlebih dahulu.');
      return;
    }

    _logger.info('\n── Tambah Skripsi ──');
    _logger.info('Pilih Mahasiswa:');
    for (var i = 0; i < mahasiswaList.length; i++) {
      _logger.info(
        '  [${i + 1}] ${mahasiswaList[i].nama} (${mahasiswaList[i].nim})',
      );
    }

    final input = _logger.prompt('Nomor mahasiswa:');
    final idx = int.tryParse(input);
    if (idx == null || idx < 1 || idx > mahasiswaList.length) {
      _logger.err('Nomor tidak valid.');
      return;
    }

    final mahasiswa = mahasiswaList[idx - 1];
    final judul = _logger.prompt('Judul skripsi :');

    try {
      final s = _usecases.add(judul: judul, mahasiswaId: mahasiswa.id);
      _logger.success('Skripsi "${s.judul}" berhasil ditambahkan!');
    } on ValidationFailure catch (e) {
      _logger.err(e.message);
    }
  }

  void updateStatus() {
    final skripsiList = _usecases.getAll();
    if (skripsiList.isEmpty) {
      _logger.warn('Belum ada skripsi.');
      return;
    }

    final mahasiswaList = _mahasiswaUsecases.getAll();

    final namaMap = {for (final m in mahasiswaList) m.id: m.nama};

    _presenter.showList(skripsiList, namaMahasiswa: namaMap);

    final input = _logger.prompt('Nomor skripsi:');

    final idx = int.tryParse(input);
    if (idx == null || idx < 1 || idx > skripsiList.length) {
      _logger.err('Nomor tidak valid.');
      return;
    }

    final target = skripsiList[idx - 1];
    _logger.info('Status saat ini: ${target.status.label}');
    _logger.info('Pilih status baru:');

    final statuses = StatusSkripsi.values;

    for (var i = 0; i < statuses.length; i++) {
      _logger.info('  [${i + 1}] ${statuses[i].label}');
    }

    final statusInput = _logger.prompt('Pilih:');

    final statusIdx = int.tryParse(statusInput);

    if (statusIdx == null || statusIdx < 1 || statusIdx > statuses.length) {
      _logger.err('Pilihan tidak valid.');
      return;
    }

    try {
      _usecases.updateStatus(id: target.id, status: statuses[statusIdx - 1]);
      _logger.success('Status berhasil diupdate!');
    } on NotFoundFailure catch (e) {
      _logger.err(e.message);
    }
  }
}
