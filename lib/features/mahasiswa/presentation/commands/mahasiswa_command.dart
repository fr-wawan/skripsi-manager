import 'package:mason_logger/mason_logger.dart';
import '../../../../core/error/failure.dart';
import '../../usecases/mahasiswa_usecases.dart';
import '../presenters/mahasiswa_presenter.dart';

class MahasiswaCommand {
  final MahasiswaUsecases _usecases;
  final MahasiswaPresenter _presenter;
  final Logger _logger;

  MahasiswaCommand(this._usecases, this._presenter, this._logger);

  void list() {
    _presenter.showList(_usecases.getAll());
  }

  void add() {
    _logger.info('\n── Tambah Mahasiswa ──');
    final nim = _logger.prompt('NIM       :');
    final nama = _logger.prompt('Nama      :');
    final jurusan = _logger.prompt('Jurusan   :');
    final email = _logger.prompt('Email     :');

    try {
      final m = _usecases.add(
        nim: nim,
        nama: nama,
        jurusan: jurusan,
        email: email,
      );
      _logger.success('${m.nama} berhasil ditambahkan!');
    } on ValidationFailure catch (e) {
      _logger.err(e.message);
    }
  }

  void edit() {
    final all = _usecases.getAll();

    if (all.isEmpty) {
      _logger.warn('Belum ada mahasiswa.');
      return;
    }

    _presenter.showList(all);

    final input = _logger.prompt('Nomor mahasiswa yang diedit:');

    final idx = int.tryParse(input);
    if (idx == null || idx < 1 || idx > all.length) {
      _logger.err('Nomor tidak valid.');
      return;
    }

    final target = all[idx - 1];

    _logger.info('\n── Edit Mahasiswa (kosongkan = tidak berubah) ──');
    final nim = _logger.prompt('NIM     [${target.nim}]    :');
    final nama = _logger.prompt('Nama    [${target.nama}]   :');
    final jurusan = _logger.prompt('Jurusan [${target.jurusan}]:');
    final email = _logger.prompt('Email   [${target.email}]  :');

    try {
      final updated = _usecases.update(
        id: target.id,
        nim: nim.trim().isEmpty ? target.nim : nim,
        nama: nama.trim().isEmpty ? target.nama : nama,
        jurusan: jurusan.trim().isEmpty ? target.jurusan : jurusan,
        email: email.trim().isEmpty ? target.email : email,
      );

      _logger.success('Data ${updated.nama} berhasil diupdate!');
    } on ValidationFailure catch (e) {
      _logger.err(e.message);
    } on NotFoundFailure catch (e) {
      _logger.err(e.message);
    }
  }

  void delete() {
    list();
    final all = _usecases.getAll();
    if (all.isEmpty) return;

    final input = _logger.prompt('Masukkan nomor mahasiswa yang dihapus:');
    final idx = int.tryParse(input);

    if (idx == null || idx < 1 || idx > all.length) {
      _logger.err('Nomor tidak valid.');
      return;
    }

    final target = all[idx - 1];

    final confirm = _logger.confirm(
      'Hapus "${target.nama}"? Data skripsi & bimbingan ikut terhapus.',
      defaultValue: false,
    );
    if (!confirm) {
      _logger.info('Dibatalkan.');
      return;
    }

    try {
      _usecases.delete(target.id);
      _logger.success('✓ Data berhasil dihapus.');
    } on NotFoundFailure catch (e) {
      _logger.err(e.message);
    }
  }
}
