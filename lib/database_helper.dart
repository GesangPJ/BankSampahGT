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

  // Table Jenis Sampah
  static const tableJenisSampah = 'jenis_sampah';
  static const columnIdJenisSampah = 'id_jenis_sampah';
  static const columnNamaJenisSampah = 'nama_jenis_sampah';
  static const columnHargaJenisSampah = 'harga_jenis_sampah';

  // Tabel Transaksi
  static const tableTransaksi = 'transaksi';
  static const columnIdTransaksi = 'id_transaksi';
  static const columnIdAnggota = 'id_anggota';
  static const columnTanggalTransaksi = 'tanggal_transaksi';
  static const columnTanggalUpdate =
      'tanggal_update'; // Added for last updated date

  // Tabel Detail Transaksi
  static const tableDetailTransaksi = 'detail_transaksi';
  static const columnIdDetailTransaksi = 'id_detail_transaksi';
  static const columnIdTransaksiDetail = 'id_transaksi';
  static const columnIdJenisSampahDetail = 'id_jenis_sampah';
  static const columnBerat = 'berat';
  static const columnTotalHarga = 'total_harga';

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
    await db.execute('''
    CREATE TABLE $tableAnggota (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnNama TEXT NOT NULL UNIQUE,
      $columnAlamat TEXT NOT NULL,
      $columnNoTelepon TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE $tableJenisSampah (
      $columnIdJenisSampah INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnNamaJenisSampah TEXT NOT NULL,
      $columnHargaJenisSampah INTEGER NOT NULL
    )
  ''');

    // Buat tabel transaksi
    await db.execute('''
      CREATE TABLE $tableTransaksi (
        $columnIdTransaksi INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnIdAnggota INTEGER NOT NULL,
        $columnTanggalTransaksi TEXT NOT NULL,
        $columnTanggalUpdate TEXT,
        FOREIGN KEY ($columnIdAnggota) REFERENCES $tableAnggota ($columnId)
      )
    ''');

    // Buat tabel detail_transaksi
    await db.execute('''
      CREATE TABLE $tableDetailTransaksi (
        $columnIdDetailTransaksi INTEGER PRIMARY KEY AUTO INCREMENT,
        $columnIdTransaksiDetail INTEGER NOT NULL,
        $columnIdJenisSampahDetail INTEGER NOT NULL,
        $columnBerat INTEGER NOT NULL,
        $columnTotalHarga INTEGER NOT NULL,
        FOREIGN KEY ($columnIdTransaksiDetail) REFERENCES $tableTransaksi ($columnIdTransaksi),
        FOREIGN KEY ($columnIdJenisSampahDetail) REFERENCES $tableJenisSampah ($columnIdJenisSampah)
      )
    ''');
  }

  //Simpan Data Anggota
  Future<int> insertAnggota(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableAnggota, row);
  }

  //Ambil Data Anggota
  Future<List<Map<String, dynamic>>> getAllAnggota() async {
    Database db = await instance.database;
    return await db.query(tableAnggota);
  }

  // Hapus Data Anggota
  Future<int> deleteAnggota(int id) async {
    Database db = await instance.database;
    return await db
        .delete(tableAnggota, where: '$columnId = ?', whereArgs: [id]);
  }

//Update Data Anggota
  Future<int> updateAnggota(int id, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db
        .update(tableAnggota, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Fungsi untuk mendapatkan semua jenis sampah dari tabel jenis_sampah
  Future<List<Map<String, dynamic>>> getAllJenisSampah() async {
    Database db = await instance.database;
    return await db.query(tableJenisSampah);
  }

  //Tambah Jenis Sampah
  Future<int> insertJenisSampah(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableJenisSampah, row);
  }

  // Update Jenis Sampah
  Future<int> updateJenisSampah(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnIdJenisSampah];
    return await db.update(tableJenisSampah, row,
        where: '$columnIdJenisSampah = ?', whereArgs: [id]);
  }

  // Hapus Jenis Sampah
  Future<int> deleteJenisSampah(int id) async {
    Database db = await instance.database;
    return await db.delete(tableJenisSampah,
        where: '$columnIdJenisSampah = ?', whereArgs: [id]);
  }

  // Ambil Jenis Sampah dengan ID
  Future<Map<String, dynamic>?> getJenisSampahById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(tableJenisSampah,
        where: '$columnIdJenisSampah = ?',
        whereArgs: [id],
        limit: 1); // Hanya ambil satu data karena ID unik
    return results.isNotEmpty ? results.first : null;
  }

  // Function to insert a new transaction into the 'transaksi' table
  Future<int> insertTransaksi(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableTransaksi, row);
  }

  // Function to insert a new detail transaksi into the 'detail_transaksi' table
  Future<int> insertDetailTransaksi(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableDetailTransaksi, row);
  }
}
