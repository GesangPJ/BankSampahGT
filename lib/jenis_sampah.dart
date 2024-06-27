// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'tambah_jenis_sampah.dart';

class DaftarJenisSampah extends StatefulWidget {
  const DaftarJenisSampah({super.key});

  @override
  _DaftarJenisSampahState createState() => _DaftarJenisSampahState();
}

class _DaftarJenisSampahState extends State<DaftarJenisSampah> {
  late Future<List<Map<String, dynamic>>> jenisSampahList;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      jenisSampahList = DatabaseHelper.instance.getAllJenisSampah();
    });
  }

  Future<void> _deleteJenisSampah(int id) async {
    await DatabaseHelper.instance.deleteJenisSampah(id);
    _refreshData();
  }

  void _showEditDeleteDialog(Map<String, dynamic> jenisSampah) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit atau Hapus?'),
          content: const Text(
              'Apakah anda ingin edit atau menghapus jenis sampah ini?'),
          actions: [
            TextButton(
              onPressed: () async {
                final navigator =
                    Navigator.of(context); // Capture navigator instance
                final scaffoldMessenger =
                    ScaffoldMessenger.of(context); // Capture scaffold messenger

                await _deleteJenisSampah(jenisSampah['id_jenis_sampah']);
                navigator.pop(); // Use the captured navigator instance
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Jenis Sampah berhasil dihapus.'),
                  ),
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddJenisSampah() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TambahJenisSampah()),
    );
    _refreshData(); // Refresh data setelah tambah jenis sampah baru
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Jenis Sampah'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: jenisSampahList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error memuat data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ditemukan jenis sampah'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final jenisSampah = snapshot.data![index];
                return GestureDetector(
                  onLongPress: () => _showEditDeleteDialog(jenisSampah),
                  child: Card(
                    margin: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                jenisSampah['nama_jenis_sampah'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _navigateToEditJenisSampah(
                                        jenisSampah['id_jenis_sampah']);
                                  } else if (value == 'delete') {
                                    _deleteJenisSampah(
                                        jenisSampah['id_jenis_sampah']);
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    ),
                                  ),
                                  // Menu Hapus Jenis Sampah
                                  // const PopupMenuItem(
                                  //   value: 'delete',
                                  //   child: ListTile(
                                  //     leading: Icon(Icons.delete),
                                  //     title: Text('Hapus'),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Harga per Kg: Rp ${jenisSampah['harga_jenis_sampah']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddJenisSampah,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToEditJenisSampah(int id) async {
    final navigator = Navigator.of(context); // Capture the navigator instance
    Map<String, dynamic>? jenisSampah =
        await DatabaseHelper.instance.getJenisSampahById(id);
    if (jenisSampah != null) {
      await navigator.push(
        MaterialPageRoute(
          builder: (context) => TambahJenisSampah(
            jenisSampah: jenisSampah,
          ),
        ),
      );
      _refreshData();
    }
  }
}
