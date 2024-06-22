import 'package:flutter/material.dart';
import 'database_helper.dart';

class TambahTransaksi extends StatefulWidget {
  const TambahTransaksi({Key? key}) : super(key: key);

  @override
  State<TambahTransaksi> createState() => _TambahTransaksiState();
}

class _TambahTransaksiState extends State<TambahTransaksi> {
  int _selectedAnggota = 1; // Contoh ID anggota
  List<Map<String, dynamic>> _jenisSampahList = [];
  List<TextEditingController> _controllers = [];
  int _totalHarga = 0;

  @override
  void initState() {
    super.initState();
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
    // Simpan transaksi ke tabel transaksi
    String tanggalTransaksi = DateTime.now().toString();
    int idTransaksi = await DatabaseHelper.instance.insertTransaksi({
      'id_anggota': _selectedAnggota,
      'jumlah_transaksi':
          _jenisSampahList.length, // Contoh jumlah sampah dalam transaksi
      'tanggal_transaksi': tanggalTransaksi,
    });

    // Loop untuk menyimpan detail transaksi ke tabel detail_transaksi
    for (int i = 0; i < _jenisSampahList.length; i++) {
      int berat = int.tryParse(_controllers[i].text) ?? 0;
      int totalHarga = _jenisSampahList[i]['harga_jenis_sampah'] * berat;

      await DatabaseHelper.instance.insertDetailTransaksi({
        'id_transaksi': idTransaksi,
        'id_jenis_sampah': _jenisSampahList[i]['id_jenis_sampah'],
        'berat': berat,
        'total_harga': totalHarga,
      });

      _totalHarga += totalHarga;
    }

    // Tampilkan pesan sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaksi berhasil disimpan')),
    );

    // Kembali ke halaman sebelumnya
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: _selectedAnggota,
              items: [
                const DropdownMenuItem<int>(
                  value: 1, // Contoh ID anggota
                  child: Text(
                      'Anggota A'), // Ganti dengan nama anggota atau ambil dari database
                ),
              ],
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
              itemCount: _jenisSampahList.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Jenis Sampah: ${_jenisSampahList[index]['nama_jenis_sampah']}'),
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
              child: const Text('Simpan Transaksi'),
            ),
          ],
        ),
      ),
    );
  }
}
