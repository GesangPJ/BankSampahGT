// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'database_helper.dart';

class TambahTransaksi extends StatefulWidget {
  const TambahTransaksi({super.key});

  @override
  State<TambahTransaksi> createState() => _TambahTransaksiState();
}

class _TambahTransaksiState extends State<TambahTransaksi> {
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

  void _addTransaksi() async {
    if (_selectedAnggota == null ||
        _selectedJenisSampah == null ||
        _beratController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua bidang harus diisi')),
      );
      return;
    }

    try {
      DateTime now = DateTime.now();
      String tanggalTransaksi =
          '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}';

      int idTransaksi = await DatabaseHelper.instance.insertTransaksi({
        DatabaseHelper.columnIdAnggota: _selectedAnggota,
        DatabaseHelper.columnTanggalTransaksi: tanggalTransaksi,
        DatabaseHelper.columnTanggalUpdate:
            tanggalTransaksi, // Ensure this field is filled
      });

      int berat = int.tryParse(_beratController.text) ?? 0;
      int hargaPerKg = _jenisSampahList.firstWhere((element) =>
          element[DatabaseHelper.columnIdJenisSampah] ==
          _selectedJenisSampah)[DatabaseHelper.columnHargaJenisSampah];
      int totalHarga = hargaPerKg * berat;

      Map<String, dynamic> detailTransaksi = {
        DatabaseHelper.columnIdTransaksiDetail: idTransaksi,
        DatabaseHelper.columnIdJenisSampahDetail: _selectedJenisSampah,
        DatabaseHelper.columnBerat: berat,
        DatabaseHelper.columnTotalHarga: totalHarga,
      };

      await DatabaseHelper.instance.insertDetailTransaksi(detailTransaksi);

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
