import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "banksampah.db";
  static const _databaseVersion = 2;

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

  // Table Transaksi
  static const tableTransaksi = 'transaksi';
  static const columnIdTransaksi = 'id_transaksi';
  static const columnIdAnggota = 'id_anggota';
  static const columnTanggalTransaksi = 'tanggal_transaksi';
  static const columnTanggalUpdate = 'tanggal_update';

  // Table Detail Transaksi
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
      onUpgrade: _onUpgrade,
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

    await db.execute('''
    CREATE TABLE $tableTransaksi (
      $columnIdTransaksi INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnIdAnggota INTEGER NOT NULL,
      $columnTanggalTransaksi TEXT NOT NULL,
      $columnTanggalUpdate TEXT,
      FOREIGN KEY ($columnIdAnggota) REFERENCES $tableAnggota ($columnId)
    )
  ''');

    await db.execute('''
    CREATE TABLE $tableDetailTransaksi (
      $columnIdDetailTransaksi INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnIdTransaksiDetail INTEGER NOT NULL,
      $columnIdJenisSampahDetail INTEGER NOT NULL,
      $columnBerat INTEGER NOT NULL,
      $columnTotalHarga INTEGER NOT NULL,
      FOREIGN KEY ($columnIdTransaksiDetail) REFERENCES $tableTransaksi ($columnIdTransaksi),
      FOREIGN KEY ($columnIdJenisSampahDetail) REFERENCES $tableJenisSampah ($columnIdJenisSampah)
    )
  ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      ALTER TABLE $tableTransaksi ADD COLUMN $columnTanggalUpdate TEXT
    ''');
    }
  }

  // Fungsi untuk menyimpan data anggota
  Future<int> insertAnggota(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableAnggota, row);
  }

  // Fungsi untuk mendapatkan semua data anggota
  Future<List<Map<String, dynamic>>> getAllAnggota() async {
    Database db = await instance.database;
    return await db.query(tableAnggota);
  }

  // Fungsi untuk menghapus data anggota
  Future<int> deleteAnggota(int id) async {
    Database db = await instance.database;
    return await db
        .delete(tableAnggota, where: '$columnId = ?', whereArgs: [id]);
  }

  // Fungsi untuk mengupdate data anggota
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

  // Fungsi untuk menambah jenis sampah
  Future<int> insertJenisSampah(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableJenisSampah, row);
  }

  // Fungsi untuk mengupdate jenis sampah
  Future<int> updateJenisSampah(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnIdJenisSampah];
    return await db.update(tableJenisSampah, row,
        where: '$columnIdJenisSampah = ?', whereArgs: [id]);
  }

  // Fungsi untuk menghapus jenis sampah
  Future<int> deleteJenisSampah(int id) async {
    Database db = await instance.database;
    return await db.delete(tableJenisSampah,
        where: '$columnIdJenisSampah = ?', whereArgs: [id]);
  }

  // Fungsi untuk mendapatkan jenis sampah dengan ID
  Future<Map<String, dynamic>?> getJenisSampahById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(tableJenisSampah,
        where: '$columnIdJenisSampah = ?', whereArgs: [id], limit: 1);
    return results.isNotEmpty ? results.first : null;
  }

  // Fungsi untuk menambah transaksi baru ke tabel 'transaksi'
  Future<int> insertTransaksi(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableTransaksi, row);
  }

  // Fungsi untuk menambah detail transaksi baru ke tabel 'detail_transaksi'
  Future<int> insertDetailTransaksi(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableDetailTransaksi, row);
  }

  // Fungsi untuk mendapatkan data transaksi per anggota
  Future<List<Map<String, dynamic>>> getDataTransaksi(int idAnggota) async {
    Database db = await instance.database;

    String query = '''
    SELECT
      t.$columnTanggalTransaksi,
      a.$columnNama as nama_anggota,
      dt.$columnBerat,
      dt.$columnTotalHarga
    FROM $tableTransaksi t
    JOIN $tableAnggota a ON t.$columnIdAnggota = a.$columnId
    JOIN $tableDetailTransaksi dt ON t.$columnIdTransaksi = dt.$columnIdTransaksiDetail
    WHERE t.$columnIdAnggota = ?
    ORDER BY t.$columnTanggalTransaksi DESC
  ''';

    return await db.rawQuery(query, [idAnggota]);
  }
}
