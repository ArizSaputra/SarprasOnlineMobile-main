import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sarprasonlinemobile/database/api.dart';
import 'package:sarprasonlinemobile/features/detail_item/widgets/custom_text.dart';
import 'package:sarprasonlinemobile/common_widgets/appbar/appbar.dart';
import 'package:sarprasonlinemobile/common_widgets/curves/curves_widget.dart';
import 'package:sarprasonlinemobile/bottom_navigation/navigation_menu.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expansion_widget/expansion_widget.dart';

const _blueColor = Color(0xFF3B82F6);
const baseUrl = 'http://192.168.100.34:8000';

class DetailPage extends StatefulWidget {
  final String idPemesanan;

  const DetailPage({Key? key, required this.idPemesanan}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<List<dynamic>> futureDetail;
  List<bool> checkedItems = [];
  int currentIndex = 0;
  String nama = '';
  String kelas = '';
  String toolmanName = '';

  @override
  void initState() {
    super.initState();
    futureDetail = fetchDetail();
    loadToolmanName();
  }

  Future<void> loadToolmanName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      toolmanName = prefs.getString('user_name') ?? '...........................................';
    });
  }

  Future<void> _printPdf(List<dynamic> details, String nama, String kelas) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('DAFTAR PEMINJAMAN ALAT', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text('Nama', style: pw.TextStyle(fontSize: 14)),
                  ),
                  pw.Text(':', style: pw.TextStyle(fontSize: 14)),
                  pw.Expanded(
                    flex: 7,
                    child: pw.Text(nama, style: pw.TextStyle(fontSize: 14)),
                  ),
                ],
              ),
              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text('Kelas', style: pw.TextStyle(fontSize: 14)),
                  ),
                  pw.Text(':', style: pw.TextStyle(fontSize: 14)),
                  pw.Expanded(
                    flex: 7,
                    child: pw.Text(kelas, style: pw.TextStyle(fontSize: 14)),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['No.', 'Nama Alat', 'Jumlah', 'Nomor Seri', 'Merk', 'Tanggal Pinjam', 'Tanggal Kembali', 'Keterangan'],
                data: details.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  var detail = entry.value;
                  return [
                    index.toString(),
                    detail['nama_barang'] ?? '',
                    '1', // Assuming quantity is 1 for the demo
                    detail['nomor_seri'] ?? '',
                    detail['merk'] ?? '',
                    detail['tanggal_pinjam'] ?? '',
                    detail['tanggal_kembali'] ?? '',
                    detail['status_peminjaman'] ?? '',
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 40),
              pw.Text('Jember,..................', style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text('Yang Mengajukan', style: pw.TextStyle(fontSize: 14)),
                      pw.SizedBox(height: 70),
                      pw.Text('$nama', style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text('Toolman', style: pw.TextStyle(fontSize: 14)),
                      pw.SizedBox(height: 70),
                      pw.Text(toolmanName, style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<List<dynamic>> fetchDetail() async {
    final response = await http.get(Uri.parse('${Api.InventoryPengajuan}/${widget.idPemesanan}'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      data.sort((a, b) => (a['nama_barang'] ?? '').compareTo(b['nama_barang'] ?? ''));

      checkedItems = await loadCheckedItems(data.length);
      await saveDetails(data);
      setCurrentIndexToFirstUnchecked(data.length);
      nama = data[0]['nama'] ?? '';
      kelas = data[0]['kelas'] ?? '';
      return data;
    } else {
      throw Exception('Failed to load detail');
    }
  }

  Future<List<dynamic>> fetchPrint() async {
    final response = await http.get(Uri.parse('${Api.InventorySelesai}/${widget.idPemesanan}'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load detail');
    }
  }

  Future<void> saveDetails(List<dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> details = data.map((item) => json.encode(item)).toList();
    await prefs.setStringList('details_${widget.idPemesanan}', details);
  }

  Future<List<bool>> loadCheckedItems(int length) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedChecks = prefs.getStringList('checkedItems_${widget.idPemesanan}');
    if (savedChecks != null && savedChecks.length == length) {
      return savedChecks.map((item) => item == 'true').toList();
    } else {
      return List<bool>.filled(length, false);
    }
  }

  Future<void> saveCheckedItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedChecks = checkedItems.map((item) => item.toString()).toList();
    await prefs.setStringList('checkedItems_${widget.idPemesanan}', savedChecks);
  }

  void setCurrentIndexToFirstUnchecked(int length) {
    for (int i = 0; i < length; i++) {
      if (!checkedItems[i]) {
        setState(() {
          currentIndex = i;
        });
        break;
      }
    }
  }

  Future<void> update() async {
    final response = await http.put(
      Uri.parse('${Api.InventoryPengajuan}/${widget.idPemesanan}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      showSuccessPopup();
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<void> updateSelesai() async {
    final response = await http.put(
      Uri.parse('${Api.InventoryDipinjam}/${widget.idPemesanan}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      showSuccessPopup();
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<void> updateBarang(String idSeriBarang) async {
    final url = '${Api.updateBarang}/${widget.idPemesanan}';
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(<String, String>{
      'nomor_seri': idSeriBarang,
    });

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        showSuccessAlert('Item updated successfully');
      } else {
        showErrorAlert('Failed to update item');
      }
    } catch (e) {
      showErrorAlert('Failed to update item: $e');
    }
  }

  Future<void> updateBarangUn(String idSeriBarang) async {
    final url = '${Api.updateBarangUn}/${widget.idPemesanan}';
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(<String, String>{
      'nomor_seri': idSeriBarang,
    });

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        showSuccessAlert('Item updated successfully');
      } else {
        showErrorAlert('Failed to update item');
      }
    } catch (e) {
      showErrorAlert('Failed to update item: $e');
    }
  }

  void showSuccessPopup() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Update Successful',
      text: 'Your update was successful.',
      onConfirmBtnTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NavigationMenu()),
        );
      },
    );
  }

  void showSuccessAlert(String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: message,
    );
  }

  void showErrorAlert(String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: message,
    );
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final url = 'https://wa.me/$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String getStatus(Map<String, dynamic> detail, List<dynamic> allDetails) {
    if (detail['status_perizinan'] == 'Menunggu') {
      return 'Tersedia';
    } else if (detail['status_peminjaman'] == 'Berlangsung') {
      int detailIndex = allDetails.indexOf(detail);
      return checkedItems[detailIndex] ? 'Dikembalikan' : 'Belum Dikembalikan';
    } else if (detail['status_peminjaman'] == 'Selesai') {
      return 'Dikembalikan';
    } else {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<List<dynamic>>(
          future: futureDetail,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data found'));
            } else {
              final details = snapshot.data!;
              Map<String, List<dynamic>> groupedDetails = {};

              for (var detail in details) {
                String itemName = detail['nama_barang'] ?? '';
                if (!groupedDetails.containsKey(itemName)) {
                  groupedDetails[itemName] = [];
                }
                groupedDetails[itemName]!.add(detail);
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CurvedWidget(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            CustomAppBar(
                              showBackArrow: true,
                              title: Text(
                                "Detail Item",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: groupedDetails.entries.map((entry) {
                          String itemName = entry.key;
                          List<dynamic> itemDetails = entry.value;

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            child: ExpansionWidget(
                              titleBuilder: (double animationValue, _, bool isExpanded, toggleFunction) {
                                return InkWell(
                                  onTap: () => toggleFunction(animated: true),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage('${itemDetails.first['${[Api.serverIp]}/gambar_barang']}'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            itemName,
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Transform.rotate(
                                          angle: animationValue * 3.14 / 2,
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            color: _blueColor,
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              content: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "Nomor Seri",
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "Merk",
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Status",
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Column(
                                    children: itemDetails.map((detail) {
                                      String status = getStatus(detail, details);
                                      int detailIndex = details.indexOf(detail);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                detail['nomor_seri'] ?? '',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                detail['merk'] ?? '',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: InkWell(
                                                onTap: status == 'Belum Dikembalikan'
                                                    ? () async {
                                                        setState(() {
                                                          checkedItems[detailIndex] = !checkedItems[detailIndex];
                                                        });
                                                        await saveCheckedItems();

                                                        if (checkedItems[detailIndex]) {
                                                          try {
                                                            await updateBarang(detail['nomor_seri'] ?? '');
                                                          } catch (e) {
                                                            showErrorAlert('Failed to update item: $e');
                                                          }
                                                        } else {
                                                          try {
                                                            await updateBarangUn(detail['nomor_seri'] ?? '');
                                                          } catch (e) {
                                                            showErrorAlert('Failed to update item: $e');
                                                          }
                                                        }
                                                      }
                                                    : null,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: status == 'Tersedia'
                                                        ? Colors.green
                                                        : status == 'Belum Dikembalikan'
                                                            ? Colors.orange
                                                            : Colors.blue,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                                                  child: Text(
                                                    status,
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
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
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        bottomNavigationBar: FutureBuilder<List<dynamic>>(
          future: futureDetail,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SizedBox.shrink();
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15 / 2),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  child: _buildStatusButton(snapshot.data!),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatusButton(List<dynamic> details) {
    final detail = details[currentIndex];
    final statusPerizinan = detail['status_perizinan'] ?? '';
    final statusPeminjaman = detail['status_peminjaman'] ?? '';

    if (statusPerizinan == 'Menunggu' && (statusPeminjaman == null || statusPeminjaman.isEmpty)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              try {
                await update();
              } catch (e) {
                showErrorAlert('Failed to update data: $e');
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: _blueColor,
              elevation: 0,
              minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 60),
            ),
            child: Text(
              "Setuju",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: const Color(0xffD3D3D3),
              elevation: 0,
              minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 60),
            ),
            child: Text(
              "Tolak",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (statusPerizinan == 'Disetujui' && statusPeminjaman == 'Berlangsung') {
      bool allChecked = checkedItems.every((checked) => checked);
      return ElevatedButton(
        onPressed: allChecked
            ? () async {
                try {
                  await updateSelesai();
                } catch (e) {
                  showErrorAlert('Failed to update data: $e');
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: allChecked ? Colors.blue : Colors.grey,
          minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 60),
        ),
        child: Text(
          "Selesai",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    } else if (statusPeminjaman == 'Selesai') {
      return ElevatedButton(
        onPressed: () async {
          try {
            final printData = await fetchPrint();
            if (printData.isNotEmpty) {
              final nama = printData[0]['nama'] ?? '';
              final kelas = printData[0]['kelas'] ?? '';
              _printPdf(printData, nama, kelas);
            }
          } catch (e) {
            showErrorAlert('Failed to fetch print data: $e');
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.orange,
          minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 60),
        ),
        child: Text(
          "Print",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Container();
  }
}
