import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class TambahJenisSampah extends StatefulWidget {
  const TambahJenisSampah({super.key});

  @override
  State<TambahJenisSampah> createState() => _TambahJenisSampahState();
}

class _TambahJenisSampahState extends State<TambahJenisSampah> {
  final _namaJenisSampahController = TextEditingController();
  final _hargaJenisSampahController = TextEditingController();

  void _addJenisSampah() async {
    String namaJenisSampah = _namaJenisSampahController.text;
    int hargaJenisSampah = int.tryParse(_hargaJenisSampahController.text) ?? 0;

    if (namaJenisSampah.isEmpty || hargaJenisSampah <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon masukkan data yang valid')),
      );
      return;
    }

    await DatabaseHelper.instance.insertJenisSampah({
      'nama_jenis_sampah': namaJenisSampah,
      'harga_jenis_sampah': hargaJenisSampah,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Jenis sampah berhasil ditambahkan')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Jenis Sampah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaJenisSampahController,
              decoration: const InputDecoration(
                labelText: 'Nama Jenis Sampah',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _hargaJenisSampahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga per Kg',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addJenisSampah,
              child: const Text('Simpan Jenis Sampah'),
            ),
          ],
        ),
      ),
    );
  }
}
