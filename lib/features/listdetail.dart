import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const DetailPage({Key? key, required this.user}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Detail Pengguna:'),
            Text('Nama: ${widget.user['nama'] ?? 'No Name'}'),
            Text('Tingkatan: ${_isAccepted ? '2' : widget.user['tingkatan'] ?? 'Unknown'}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isAccepted = true;
                });
              },
              child: Text('Pengajuan Diterima'),
            ),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika ketika pengajuan tidak diterima jika diperlukan
              },
              child: Text('Pengajuan Tidak Diterima'),
            ),
          ],
        ),
      ),
    );
  }
}
