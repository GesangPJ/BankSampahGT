class JenisSampah {
  int? id;
  String namajenis;
  int? harga;

  JenisSampah({this.id, required this.namajenis, required this.harga /* ... */});
  // Metode untuk mengonversi objek Anggota ke Map dan sebaliknya
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': namajenis,
      'harga': harga,
    };
  }
  factory JenisSampah.fromMap(Map<String, dynamic> map) {
    return JenisSampah(
      id: map['id'],
      namajenis: map['namajenis'],
      harga: map['harga'],
    );
  }
}