import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "banksampah.db";
  static final _databaseVersion = 1;

  // Table Anggota
  static final tableAnggota = 'anggota';
  static final columnId = 'id';
  static final columnNama = 'nama';
  static final columnAlamat = 'alamat';
  static final columnNoTelepon = 'no_telepon';

  //Table Jenis Sampah
  static final tableJenisSampah = 'jenis_sampah';
  static final columnIdJenisSampah = 'id_jenis_sampah';
  static final columnNamaJenisSampah = 'nama_jenis_sampah';
  static final columnHargaJenisSampah = 'harga_jenis_sampah';

  //Table Transaksi
  static final tableTransaksi = 'transaksi';
  static final columnIdTransaksi = 'id_transaksi';
  static final columnIdAnggota = 'id_anggota';
  static final columnIdJenisSampahTransaksi = 'id_jenis_sampah_transaksi';
  static final columnTanggalTransaksi = 'tanggal_transaksi';
  static final columnJumlahTransaksi = 'jumlah_transaksi';

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