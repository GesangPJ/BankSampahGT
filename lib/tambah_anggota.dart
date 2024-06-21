import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class TambahAnggota extends StatefulWidget {
  final Map<String, dynamic>? anggota;
  final bool isEdit;

  const TambahAnggota({super.key, this.anggota, this.isEdit = false});

  @override
  State<TambahAnggota> createState() => _TambahAnggotaState();
}

class _TambahAnggotaState extends State<TambahAnggota> {
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTeleponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.anggota != null) {
      _namaController.text = widget.anggota!['nama'];
      _alamatController.text = widget.anggota!['alamat'];
      _noTeleponController.text = widget.anggota!['no_telepon'];
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _noTeleponController.dispose();
    super.dispose();
  }

  Future<void> _saveMember() async {
    String nama = _namaController.text;
    String alamat = _alamatController.text;
    String noTelepon = _noTeleponController.text;

    if (nama.isNotEmpty && alamat.isNotEmpty && noTelepon.isNotEmpty) {
      // Create a map of the data
      Map<String, dynamic> row = {
        DatabaseHelper.columnNama: nama,
        DatabaseHelper.columnAlamat: alamat,
        DatabaseHelper.columnNoTelepon: noTelepon,
      };

      try {
        if (widget.isEdit) {
          final id = widget.anggota!['id'];
          await DatabaseHelper.instance.updateAnggota(id, row);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Anggota berhasil diperbarui.')),
          );
        } else {
          final id = await DatabaseHelper.instance.insertAnggota(row);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Anggota berhasil ditambahkan dengan ID: $id')),
          );
        }
        Navigator.pop(context);
      } catch (e) {
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
    } else {
      // Show an alert if the form is incomplete
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Form Incomplete'),
            content: const Text('Please fill all fields'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isEdit
            ? const Text('Edit Anggota')
            : const Text('Tambah Anggota'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Anggota',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _alamatController,
              decoration: const InputDecoration(
                labelText: 'Alamat Anggota',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _noTeleponController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'No. Telepon Anggota',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMember,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child:
                  Text(widget.isEdit ? 'Perbarui Anggota' : 'Tambah Anggota'),
            ),
          ],
        ),
      ),
    );
  }
}
