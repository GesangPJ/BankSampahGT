// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'tambah_anggota.dart';

class DaftarAnggota extends StatefulWidget {
  const DaftarAnggota({super.key});

  @override
  _DaftarAnggotaState createState() => _DaftarAnggotaState();
}

class _DaftarAnggotaState extends State<DaftarAnggota> {
  late Future<List<Map<String, dynamic>>> anggotaList;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      anggotaList = DatabaseHelper.instance.getAllAnggota();
    });
  }

  Future<void> _deleteAnggota(int id) async {
    await DatabaseHelper.instance.deleteAnggota(id);
    _refreshData();
  }

  void _showEditDeleteDialog(Map<String, dynamic> anggota) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit atau Hapus?'),
          content: const Text(
              'Apakah anda ingin edit atau menghapus data anggota ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahAnggota(
                      anggota: anggota,
                      isEdit: true,
                    ),
                  ),
                ).then((value) => _refreshData());
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteAnggota(anggota['id']);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Anggota berhasil dihapus.')),
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Anggota'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: anggotaList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error memuat data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ditemukan data anggota'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final anggota = snapshot.data![index];
                return GestureDetector(
                  onLongPress: () => _showEditDeleteDialog(anggota),
                  child: Card(
                    margin: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            anggota['nama'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                anggota['no_telepon'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            anggota['alamat'],
                            style: const TextStyle(
                              fontSize: 12,
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
    );
  }
}
