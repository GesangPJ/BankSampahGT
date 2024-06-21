import 'package:flutter/material.dart';

class TambahAnggota extends StatefulWidget {
  const TambahAnggota({super.key});

  @override
  State<TambahAnggota> createState() => _TambahAnggotaState();
}

class _TambahAnggotaState extends State<TambahAnggota> {
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTeleponController = TextEditingController();
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Anggota'),
      ),
      body: Center(
        child: Column(
          children: [
const TextField(
              decoration: InputDecoration(
                labelText: 'Nama Anggota',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Alamat Anggota',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'No. Telepon Anggota',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),


ElevatedButton(
              onPressed: () {
                // Save member information to database
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tambah Anggota'),
            ),

          ],
        ),
      ),
    );
  }
}
