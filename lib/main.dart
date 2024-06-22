import 'package:bank_sampah_gt/tambah_anggota.dart';
import 'package:flutter/material.dart';
import 'package:bank_sampah_gt/daftar_anggota.dart';
import 'package:bank_sampah_gt/jenis_sampah.dart';
import 'package:bank_sampah_gt/transaksi_sampah.dart';
//import 'package:bank_sampah_gt/tambah_jenis_sampah.dart';

void main() {
  runApp(const BankSampahGT());
}

class BankSampahGT extends StatelessWidget {
  const BankSampahGT({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Sampah GT',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
                      builder: (context) => const TambahTransaksi()));
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
                      builder: (context) => const DaftarJenisSampah()));
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
        ])));
  }
}
