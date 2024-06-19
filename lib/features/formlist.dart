import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarprasonlinemobile/database/api.dart';
import 'package:sarprasonlinemobile/features/listview.dart';

class FormList extends StatefulWidget {
  @override
  _FormListState createState() => _FormListState();
}

class _FormListState extends State<FormList> {
  // Deklarasi variabel yang akan digunakan
  TextEditingController _namaController = TextEditingController();
  TextEditingController _tingkatanController = TextEditingController();
  TextEditingController _tahun_masukController = TextEditingController();
  TextEditingController _tahun_keluarController = TextEditingController();
  bool _isEditing = false;
  int? _userId;

  // Method untuk mengirim data pengguna baru ke API
  Future<void> _saveUser() async {
    var url = Uri.parse('${Api.InventoryPengajuan}');

    var response = await http.post(
      url,
      body: {
        "nama": _namaController.text,
        "tingkatan": _tingkatanController.text,
        "tahun_masuk": _tahun_masukController.text,
        "tahun_keluar": _tahun_keluarController.text,
      },
    );
    if (response.statusCode == 201) {
     
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserListView()),
      );
    } else {
      print('Failed to save data: ${response.statusCode}');
    }
  }

  // Method untuk mengirim data pengguna yang diedit ke API
  Future<void> _saveEdit(int userId) async {
    var url = Uri.parse('${Api.InventoryPengajuan}/$userId');

    var response = await http.put(
      url,
      body: {
        "nama": _namaController.text,
        "tingkatan": _tingkatanController.text,
        "tahun_masuk": _tahun_masukController.text,
        "tahun_keluar": _tahun_keluarController.text,
      },
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserListView()),
      );
    } else {
      print('Failed to update data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List Form'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Tambahkan form untuk input data pengguna
          TextField(
            controller: _namaController,
            decoration: InputDecoration(labelText: 'Nama'),
          ),
          TextField(
            controller: _tingkatanController,
            decoration: InputDecoration(labelText: 'Tingkatan'),
          ),
          TextField(
            controller: _tahun_masukController,
            decoration: InputDecoration(labelText: 'Tahun Masuk'),
          ),
          TextField(
            controller: _tahun_keluarController,
            decoration: InputDecoration(labelText: 'Tahun Keluar'),
          ),
          // Tambahkan tombol "Simpan" untuk menyimpan data
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _isEditing ? () => _saveEdit(_userId!) : _saveUser,
            child: Text(_isEditing ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }
}
