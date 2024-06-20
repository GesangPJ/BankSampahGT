class Anggota {
  int? id;
  String nama;
  String alamat;
  String nomortelp;

  Anggota({this.id, required this.nama, required this.alamat, required this.nomortelp /* ... */});
  // Metode untuk mengonversi objek Anggota ke Map dan sebaliknya
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'nomortelp' : nomortelp,
    };
  }
  factory Anggota.fromMap(Map<String, dynamic> map) {
    return Anggota(
      id: map['id'],
      nama: map['nama'],
      alamat: map['alamat'],
      nomortelp: map['nomortelp'],
    );
  }
}