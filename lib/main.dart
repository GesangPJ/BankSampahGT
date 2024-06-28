// ignore_for_file: prefer_const_literals_to_create_immutables, use_super_parameters, avoid_print, use_build_context_synchronously

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
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.blue),
        ),
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
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  late TransaksiDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = TransaksiDataSource(context);
  }

  void _sort<T>(
    Comparable<T> Function(Map<String, dynamic> transaksi) getField,
    int columnIndex,
    bool ascending,
  ) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
    _dataSource.sort<T>(getField, ascending);
  }

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
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
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
              leading: const Icon(Icons.insights),
              title: const Text('Laporan'),
              onTap: () {
                Navigator.pop(context);
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DaftarAnggota()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Tambah Anggota'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TambahAnggota()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getAllDataTransaksi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data transaksi tidak ditemukan.'));
          } else {
            _dataSource.setData(snapshot.data!);
            return SingleChildScrollView(
              child: PaginatedDataTable(
                header: const Text('Data Transaksi'),
                rowsPerPage: _rowsPerPage,
                availableRowsPerPage: const [5, 10, 20],
                onRowsPerPageChanged: (value) {
                  setState(() {
                    _rowsPerPage = value!;
                  });
                },
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                columns: [
                  DataColumn(
                    label: const Text('Tanggal/Jam'),
                    onSort: (columnIndex, ascending) => _sort<String>(
                        (d) => d['tanggal_transaksi'].toString(),
                        columnIndex,
                        ascending),
                  ),
                  DataColumn(
                    label: const Text('Nama'),
                    onSort: (columnIndex, ascending) => _sort<String>(
                        (d) => d['nama_anggota'].toString(),
                        columnIndex,
                        ascending),
                  ),
                  DataColumn(
                    label: const Text('Jenis Sampah'),
                    onSort: (columnIndex, ascending) => _sort<String>(
                        (d) => d['jenis_sampah'].toString(),
                        columnIndex,
                        ascending),
                  ),
                  DataColumn(
                    label: const Text('Berat'),
                    onSort: (columnIndex, ascending) => _sort<num>(
                        (d) => d['berat'] as num, columnIndex, ascending),
                  ),
                  DataColumn(
                    label: const Text('Total Harga'),
                    onSort: (columnIndex, ascending) => _sort<num>(
                        (d) => d['total_harga'] as num, columnIndex, ascending),
                  ),
                  const DataColumn(label: Text('Edit')),
                ],
                source: _dataSource,
              ),
            );
          }
        },
      ),
    );
  }

  // ignore: unused_element
  void _showEditDialog(BuildContext context, Map<String, dynamic> transaksi) {
    TextEditingController beratController = TextEditingController(
      text: transaksi['berat'].toString(),
    );

    int idTransaksi = transaksi['id_transaksi'] ?? 0;

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
                _updateTransaksi(context, idTransaksi, beratController.text);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _updateTransaksi(BuildContext context, int id, String berat) async {
    try {
      double newBerat = double.tryParse(berat) ?? 0;
      if (newBerat <= 0) {
        throw Exception('Berat harus lebih besar dari 0.');
      }

      int hargaPerKg =
          await DatabaseHelper.instance.getHargaPerKgByTransaksiId(id);

      int totalHarga = (newBerat * hargaPerKg).toInt();

      Map<String, dynamic> updatedData = {
        DatabaseHelper.columnBerat: newBerat,
        DatabaseHelper.columnTotalHarga: totalHarga,
        DatabaseHelper.columnTanggalUpdate: DateTime.now().toIso8601String(),
      };

      int result =
          await DatabaseHelper.instance.updateTransaksi(id, updatedData);

      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update transaksi berhasil.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update transaksi gagal.')),
        );
      }

      setState(() {});

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

class TransaksiDataSource extends DataTableSource {
  final BuildContext context;
  List<Map<String, dynamic>> _data = [];

  TransaksiDataSource(this.context);

  void setData(List<Map<String, dynamic>> data) {
    _data = data;
    notifyListeners();
  }

  void sort<T>(Comparable<T> Function(Map<String, dynamic> transaksi) getField,
      bool ascending) {
    _data.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final transaksi = _data[index];
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
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> transaksi) {
    TextEditingController beratController = TextEditingController(
      text: transaksi['berat'].toString(),
    );

    int idTransaksi = transaksi['id_transaksi'] ?? 0;

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
                _updateTransaksi(context, idTransaksi, beratController.text);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _updateTransaksi(BuildContext context, int id, String berat) async {
    try {
      double newBerat = double.tryParse(berat) ?? 0;
      if (newBerat <= 0) {
        throw Exception('Berat harus lebih besar dari 0.');
      }

      int hargaPerKg =
          await DatabaseHelper.instance.getHargaPerKgByTransaksiId(id);

      int totalHarga = (newBerat * hargaPerKg).toInt();

      Map<String, dynamic> updatedData = {
        DatabaseHelper.columnBerat: newBerat,
        DatabaseHelper.columnTotalHarga: totalHarga,
        DatabaseHelper.columnTanggalUpdate: DateTime.now().toIso8601String(),
      };

      int result =
          await DatabaseHelper.instance.updateTransaksi(id, updatedData);

      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update transaksi berhasil.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update transaksi gagal.')),
        );
      }

      notifyListeners();

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
