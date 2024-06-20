class TransaksiSampah {
  int? id;
  int? anggotaId;
  int? jenisSampahId;
  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();
  int? jumlah;

  TransaksiSampah({this.id, 
  required this.anggotaId, 
  required this.jenisSampahId,
  required this.jumlah,
  this.createdAt,
  this.updatedAt, /* ... */});
  // Metode untuk mengonversi objek TransaksiSampah ke Map dan sebaliknya
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'anggotaId': anggotaId,
      'jenisSampahId': jenisSampahId,
      'jumlah': jumlah,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
  factory TransaksiSampah.fromMap(Map<String, dynamic> map) {
    return TransaksiSampah(
      id: map['id'],
      anggotaId: map['anggotaId'],
      jenisSampahId: map['jenisSampahId'],
      jumlah: map['jumlah'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}