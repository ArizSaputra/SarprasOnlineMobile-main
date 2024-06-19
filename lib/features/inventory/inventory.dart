import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'package:sarprasonlinemobile/database/api.dart';
import 'package:sarprasonlinemobile/common_widgets/appbar/appbar.dart';
import 'package:sarprasonlinemobile/features/inventory/widgets/search_bar.dart';
import 'package:sarprasonlinemobile/features/tambah_barang/tambah_barang.dart';

const _blueColor = Color(0xFF3B82F6);
const _darkblueColor = Color(0xff194185);

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final controller = TextEditingController();
  List itemList = [];
  List itemListDetail = [];
  List filteredItemList = [];
  int totalRows = 0;

  @override
  void initState() {
    super.initState();
    getAllItems();
    totalItems();
  }

  Future<String> _getUserDepartment() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_department') ?? '';
  }

  Future<void> getAllItems() async {
    final userDepartment = await _getUserDepartment();
    var response = await http.get(Uri.parse('${Api.urlListInventory}?jurusan=$userDepartment'));
    var response2 = await http.get(Uri.parse('${Api.urlListInventoryDetail}?jurusan=$userDepartment'));
    print(response2.body);
    if (response.statusCode == 200 && response2.statusCode == 200) {
      setState(() {
        itemList = json.decode(response.body);
        itemListDetail = json.decode(response2.body);
        filteredItemList = itemList;
      });
    }
  }

