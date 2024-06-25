import 'package:flutter/material.dart';
import 'package:bank_sampah_gt/database_helper.dart';

class TambahJenisSampah extends StatefulWidget {
  final Map<String, dynamic>?
      jenisSampah; // Parameter jenisSampah untuk edit mode

  const TambahJenisSampah({super.key, this.jenisSampah});

  @override
  State<TambahJenisSampah> createState() => _TambahJenisSampahState();
}

class _TambahJenisSampahState extends State<TambahJenisSampah> {
  late TextEditingController _namaJenisSampahController;
  late TextEditingController _hargaJenisSampahController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers and set initial values if in edit mode
    _namaJenisSampahController = TextEditingController(
        text: widget.jenisSampah != null
            ? widget.jenisSampah!['nama_jenis_sampah']
            : '');
    _hargaJenisSampahController = TextEditingController(
        text: widget.jenisSampah != null
            ? widget.jenisSampah!['harga_jenis_sampah'].toString()
            : '');
  }

  @override
  void dispose() {
    // Clean up controllers
    _namaJenisSampahController.dispose();
    _hargaJenisSampahController.dispose();
    super.dispose();
  }

  void _addJenisSampah() async {
    String namaJenisSampah = _namaJenisSampahController.text;
    int hargaJenisSampah = int.tryParse(_hargaJenisSampahController.text) ?? 0;

    if (namaJenisSampah.isEmpty || hargaJenisSampah <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon masukkan data yang valid')),
      );
      return;
    }

    try {
      if (widget.jenisSampah == null) {
        // Insert new jenis sampah
        await DatabaseHelper.instance.insertJenisSampah({
          'nama_jenis_sampah': namaJenisSampah,
          'harga_jenis_sampah': hargaJenisSampah,
        });
      } else {
        // Update existing jenis sampah
        await DatabaseHelper.instance.updateJenisSampah({
          'id_jenis_sampah': widget.jenisSampah!['id_jenis_sampah'],
          'nama_jenis_sampah': namaJenisSampah,
          'harga_jenis_sampah': hargaJenisSampah,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
              const SnackBar(content: Text('Jenis sampah berhasil disimpan')),
            )
            .closed
            .then((reason) {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        if (e.toString().contains('UNIQUE constraint failed')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nama anggota sudah ada.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menambahkan anggota.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jenisSampah == null
            ? 'Tambah Jenis Sampah'
            : 'Edit Jenis Sampah'),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text(widget.jenisSampah == null
                  ? 'Simpan Jenis Sampah'
                  : 'Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
