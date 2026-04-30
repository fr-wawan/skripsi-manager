enum StatusSkripsi { proposal, berjalan, revisi, selesai }

extension StatusSkripsiExt on StatusSkripsi {
  String get label => switch (this) {
    StatusSkripsi.proposal => 'Proposal',
    StatusSkripsi.berjalan => 'Berjalan',
    StatusSkripsi.revisi => 'Revisi',
    StatusSkripsi.selesai => 'Selesai',
  };

  static StatusSkripsi fromString(String value) =>
      StatusSkripsi.values.firstWhere((e) => e.name == value);
}

class Skripsi {
  final String id;
  final String judul;
  final StatusSkripsi status;
  final String mahasiswaId;
  final DateTime createdAt;

  const Skripsi({
    required this.id,
    required this.judul,
    required this.status,
    required this.mahasiswaId,
    required this.createdAt,
  });

  factory Skripsi.fromRow(Map<String, dynamic> row) {
    return Skripsi(
      id: row['id'],
      judul: row['judul'],
      status: StatusSkripsiExt.fromString(row['status']),
      mahasiswaId: row['mahasiswa_id'],
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  Skripsi copyWith({StatusSkripsi? status, String? judul}) => Skripsi(
    id: id,
    judul: judul ?? this.judul,
    status: status ?? this.status,
    mahasiswaId: mahasiswaId,
    createdAt: createdAt,
  );
}
