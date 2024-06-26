// ignore_for_file: prefer_const_literals_to_create_immutables, use_super_parameters, avoid_print

import 'package:bank_sampah_gt/tambah_anggota.dart';
import 'package:flutter/material.dart';
import 'package:bank_sampah_gt/daftar_anggota.dart';
import 'package:bank_sampah_gt/jenis_sampah.dart';
import 'package:bank_sampah_gt/transaksi_sampah.dart';
import 'package:bank_sampah_gt/database_helper.dart';

void main() {
  runApp(const BankSampahGT());
}

class BankSampahGT extends StatelessWidget {
  const BankSampahGT({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Sampah GT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardPage(title: 'Bank Sampah GT'),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Transaksi Sampah'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TambahTransaksi()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Jenis Sampah'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DaftarJenisSampah()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Print / Ekspor Data'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Daftar Anggota'),
            onTap: () {
              Navigator.pop(context); // Close the drawer if you have one
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DaftarAnggota()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Tambah Anggota'),
            onTap: () {
              Navigator.pop(context); // Close the drawer if you have one
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TambahAnggota()),
              );
            },
          ),
        ]),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: DatabaseHelper.instance.getAllDataTransaksi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('Data transaksi tidak ditemukan.'));
              } else {
                return DataTable(
                  columnSpacing: 10,
                  columns: [
                    const DataColumn(label: Text('Tanggal/Jam')),
                    const DataColumn(label: Text('Nama')),
                    const DataColumn(label: Text('Jenis Sampah')),
                    const DataColumn(label: Text('Berat')),
                    const DataColumn(label: Text('Total Harga')),
                    const DataColumn(label: Text('Aksi')),
                  ],
                  rows: snapshot.data!.map((transaksi) {
                    return DataRow(cells: [
                      DataCell(Text(transaksi['tanggal_transaksi'].toString())),
                      DataCell(Text(transaksi['nama_anggota'].toString())),
                      DataCell(Text(transaksi['jenis_sampah'].toString())),
                      DataCell(Text('${transaksi['berat']} kg')),
                      DataCell(Text('Rp ${transaksi['total_harga']}')),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(context, transaksi);
                          },
                        ),
                      ),
                    ]);
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> transaksi) {
    TextEditingController beratController = TextEditingController(
      text: transaksi['berat'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Transaksi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: beratController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Berat (Kg)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                print('Simpan button pressed');
                _updateTransaksi(
                    transaksi['id_transaksi'], beratController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _updateTransaksi(int id, String berat) async {
    try {
      print('UpdateTransaksi dipanggil dengan ID: $id dan berat: $berat');
      int newBerat = int.tryParse(berat) ?? 0;
      if (newBerat <= 0) {
        throw Exception('Berat harus lebih besar dari 0.');
      }

      // Dapatkan harga per kilogram dari jenis sampah yang sesuai
      int hargaPerKg =
          await DatabaseHelper.instance.getHargaPerKgByTransaksiId(id);
      int totalHarga = newBerat * hargaPerKg;

      Map<String, dynamic> updatedData = {
        DatabaseHelper.columnBerat: newBerat,
        DatabaseHelper.columnTotalHarga: totalHarga,
        DatabaseHelper.columnTanggalUpdate: DateTime.now().toIso8601String(),
      };

      int result =
          await DatabaseHelper.instance.updateTransaksi(id, updatedData);

      if (result > 0) {
        // Jika update berhasil, cetak pesan log
        print('Update transaksi berhasil.');
      } else {
        // Jika update gagal, cetak pesan log
        print('Update transaksi gagal.');
      }

      // Memperbarui UI
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }
}
