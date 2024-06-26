// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';

class TambahTransaksi extends StatefulWidget {
  const TambahTransaksi({super.key});

  @override
  State<TambahTransaksi> createState() => _TambahTransaksiState();
}

class _TambahTransaksiState extends State<TambahTransaksi> {
  // Inisialisasi
  int? _selectedAnggota;
  int? _selectedJenisSampah;
  final TextEditingController _beratController = TextEditingController();
  List<Map<String, dynamic>> _anggotaList = [];
  List<Map<String, dynamic>> _jenisSampahList = [];
  // ignore: unused_field
  int _totalHarga = 0;

  @override
  void initState() {
    super.initState();
    _fetchAnggota();
    _fetchJenisSampah();
  }

  @override
  void dispose() {
    _beratController.dispose();
    super.dispose();
  }

  // Ambil Data Anggota
  Future<void> _fetchAnggota() async {
    List<Map<String, dynamic>> anggota =
        await DatabaseHelper.instance.getAllAnggota();
    setState(() {
      _anggotaList = anggota;
      if (_anggotaList.isNotEmpty) {
        _selectedAnggota = _anggotaList[0]['id'];
      }
    });
  }

  //Ambil data jenis sampah
  Future<void> _fetchJenisSampah() async {
    List<Map<String, dynamic>> jenisSampah =
        await DatabaseHelper.instance.getAllJenisSampah();
    setState(() {
      _jenisSampahList = jenisSampah;
      if (_jenisSampahList.isNotEmpty) {
        _selectedJenisSampah = _jenisSampahList[0]['id_jenis_sampah'];
      }
    });
  }

  // Fungsi Tambah / Membuat transaksi
  void _addTransaksi() async {
    if (_selectedAnggota == null ||
        _selectedJenisSampah == null ||
        _beratController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua bidang harus diisi')),
      );
      return;
    }

    // Membuat format tanggal jam
    try {
      DateTime now = DateTime.now();
      String tanggalTransaksi = now.toIso8601String();
      String tanggalUpdate = now.toIso8601String();

      double berat = double.tryParse(_beratController.text) ?? 0.0;

      if (berat <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berat tidak boleh dibawah 1')),
        );
        return;
      }

      // Perhitungan total harga (berat x harga jenis sampah)
      int hargaPerKg = _jenisSampahList.firstWhere((element) =>
          element[DatabaseHelper.columnIdJenisSampah] ==
          _selectedJenisSampah)[DatabaseHelper.columnHargaJenisSampah];
      int totalHarga = (hargaPerKg * berat)
          .toInt(); // Menggunakan .toInt() untuk memastikan totalHarga bertipe integer

      // Mapping data yang akan dikirim
      Map<String, dynamic> transaksiData = {
        DatabaseHelper.columnIdAnggota: _selectedAnggota,
        DatabaseHelper.columnIdJenisSampahTransaksi: _selectedJenisSampah,
        DatabaseHelper.columnTanggalTransaksi: tanggalTransaksi,
        DatabaseHelper.columnTanggalUpdate: tanggalUpdate,
        DatabaseHelper.columnBerat: berat,
        DatabaseHelper.columnTotalHarga: totalHarga,
      };

      // Debug Log
      if (kDebugMode) {
        print("Adding transaction with data: $transaksiData");
      }

      // Kirim data ke database helper untuk disimpan ke database
      int idTransaksi =
          await DatabaseHelper.instance.insertTransaksi(transaksiData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi berhasil disimpan')),
      );

      setState(() {
        _beratController.clear();
        _totalHarga = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan transaksi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: _selectedAnggota,
              items: _anggotaList.map<DropdownMenuItem<int>>((anggota) {
                return DropdownMenuItem<int>(
                  value: anggota[DatabaseHelper.columnId],
                  child: Text(anggota[DatabaseHelper.columnNama]),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAnggota = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Pilih Anggota',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: _selectedJenisSampah,
              items: _jenisSampahList.map<DropdownMenuItem<int>>((jenisSampah) {
                return DropdownMenuItem<int>(
                  value: jenisSampah[DatabaseHelper.columnIdJenisSampah],
                  child:
                      Text(jenisSampah[DatabaseHelper.columnNamaJenisSampah]),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedJenisSampah = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Pilih Jenis Sampah',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _beratController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Berat (Kg)',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTransaksi,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan Transaksi'),
            ),
          ],
        ),
      ),
    );
  }
}
