//Backup kode NOTEPAD

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import modul SystemNavigator

void main() {
  runApp(NotepadApp());
}

class NotepadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notepad',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotepadPage(),
    );
  }
}

class NotepadPage extends StatefulWidget {
  @override
  _NotepadPageState createState() => _NotepadPageState();
}

class _NotepadPageState extends State<NotepadPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();

  final List<Map<String, String>> _catatanDisimpan = [];
  final List<Map<String, String>> _catatanDiarsipkan = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notepad'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Ahmad Sidik Muttaqin'),
              accountEmail: Text('ahmadsidikmuttaqin@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              title: const Text('Arsip'),
              onTap: () {
                _tampilkanArsip();
              },
            ),
            const Divider(), // Tambah garis
            ListTile(
              leading: const Icon(
                  Icons.power_settings_new), // Ikon shutdown di samping teks
              title: const Text('Keluar Aplikasi'),
              onTap: () {
                Navigator.of(context).pop();
                // Menutup aplikasi
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _catatanDisimpan.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_catatanDisimpan[index]['judul']!),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: const Icon(
                      Icons.archive,
                      color: Colors.white,
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      _hapusCatatan(index);
                    } else if (direction == DismissDirection.startToEnd) {
                      _pindahKeArsip(index);
                    }
                  },
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _catatanDisimpan[index]['judul']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _catatanDisimpan[index]['isi']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _editCatatan(index);
                        },
                      ),
                      const Divider(), // Menambahkan garis setelah setiap item daftar
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _buatCatatan();
        },
        tooltip: 'Buat Catatan',
        child: const Icon(Icons.note_add),
      ),
    );
  }

  void _buatCatatan() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buat Catatan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _judulController,
                  decoration: const InputDecoration(labelText: 'Judul'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _isiController,
                  decoration: const InputDecoration(labelText: 'Isi Catatan'),
                  maxLines: null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _simpanCatatan();
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _editCatatan(int index) {
    _judulController.text = _catatanDisimpan[index]['judul']!;
    _isiController.text = _catatanDisimpan[index]['isi']!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Catatan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _judulController,
                  decoration: const InputDecoration(labelText: 'Judul'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _isiController,
                  decoration: const InputDecoration(labelText: 'Isi Catatan'),
                  maxLines: null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _simpanCatatan(index);
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _simpanCatatan([int? index]) {
    String judul = _judulController.text;
    String isi = _isiController.text;
    setState(() {
      if (index != null) {
        _catatanDisimpan[index] = {'judul': judul, 'isi': isi};
        _tampilkanSnackBar('Catatan berhasil diperbarui');
      } else {
        _catatanDisimpan.add({'judul': judul, 'isi': isi});
        _tampilkanSnackBar('Catatan berhasil disimpan');
      }
      _judulController.clear();
      _isiController.clear();
    });
  }

  void _hapusCatatan(int index) {
    setState(() {
      _catatanDisimpan.removeAt(index);
    });
    _tampilkanSnackBar('Catatan berhasil dihapus');
  }

  void _tampilkanArsip() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HalamanArsip(catatanDiarsipkan: _catatanDiarsipkan),
      ),
    );
  }

  void _pindahKeArsip(int index) {
    setState(() {
      Map<String, String> catatan = _catatanDisimpan[index];
      _catatanDisimpan.removeAt(index);
      _catatanDiarsipkan.add(catatan);
    });
    _tampilkanSnackBar('Catatan berhasil dipindahkan ke arsip');
  }

  void _tampilkanSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }
}

class HalamanArsip extends StatefulWidget {
  final List<Map<String, String>> catatanDiarsipkan;

  const HalamanArsip({required this.catatanDiarsipkan});

  @override
  _HalamanArsipState createState() => _HalamanArsipState();
}

class _HalamanArsipState extends State<HalamanArsip> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arsip'),
      ),
      body: ListView.builder(
        itemCount: widget.catatanDiarsipkan.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(widget.catatanDiarsipkan[index]['judul']!),
            direction: DismissDirection.horizontal,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              color: Colors.green,
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.archive,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                _hapusDariArsip(index);
              } else if (direction == DismissDirection.startToEnd) {
                _pindahKeHalamanUtama(index);
              }
            },
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.catatanDiarsipkan[index]['judul']!,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.catatanDiarsipkan[index]['isi']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              onTap: () {
                _editCatatan(index);
              },
            ),
          );
        },
      ),
    );
  }

  void _editCatatan(int index) {
    _judulController.text = widget.catatanDiarsipkan[index]['judul']!;
    _isiController.text = widget.catatanDiarsipkan[index]['isi']!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Catatan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _judulController,
                  decoration: const InputDecoration(labelText: 'Judul'),
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _isiController,
                  decoration: const InputDecoration(labelText: 'Isi Catatan'),
                  maxLines: null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _simpanCatatan(index);
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _simpanCatatan(int index) {
    String judul = _judulController.text;
    String isi = _isiController.text;
    setState(() {
      widget.catatanDiarsipkan[index] = {'judul': judul, 'isi': isi};
      _judulController.clear();
      _isiController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil diperbarui'),
        ),
      );
    });
  }

  void _hapusDariArsip(int index) {
    setState(() {
      widget.catatanDiarsipkan.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan berhasil dihapus dari arsip'),
      ),
    );
  }

  void _pindahKeCatatanDisimpan(int index) {
    setState(() {
      Map<String, String> catatan = widget.catatanDiarsipkan[index];
      widget.catatanDiarsipkan.removeAt(index);
      var _catatanDisimpan; // Menggunakan variabel _catatanDisimpan dari halaman utama
      _catatanDisimpan.add(catatan);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan berhasil dipindahkan ke halaman utama'),
      ),
    );
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  void _pindahKeHalamanUtama(int index) {}
}
