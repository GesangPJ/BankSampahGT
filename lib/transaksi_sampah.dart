import 'package:flutter/material.dart';
import 'database_helper.dart';

class TambahTransaksi extends StatefulWidget {
  const TambahTransaksi({Key? key}) : super(key: key);

  @override
  State<TambahTransaksi> createState() => _TambahTransaksiState();
}

class _TambahTransaksiState extends State<TambahTransaksi> {
  int _selectedAnggota = 1; // Default ID anggota
  List<Map<String, dynamic>> _anggotaList = [];
  List<Map<String, dynamic>> _jenisSampahList = [];
  List<TextEditingController> _controllers = [];
  int _totalHarga = 0;

  @override
  void initState() {
    super.initState();
    _fetchAnggota();
    _fetchJenisSampah();
  }

  @override
  void dispose() {
    // Clean up controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
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
      _controllers = List.generate(
          _jenisSampahList.length, (index) => TextEditingController());
    });
  }

  void _addTransaksi() async {
    try {
      // Save transaction to 'transaksi' table
      DateTime now = DateTime.now();
      String tanggalTransaksi =
          '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}';

      // Step 1: Insert into 'transaksi' table
      int idTransaksi = await DatabaseHelper.instance.insertTransaksi({
        DatabaseHelper.columnIdAnggota: _selectedAnggota,
        DatabaseHelper.columnTanggalTransaksi: tanggalTransaksi,
      });

      // Step 2: Insert detail transaksi into 'detail_transaksi' table
      for (int i = 0; i < _jenisSampahList.length; i++) {
        int berat = int.tryParse(_controllers[i].text) ?? 0;
        int totalHarga =
            _jenisSampahList[i][DatabaseHelper.columnHargaJenisSampah] * berat;

        // Prepare data for detail transaksi
        Map<String, dynamic> detailTransaksi = {
          DatabaseHelper.columnIdTransaksiDetail: idTransaksi,
          DatabaseHelper.columnIdJenisSampahDetail: _jenisSampahList[i]
              [DatabaseHelper.columnIdJenisSampah],
          DatabaseHelper.columnBerat: berat,
          DatabaseHelper.columnTotalHarga: totalHarga,
        };

        // Insert detail transaksi into database
        await DatabaseHelper.instance.insertDetailTransaksi(detailTransaksi);

        _totalHarga += totalHarga;
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi berhasil disimpan')),
      );

      // Clear input values after successful save
      setState(() {
        for (var controller in _controllers) {
          controller.clear();
        }
        _totalHarga = 0;
      });
    } catch (e) {
      // Show error message
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
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _jenisSampahList.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Jenis Sampah: ${_jenisSampahList[index][DatabaseHelper.columnNamaJenisSampah]}'),
                    TextField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Berat (Kg)',
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
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
