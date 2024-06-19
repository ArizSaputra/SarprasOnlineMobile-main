import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sarprasonlinemobile/database/api.dart';
import 'package:sarprasonlinemobile/common_widgets/appbar/appbar.dart';

const _blueColor = Color(0xFF3B82F6);

class TambahBarangPage extends StatefulWidget {
  const TambahBarangPage({super.key});

  @override
  State<TambahBarangPage> createState() => _TambahBarangPageState();
}

class _TambahBarangPageState extends State<TambahBarangPage> {
  int _counter = 0;
  List<TextEditingController> _serialControllers = [];
  List<TextEditingController> _brandControllers = [];
  TextEditingController _namaBarangController = TextEditingController();
  File? _selectedImage;
  String _userDepartment = '';

  @override
  void initState() {
    super.initState();
    _updateControllers();
    _loadUserDepartment();
  }

  void _updateControllers() {
    while (_serialControllers.length < _counter) {
      _serialControllers.add(TextEditingController());
      _brandControllers.add(TextEditingController());
    }
    while (_serialControllers.length > _counter) {
      _serialControllers.removeLast();
      _brandControllers.removeLast();
    }
  }

  Future<void> _loadUserDepartment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userDepartment = prefs.getString('user_department') ?? '';
    });
  }

  Future<void> _openGallery() async {
    var imagePicker = ImagePicker();
    var pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _increment() {
    setState(() {
      _counter++;
      _updateControllers();
    });
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) {
        _counter--;
        _updateControllers();
      }
    });
  }

  Future<void> _submitData() async {
    final url = Uri.parse('${Api.addItem}');
    var request = http.MultipartRequest('POST', url);
    request.fields['nama_barang'] = _namaBarangController.text;
    request.fields['jurusan'] = _userDepartment; // Include department

    for (int i = 0; i < _counter; i++) {
      request.fields['nomor_seri[$i]'] = _serialControllers[i].text;
      request.fields['merk[$i]'] = _brandControllers[i].text;
    }

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'gambar_barang',
        _selectedImage!.path,
      ));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      print('Response: $respStr');
      // Show success alert
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Data berhasil disimpan!',
      );
    } else {
      print('Failed to upload data');
      // Show error alert
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Data gagal disimpan!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF1F1F1),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(
                showBackArrow: true,
                title: Text(
                  "Add Items",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 18),
                child: Form(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nama Barang",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: _namaBarangController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 1.5),
                                    ),
                                    counterText: '',
                                    hintText: 'Masukkan nama barang',
                                    hintStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black12,
                                    ),
                                  ),
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Form ini wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jumlah Alat",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Colors.black54, fontSize: 17),
                                  ),
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(
                                      text: '$_counter'),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: _increment,
                                      icon: Icon(Icons.add_circle,
                                          size: 37,
                                          color: Colors.blue.withOpacity(0.8)),
                                    ),
                                    prefixIcon: IconButton(
                                      onPressed: _decrement,
                                      icon: Icon(Icons.remove_circle,
                                          size: 37,
                                          color: Colors.blue.withOpacity(0.8)),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Form ini wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _counter,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Nomer Seri",
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 17),
                                          ),
                                        ),
                                        TextFormField(
                                          controller:
                                              _serialControllers[index],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.blue,
                                                  width: 1.5),
                                            ),
                                            counterText: '', // Hide counter text
                                            hintText: 'Masukkan nomer seri',
                                            hintStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black12,
                                            ),
                                          ),
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Form ini wajib diisi';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Merk Barang",
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 17),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: _brandControllers[index],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.blue,
                                                  width: 1.5),
                                            ),
                                            counterText: '', // Hide counter text
                                            hintText: 'Masukkan merk barang',
                                            hintStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black12,
                                            ),
                                          ),
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Form ini wajib diisi';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Foto Barang",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: Colors.black54, fontSize: 17),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _openGallery();
                            },
                            child: Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: _selectedImage == null
                                    ? const Icon(Icons.add_photo_alternate,
                                        color: Colors.grey, size: 50)
                                    : Image.file(_selectedImage!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  title: 'Konfirmasi',
                  text: 'Apakah Anda yakin ingin menambahkan data ini?',
                  confirmBtnText: 'Ya',
                  cancelBtnText: 'Tidak',
                  onConfirmBtnTap: () async {
                    Navigator.of(context).pop();
                    await _submitData();
                  },
                  onCancelBtnTap: () {
                    Navigator.of(context).pop();
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.blue,
                elevation: 0,
              ),
              child: Text(
                "Tambah",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
