import 'package:mason_logger/mason_logger.dart';
import 'package:skripsi_manager/core/utils/date_formatter.dart';
import '../../../../core/error/failure.dart';
import '../../../skripsi/usecases/skripsi_usecases.dart';
import '../../usecases/bimbingan_usecases.dart';
import '../presenters/bimbingan_presenter.dart';

class BimbinganCommand {
  final BimbinganUsecases _usecases;
  final SkripsiUsecases _skripsiUsecases;
  final BimbinganPresenter _presenter;
  final Logger _logger;

  BimbinganCommand(
    this._usecases,
    this._skripsiUsecases,
    this._presenter,
    this._logger,
  );

  void add() {
    final skripsiList = _skripsiUsecases.getAll();

    if (skripsiList.isEmpty) {
      _logger.warn('Tambahkan skripsi terlebih dahulu.');
      return;
    }

    _logger.info('\n── Tambah Bimbingan ──');
    _logger.info('Pilih Skripsi:');

    for (var i = 0; i < skripsiList.length; i++) {
      _logger.info('  [${i + 1}] ${skripsiList[i].judul}');
    }

    final input = _logger.prompt('Nomor skripsi:');

    final idx = int.tryParse(input);

    if (idx == null || idx < 1 || idx > skripsiList.length) {
      _logger.err('Nomor tidak valid.');
      return;
    }

    final skripsi = skripsiList[idx - 1];

    final tanggalStr = _logger.prompt('Tanggal (YYYY-MM-DD):');
    final catatan = _logger.prompt('Catatan   :');

    try {
      final tanggal = DateTime.parse(tanggalStr);

      _usecases.add(skripsiId: skripsi.id, tanggal: tanggal, catatan: catatan);

      _logger.success('Bimbingan berhasil dicatat!');
    } on FormatException {
      _logger.err('Format tanggal tidak valid. Gunakan YYYY-MM-DD.');
    } on ValidationFailure catch (e) {
      _logger.err(e.message);
    } on NotFoundFailure catch (e) {
      _logger.err(e.message);
    }
  }

  void edit() {
    final skripsiList = _skripsiUsecases.getAll();
    if (skripsiList.isEmpty) {
      _logger.warn('Belum ada skripsi.');
      return;
    }

    _logger.info('Pilih Skripsi:');

    for (var i = 0; i < skripsiList.length; i++) {
      _logger.info('  [${i + 1}] ${skripsiList[i].judul}');
    }

    final skripsiInput = _logger.prompt('Nomor skripsi:');
    final skripsiIdx = int.tryParse(skripsiInput);
    if (skripsiIdx == null ||
        skripsiIdx < 1 ||
        skripsiIdx > skripsiList.length) {
      _logger.err('Nomor tidak valid.');
      return;
    }

    final skripsi = skripsiList[skripsiIdx - 1];
    final bimbinganList = _usecases.getBySkripsiId(skripsi.id);

    if (bimbinganList.isEmpty) {
      _logger.warn('Belum ada bimbingan untuk skripsi ini.');
      return;
    }

    _presenter.showList(bimbinganList);

    final input = _logger.prompt('Nomor bimbingan yang diedit:');
    final idx = int.tryParse(input);
    if (idx == null || idx < 1 || idx > bimbinganList.length) {
      _logger.err('Nomor tidak valid.');
      return;
    }

    final target = bimbinganList[idx - 1];
    final tanggalNow = DateFormatter.format(target.tanggal);

    _logger.info('\n── Edit Bimbingan (kosongkan = tidak berubah) ──');
    final tanggalStr = _logger.prompt('Tanggal [$tanggalNow] (YYYY-MM-DD):');
    final catatan = _logger.prompt('Catatan [${target.catatan}]       :');

    try {
      DateTime tanggal;
      if (tanggalStr.trim().isEmpty) {
        tanggal = target.tanggal;
      } else {
        tanggal = DateTime.parse(tanggalStr.trim());
      }

      _usecases.update(
        id: target.id,
        tanggal: tanggal,
        catatan: catatan.trim().isEmpty ? target.catatan : catatan,
      );
      _logger.success('Bimbingan berhasil diupdate!');
    } on FormatException {
      _logger.err('Format tanggal tidak valid. Gunakan YYYY-MM-DD.');
    } on ValidationFailure catch (e) {
      _logger.err(e.message);
    } on NotFoundFailure catch (e) {
      _logger.err(e.message);
    }
  }

  void listBySkripsi() {
    final skripsiList = _skripsiUsecases.getAll();

    if (skripsiList.isEmpty) {
      _logger.warn('Belum ada skripsi.');
      return;
    }

    _logger.info('Pilih Skripsi:');
    for (var i = 0; i < skripsiList.length; i++) {
      _logger.info('  [${i + 1}] ${skripsiList[i].judul}');
    }

    final input = _logger.prompt('Nomor:');
    final idx = int.tryParse(input);
    if (idx == null || idx < 1 || idx > skripsiList.length) {
      _logger.err('Nomor tidak valid.');
      return;
    }

    final list = _usecases.getBySkripsiId(skripsiList[idx - 1].id);
    _presenter.showList(list);
  }
}
