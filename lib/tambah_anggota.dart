import 'package:flutter/material.dart';

class TambahAnggota extends StatefulWidget {
  const TambahAnggota({Key? key}) : super(key: key);

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
        title: Text('Tambah Anggota'),
      ),
      body: Center(
        child: Column(
          children: [
TextField(
              decoration: InputDecoration(
                labelText: 'Nama Anggota',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Alamat Anggota',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'No. Telepon Anggota',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),


ElevatedButton(
              onPressed: () {
                // Save member information to database
              },
              child: const Text('Tambah Anggota'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
