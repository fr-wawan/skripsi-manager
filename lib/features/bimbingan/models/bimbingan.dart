class Bimbingan {
  final String id;
  final DateTime tanggal;
  final String catatan;
  final String skripsiId;
  final DateTime createdAt;

  const Bimbingan({
    required this.id,
    required this.tanggal,
    required this.catatan,
    required this.skripsiId,
    required this.createdAt,
  });

  factory Bimbingan.fromRow(Map<String, dynamic> row) {
    return Bimbingan(
      id: row['id'],
      tanggal: DateTime.parse(row['tanggal'] as String),
      catatan: row['catatan'],
      skripsiId: row['skripsi_id'],
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
