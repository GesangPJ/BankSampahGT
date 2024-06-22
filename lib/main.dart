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
      home: const MyHomePage(title: 'Bank Sampah GT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          // Add a button to open the drawer
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
            child: ListView(padding: EdgeInsets.zero, children: [
          const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu')),
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
            title: const Text('Anggota'),
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
