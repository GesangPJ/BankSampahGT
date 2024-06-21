import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "banksampah.db";
  static const _databaseVersion = 1;

  // Table Anggota
  static const tableAnggota = 'anggota';
  static const columnId = 'id';
  static const columnNama = 'nama';
  static const columnAlamat = 'alamat';
  static const columnNoTelepon = 'no_telepon';

  //Table Jenis Sampah
  static const tableJenisSampah = 'jenis_sampah';
  static const columnIdJenisSampah = 'id_jenis_sampah';
  static const columnNamaJenisSampah = 'nama_jenis_sampah';
  static const columnHargaJenisSampah = 'harga_jenis_sampah';

  //Table Transaksi
  static const tableTransaksi = 'transaksi';
  static const columnIdTransaksi = 'id_transaksi';
  static const columnIdAnggota = 'id_anggota';
  static const columnIdJenisSampahTransaksi = 'id_jenis_sampah_transaksi';
  static const columnTanggalTransaksi = 'tanggal_transaksi';
  static const columnJumlahTransaksi = 'jumlah_transaksi';

DatabaseHelper._privateConstructor();
static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

static Database? _database;
Future<Database> get database async {
  if (_database != null) return _database!;
  _database = await _initDatabase();
  return _database!;
}

_initDatabase() async {

  String path = join(await getDatabasesPath(), _databaseName);
  return await openDatabase(
    path,
    version: _databaseVersion,
    onCreate: _onCreate,
  );
}

void _onCreate(Database db, int version) async {
  // Buat tabel anggota
  await db.execute('''
    CREATE TABLE $tableAnggota (
      $columnIdAnggota INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnNama TEXT NOT NULL,
      $columnAlamat TEXT NOT NULL,
      $columnNoTelepon TEXT NOT NULL
    )
  ''');

  // Buat tabel jenis_sampah
  await db.execute('''
    CREATE TABLE $tableJenisSampah (
      $columnIdJenisSampah INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnNamaJenisSampah TEXT NOT NULL,
      $columnHargaJenisSampah INTEGER NOT NULL
    )
  ''');

  // Buat tabel transaksi_sampah
  await db.execute('''
    CREATE TABLE $tableTransaksi (
      $columnIdTransaksi INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnIdAnggota INTEGER NOT NULL,
      $columnIdJenisSampahTransaksi INTEGER NOT NULL,
      $columnJumlahTransaksi INTEGER NOT NULL,
      $columnTanggalTransaksi TEXT NOT NULL,
      FOREIGN KEY ($columnIdAnggota) REFERENCES $tableAnggota ($columnIdAnggota),
      FOREIGN KEY ($columnIdJenisSampahTransaksi) REFERENCES $tableJenisSampah ($columnIdJenisSampah)
    )
  ''');
}

}