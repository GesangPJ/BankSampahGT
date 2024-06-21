import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';
import 'tambah_jenis_sampah.dart';
import 'EditJenisSampah.dart';

class DaftarJenisSampah extends StatefulWidget {
  const DaftarJenisSampah({super.key});

  @override
  State<DaftarJenisSampah> createState() => _DaftarJenisSampahState();
}

class _DaftarJenisSampahState extends State<DaftarJenisSampah> {
  List<Map<String, dynamic>> _jenisSampahList = [];

  @override
  void initState() {
    super.initState();
    _fetchJenisSampah();
  }

  Future<void> _fetchJenisSampah() async {
    List<Map<String, dynamic>> jenisSampah =
        await DatabaseHelper.instance.getAllJenisSampah();
    setState(() {
      _jenisSampahList = jenisSampah;
    });
  }

  void _navigateToAddJenisSampah() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TambahJenisSampah()),
    );
    _fetchJenisSampah(); // Refresh data setelah tambah jenis sampah baru
  }

  void _navigateToEditJenisSampah(int id) async {
    Map<String, dynamic>? jenisSampah =
        await DatabaseHelper.instance.getJenisSampahById(id);
    if (jenisSampah != null) {
      // Navigasi ke halaman atau dialog edit jenis sampah
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditJenisSampah(jenisSampah: jenisSampah)),
      );
      _fetchJenisSampah(); // Refresh data setelah edit
    }
  }

  void _deleteJenisSampah(int id) async {
    await DatabaseHelper.instance.deleteJenisSampah(id);
    _fetchJenisSampah(); // Refresh data setelah hapus jenis sampah
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Jenis Sampah'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          DataTable(
            columns: const [
              DataColumn(label: Text('Nama Jenis Sampah')),
              DataColumn(label: Text('Harga per Kg')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: _jenisSampahList
                .map(
                  (jenisSampah) => DataRow(
                    cells: [
                      DataCell(Text(jenisSampah['nama_jenis_sampah'])),
                      DataCell(
                          Text(jenisSampah['harga_jenis_sampah'].toString())),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _navigateToEditJenisSampah(
                                jenisSampah['id_jenis_sampah']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteJenisSampah(
                                jenisSampah['id_jenis_sampah']),
                          ),
                        ],
                      )),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddJenisSampah,
        child: const Icon(Icons.add),
      ),
    );
  }
}
