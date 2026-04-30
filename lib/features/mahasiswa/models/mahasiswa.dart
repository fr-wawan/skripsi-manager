class Mahasiswa {
  final String id;
  final String nim;
  final String nama;
  final String jurusan;
  final String email;
  final DateTime createdAt;

  const Mahasiswa({
    required this.id,
    required this.nim,
    required this.nama,
    required this.jurusan,
    required this.email,
    required this.createdAt,
  });

  factory Mahasiswa.fromRow(Map<String, dynamic> row) {
    return Mahasiswa(
      id: row['id'],
      nim: row['nim'],
      nama: row['nama'],
      jurusan: row['jurusan'],
      email: row['email'],
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nim': nim,
      'nama': nama,
      'jurusan': jurusan,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
