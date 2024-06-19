import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sarprasonlinemobile/database/api.dart';
import 'package:sarprasonlinemobile/features/listdetail.dart';
import 'package:sarprasonlinemobile/features/formlist.dart';

class UserListView extends StatefulWidget {
  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  List<dynamic> users = []; // List untuk menyimpan data user
  List<dynamic> peminjaman = []; // List untuk menyimpan data user
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

 Future<void> _loadUsers() async {
  var urls = [
    Api.InventoryPengajuan,
    // tambahkan URL API untuk data peminjaman di sini jika diperlukan
  ];
  var url = Uri.parse(urls[_selectedIndex]);
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data != null && data['siswa'] != null) {
      setState(() {
        // Jika data siswa tersedia, simpan ke dalam variabel users
        users = data['siswa']; 
      });
    }
    if (data != null && data['data_peminjaman'] != null) {
      setState(() {
        // Jika data peminjaman tersedia, simpan ke dalam variabel peminjaman
        peminjaman = data['data_peminjaman']; 
      });
    }
  } else {
    // Handle jika gagal mengambil data dari API
    print('Failed to load data');
  }
}


  Future<void> _deleteUser(int id) async {
    var url = Uri.parse('${Api.InventoryPengajuan}/$id'); // URL untuk menghapus pengguna
    var response = await http.delete(url);
    print(response.body);
    if (response.statusCode == 200) {
      // Jika pengguna berhasil dihapus, muat ulang daftar pengguna
      _loadUsers();
    } else {
      // Handle jika gagal menghapus pengguna
      print('Failed to delete user');
      // Tampilkan pesan kesalahan kepada pengguna jika perlu
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final peminjaman = users[index];
          return ListTile(
            title: Text(user['nama'] ?? 'No Name'), // Menampilkan nama user
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kelas: ${user['kelas'] ?? 'Unknown'}'), // Menampilkan tingkatan
                Text('Merek: ${peminjaman['merkbarang'] ?? 'Unknown'}'), // Menampilkan tingkatan
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman detail.dart dengan mengirimkan data pengguna yang sesuai
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailPage(user: user)),
                    );
                  },
                  child: Text('Detail'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman detail.dart dengan mengirimkan data pengguna yang sesuai
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailPage(user: user,)),
                    );
                  },
                  child: Text('Edit'),
                ),
                SizedBox(width: 8), // Spasi antara tombol
                ElevatedButton(
                  onPressed: () {
                    _deleteUser(user['id']);
                  },
                  child: Text('Hapus'),
                ),
              ],
            ),
          );
        },
      ),
       floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Tambahkan logika untuk menangani tombol "Tambahkan Barang" di sini
        // Misalnya, buka halaman untuk menambahkan barang baru
        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FormList()),
                    );
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
    ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
