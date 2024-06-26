// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "banksampah.db";
  static const _databaseVersion = 3;

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
  static const columnIdJenisSampahTransaksi = 'id_jenis_sampah_transaksi';
  static const columnBerat = 'berat';
  static const columnTotalHarga = 'total_harga';
  static const columnTanggalTransaksi = 'dibuat';
  static const columnTanggalUpdate = 'diubah';

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

  // Fungsi membuat table
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
      $columnIdJenisSampahTransaksi INTEGER NOT NULL,
      $columnTanggalTransaksi TEXT NOT NULL,
      $columnTanggalUpdate TEXT,
      $columnBerat REAL NOT NULL,
      $columnTotalHarga INTEGER NOT NULL,
      FOREIGN KEY ($columnIdAnggota) REFERENCES $tableAnggota ($columnId),
      FOREIGN KEY ($columnIdJenisSampahTransaksi) REFERENCES $tableJenisSampah ($columnIdJenisSampah)
    )
  ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('''
      DROP TABLE IF EXISTS transaksi;
    ''');
      await db.execute('''
      CREATE TABLE $tableTransaksi (
        $columnIdTransaksi INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnIdAnggota INTEGER NOT NULL,
        $columnIdJenisSampah INTEGER NOT NULL,
        $columnBerat REAL NOT NULL,
        $columnTotalHarga INTEGER NOT NULL,
        $columnTanggalTransaksi TEXT NOT NULL,
        $columnTanggalUpdate TEXT NOT NULL,
        FOREIGN KEY ($columnIdAnggota) REFERENCES $tableAnggota ($columnId),
        FOREIGN KEY ($columnIdJenisSampah) REFERENCES $tableJenisSampah ($columnIdJenisSampah)
      )
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

  // Fungsi untuk menambah transaksi baru
  Future<int> insertTransaksi(Map<String, dynamic> row) async {
    if (row[columnBerat] <= 0) {
      throw Exception('Berat harus lebih besar dari 0.');
    }

    Database db = await instance.database;
    return await db.insert(tableTransaksi, row);
  }

  // Fungsi Update transaksi
  Future<int> updateTransaksi(int id, Map<String, dynamic> row) async {
    Database db = await instance.database;
    row[columnTanggalUpdate] = DateTime.now().toIso8601String();
    print('Updating transaction with ID: $id, Data: $row');
    int result = await db.update(tableTransaksi, row,
        where: '$columnIdTransaksi = ?', whereArgs: [id]);
    print('Update result: $result');
    return result;
  }

  // Fungsi untuk mendapatkan semua data transaksi
  Future<List<Map<String, dynamic>>> getAllDataTransaksi() async {
    Database db = await instance.database;

    String query = '''
    SELECT
      t.$columnIdTransaksi,
      strftime('%Y-%m-%d %H:%M:%S', t.$columnTanggalTransaksi) AS tanggal_transaksi,
      a.$columnNama AS nama_anggota,
      js.$columnNamaJenisSampah AS jenis_sampah,
      t.$columnBerat,
      t.$columnTotalHarga
    FROM $tableTransaksi t
    JOIN $tableAnggota a ON t.$columnIdAnggota = a.$columnId
    JOIN $tableJenisSampah js ON t.$columnIdJenisSampahTransaksi = js.$columnIdJenisSampah
    ORDER BY t.$columnTanggalTransaksi DESC
  ''';

    // Debug Log
    if (kDebugMode) {
      print("Executing query: $query");
    }

    // Raw query untuk debug
    List<Map<String, dynamic>> result = await db.rawQuery(query);

    if (kDebugMode) {
      print("Query result: $result");
    }

    return result;
  }

  // Ambil data transaksi untuk update / edit
  Future<int> getHargaPerKgByTransaksiId(int idTransaksi) async {
    Database db = await instance.database;

    String query = '''
    SELECT js.$columnHargaJenisSampah
    FROM $tableTransaksi t
    JOIN $tableJenisSampah js ON t.$columnIdJenisSampahTransaksi = js.$columnIdJenisSampah
    WHERE t.$columnIdTransaksi = ?
  ''';

    List<Map<String, dynamic>> result = await db.rawQuery(query, [idTransaksi]);

    if (result.isNotEmpty) {
      // Retrieve harga per kilogram as a num type (int or double)
      var hargaPerKg = result.first[columnHargaJenisSampah];
      if (hargaPerKg is int) {
        return hargaPerKg;
      } else if (hargaPerKg is double) {
        return hargaPerKg.toInt(); // Convert double to int if needed
      } else {
        throw Exception(
            'Unexpected data type for harga per kilogram: ${hargaPerKg.runtimeType}');
      }
    } else {
      throw Exception(
          'Harga per kilogram tidak ditemukan untuk transaksi ID $idTransaksi');
    }
  }
}
