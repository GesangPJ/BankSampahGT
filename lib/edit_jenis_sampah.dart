// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'database_helper.dart';

class EditJenisSampah extends StatefulWidget {
  final Map<String, dynamic> jenisSampah;

  const EditJenisSampah({super.key, required this.jenisSampah});

  @override
  _EditJenisSampahState createState() => _EditJenisSampahState();
}

class _EditJenisSampahState extends State<EditJenisSampah> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  // GlobalKey for ScaffoldMessengerState
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _namaController.text = widget.jenisSampah['nama_jenis_sampah'];
    _hargaController.text = widget.jenisSampah['harga_jenis_sampah'].toString();
  }

  void _updateJenisSampah() async {
    String nama = _namaController.text.trim();
    int harga = int.tryParse(_hargaController.text.trim()) ?? 0;

    if (nama.isEmpty || harga <= 0) {
      _showSnackBar('Mohon masukkan data yang valid');
      return;
    }

    Map<String, dynamic> updatedData = {
      'id_jenis_sampah': widget.jenisSampah['id_jenis_sampah'],
      'nama_jenis_sampah': nama,
      'harga_jenis_sampah': harga,
    };

    await DatabaseHelper.instance.updateJenisSampah(updatedData);

    _showSnackBar('Jenis sampah berhasil diupdate');
    Navigator.pop(context); // Kembali ke halaman sebelumnya setelah update
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey, // Assign GlobalKey to Scaffold
      appBar: AppBar(
        title: const Text('Edit Jenis Sampah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Jenis Sampah'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _hargaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Harga per Kg'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateJenisSampah,
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
