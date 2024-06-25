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
  const DashboardPage({super.key, required this.title});

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
              Navigator.pop(context); // Tutup laci terlebih dahulu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TambahAnggota()),
              );
            },
          ),
        ]),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Transaksi Terbaru:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
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
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 16,
                      columns: const [
                        DataColumn(label: Text('Tanggal/Jam')),
                        DataColumn(label: Text('Nama')),
                        DataColumn(label: Text('Jenis Sampah')),
                        DataColumn(label: Text('Berat')),
                        DataColumn(label: Text('Total Harga')),
                      ],
                      rows: snapshot.data!.map((transaksi) {
                        return DataRow(cells: [
                          DataCell(Text(transaksi['tanggal_transaksi'])),
                          DataCell(Text(transaksi['nama_anggota'])),
                          DataCell(Text(transaksi['jenis_sampah'])),
                          DataCell(Text('${transaksi['berat']} kg')),
                          DataCell(Text('Rp ${transaksi['total_harga']}')),
                        ]);
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