Future<void> totalItems() async {
  final userDepartment = await _getUserDepartment();
  final response = await http.get(Uri.parse('${Api.urlTotalItems}?jurusan=$userDepartment'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    setState(() {
      totalRows = data['total_rows'];
    });
  }
}

  List getDetailsForItem(dynamic itemId) {
    return itemListDetail.where((detail) => detail['id_barang'].toString() == itemId.toString()).toList();
  }

  Future<void> updateInventoryDetail(int id, String nomorSeri, String merk, String namaBarang) async {
    final response = await http.post(
      Uri.parse(Api.urlEditInventoryDetail),
      body: {
        'id': id.toString(),
        'nomor_seri': nomorSeri,
        'merk': merk,
        'nama_barang': namaBarang,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      if (result['success']) {
        await getAllItems();
        print('Update successful');
      } else {
        print('Update failed: ${result['error']}');
      }
    } else {
      print('Server error: ${response.statusCode}');
    }
  }

  Future<void> deleteInventoryDetail(int id) async {
    final response = await http.post(
      Uri.parse(Api.urlDeleteInventoryDetail),
      body: {
        'id': id.toString(),
      },
    );

    if (response.statusCode == 200) {
      try {
        var result = json.decode(response.body);
        if (result['success']) {
          print('Delete successful');
        } else {
          print('Delete failed: ${result['error']}');
        }
      } catch (e) {
        print('Error parsing JSON: $e');
        print('Response body: ${response.body}');
      }
    } else {
      print('Server error: ${response.statusCode}');
    }
  }

  Future<void> deleteItem(int id) async {
    final response = await http.post(
      Uri.parse(Api.urlDeleteItem),
      body: {
        'id': id.toString(),
      },
    );

    if (response.statusCode == 200) {
      try {
        var result = json.decode(response.body);
        if (result['success']) {
          await getAllItems();
          print('Item delete successful');
        } else {
          print('Item delete failed: ${result['error']}');
        }
      } catch (e) {
        print('Error parsing JSON: $e');
        print('Response body: ${response.body}');
      }
    } else {
      print('Server error: ${response.statusCode}');
    }
  }

  void searchItem(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItemList = itemList;
      } else {
        filteredItemList = itemList.where((item) =>
            item['nama_barang']
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> refreshItems() async {
    await getAllItems();
    totalItems();
  }

  void showEditDialog(BuildContext context, Map<String, dynamic> item) {
    List itemDetails = getDetailsForItem(item['id']);
    List<TextEditingController> seriControllers = itemDetails.map((detail) => TextEditingController(text: detail['nomor_seri'])).toList();
    List<TextEditingController> merkControllers = itemDetails.map((detail) => TextEditingController(text: detail['merk'])).toList();
    TextEditingController namaBarangController = TextEditingController(text: item['nama_barang']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              backgroundColor: Colors.white,  
              title: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.close_rounded,size: 34, color: _blueColor,)),
              ),
              content: SingleChildScrollView(  
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: namaBarangController,
                      decoration: InputDecoration(
                        labelText: "Nama Barang",
                        labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: _blueColor, width: 1.5),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ...itemDetails.asMap().entries.map<Widget>((entry) {
                      int index = entry.key;
                      var detail = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 200, 
                                    child: TextFormField(
                                      controller: seriControllers[index],
                                      decoration: InputDecoration(
                                        labelText: "Seri",
                                        labelStyle: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: _blueColor, width: 1.5),
                                        ),
                                      ),
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    width: 200, 
                                    child: TextFormField(
                                      controller: merkControllers[index],
                                      decoration: InputDecoration(
                                        labelText: "Merk",
                                        labelStyle: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: _blueColor, width: 1.5),
                                        ),
                                      ),
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red,),
                                  onPressed: () async {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.confirm,
                                      title: 'Konfirmasi',
                                      text: 'Apakah Anda yakin ingin menghapus item ini?',
                                      confirmBtnText: 'Ya',
                                      cancelBtnText: 'Tidak',
                                      onConfirmBtnTap: () async {
                                        Navigator.of(context).pop(); 
                                        await deleteInventoryDetail(int.parse(detail['id']));
                                        setState(() {
                                          itemDetails.removeAt(index);
                                          seriControllers.removeAt(index);
                                          merkControllers.removeAt(index);
                                        });
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          text: 'Data berhasil dihapus!',
                                        );
                                      },
                                      onCancelBtnTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            title: 'Konfirmasi',
                            text: 'Apakah Anda yakin ingin menyimpan semua perubahan?',
                            confirmBtnText: 'Ya',
                            cancelBtnText: 'Tidak',
                            onConfirmBtnTap: () async {
                              Navigator.of(context).pop(); 
                              for (int i = 0; i < itemDetails.length; i++) {
                                await updateInventoryDetail(
                                  int.parse(itemDetails[i]['id']),
                                  seriControllers[i].text,
                                  merkControllers[i].text,
                                  namaBarangController.text,
                                );
                              }
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: 'Semua data berhasil diperbarui!',
                              );
                            },
                            onCancelBtnTap: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        child: Text(
                          "Simpan",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            title: 'Konfirmasi',
                            text: 'Apakah Anda yakin ingin menghapus item ini beserta detailnya?',
                            confirmBtnText: 'Ya',
                            cancelBtnText: 'Tidak',
                            onConfirmBtnTap: () async {
                              Navigator.of(context).pop();
                              await deleteItem(int.parse(item['id']));
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: 'Item dan detail berhasil dihapus!',
                              );
                            },
                            onCancelBtnTap: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        child: Text(
                          "Hapus",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: refreshItems,
          child: ListView(
            children: [
              CustomAppBar(
                title: Text(
                  "Data Inventaris",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchWidget(controller: controller, onSearch: searchItem),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text("Total Items:",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$totalRows',
                              style: GoogleFonts.poppins( 
                                textStyle: const TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 50,
                          width: 160,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TambahBarangPage())
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                              ),
                              backgroundColor: _blueColor,
                              elevation: 2, 
                            ),
                            child: Text(
                              "Tambah Barang",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            )
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: filteredItemList.map<Widget>((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                          child: Card(
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: ExpansionWidget(
                              initiallyExpanded: false,
                              titleBuilder: (double animationValue, _, bool isExpanded, toggleFunction) {
                                return InkWell(
                                  onTap: () => toggleFunction(animated: true),
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image:NetworkImage('${Api.serverIp}/${item['gambar_barang']}'),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item['nama_barang'],
                                                      style: GoogleFonts.poppins(
                                                        textStyle: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 35,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: const Color(0xffD3D3D3), width: 1),
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              item['stok'],
                                                              style: GoogleFonts.poppins(
                                                                textStyle: const TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          "Stok Barang",
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 35,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: const Color(0xffD3D3D3), width: 1),
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              item['used'],
                                                              style: GoogleFonts.poppins(
                                                                textStyle: const TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          "Digunakan",
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 8),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () => showEditDialog(context, item),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16), 
                                            decoration: const BoxDecoration(
                                              color: _blueColor,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(16),
                                                bottomLeft: Radius.circular(16),
                                              ),
                                            ),
                                            child: Text(
                                              "Edit",
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 5,
                                        bottom: 10,
                                        child: Transform.rotate(
                                          angle: math.pi * animationValue / 2, 
                                          alignment: Alignment.center,
                                          child: const Icon(Icons.chevron_right_rounded, color: _blueColor, size: 33),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              content: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0), 
                                            color: Colors.black12, 
                                          ),
                                          margin: const EdgeInsets.only(bottom: 2.0),
                                          height: 2.0,
                                          width: MediaQuery.of(context).size.width * 0.2,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0), 
                                            color: Colors.black12, 
                                          ),
                                          margin: const EdgeInsets.only(bottom: 8.0),
                                          height: 2.0,
                                          width: MediaQuery.of(context).size.width * 0.1,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Seri',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Merek',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Status',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ...getDetailsForItem(item['id']).map<Widget>((detail) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    detail['nomor_seri'],
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    detail['merk'],
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 7),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: detail['status'] == 'Tersedia' ? Colors.grey[300] : _blueColor, 
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Text(
                                                        detail['status'],
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.poppins(
                                                          textStyle: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
