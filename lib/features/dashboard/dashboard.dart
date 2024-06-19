import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sarprasonlinemobile/database/api.dart';
import 'package:sarprasonlinemobile/features/dashboard/widgets/search_bar.dart';
import 'package:sarprasonlinemobile/features/dashboard/widgets/tab_bar.dart';
import 'package:sarprasonlinemobile/features/dashboard/widgets/circular_container.dart';
import 'package:sarprasonlinemobile/features/dashboard/model/item.dart';
import 'package:sarprasonlinemobile/features/dashboard/UncheckedItemsPage.dart';
import 'package:sarprasonlinemobile/features/detail_item/detail.dart';
import 'package:sarprasonlinemobile/common_widgets/appbar/appbar.dart';
import 'package:sarprasonlinemobile/common_widgets/curves/curves_widget.dart';
import 'package:sarprasonlinemobile/bottom_navigation/navigation_menu.dart';
import 'package:sarprasonlinemobile/bottom_navigation/custom_nav.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const _blueColor = Color(0xFF3B82F6);
const _darkblueColor = Color(0xff194185);

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  Future<List<Item>>? futureItems;
  final controller = TextEditingController();
  late TabController _tabController;

  String userName = '';
  String userDepartment = '';

  int pengajuanCount = 0;
  int dipinjamCount = 0;
  int selesaiCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    fetchUserDataAndCounts();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    controller.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          futureItems = fetchPengajuanItems();
          break;
        case 1:
          futureItems = fetchDipinjamItems().then((items) {
            final today = DateTime.now();
            final overdueItems = items.where((item) => DateTime.parse(item.tanggal_kembali).isBefore(today)).toList();
            if (overdueItems.isNotEmpty) {
              _showOverdueDialog(overdueItems);
            }
            return items;
          });
          break;
        case 2:
          futureItems = fetchSelesaiItems();
          break;
      }
    });
  }

  Future<void> fetchUserDataAndCounts() async {
    await fetchUserData();
    await fetchCounts();
    setState(() {
      futureItems = fetchPengajuanItems();
    });
  }

  Future<void> fetchCounts() async {
    try {
      final pengajuanItems = await fetchPengajuanItems();
      final dipinjamItems = await fetchDipinjamItems();
      final selesaiItems = await fetchSelesaiItems();

      setState(() {
        pengajuanCount = pengajuanItems.length;
        dipinjamCount = dipinjamItems.length;
        selesaiCount = selesaiItems.length;
      });
    } catch (e) {
      print('Failed to fetch counts: $e');
      setState(() {
        pengajuanCount = 0;
        dipinjamCount = 0;
        selesaiCount = 0;
      });
    }
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('user_name') ?? '';
    final userDepartment = prefs.getString('user_department') ?? '';

    setState(() {
      this.userName = userName;
      this.userDepartment = userDepartment;
    });
  }

  Future<List<Item>> fetchPengajuanItems() async {
    try {
      final response = await http.get(Uri.parse('${Api.InventoryPengajuan}?jurusan=$userDepartment'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Item.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Failed to fetch pengajuan items: $e');
      return [];
    }
  }

  Future<List<Item>> fetchDipinjamItems() async {
    try {
      final response = await http.get(Uri.parse('${Api.InventoryDipinjam}?jurusan=$userDepartment'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Item.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Failed to fetch dipinjam items: $e');
      return [];
    }
  }

  Future<List<Item>> fetchSelesaiItems() async {
    try {
      final response = await http.get(Uri.parse('${Api.InventorySelesai}?jurusan=$userDepartment'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Item.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Failed to fetch selesai items: $e');
      return [];
    }
  }

 void _showOverdueDialog(List<Item> overdueItems) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Overdue Items'),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: overdueItems.length,
            itemBuilder: (context, index) {
              final item = overdueItems[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Icon(Icons.book, color: Colors.blue),
                  title: Text(item.nama),
                  subtitle: Text('Tanggal Kembali: ${item.tanggal_kembali}'),
                  onTap: () {
                    Navigator.of(context).pop(); // Tutup dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(idPemesanan: item.id_pemesanan.toString()),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    },
  );
}




 void onSearch(String query) {
  setState(() {
    if (_tabController.index == 0) {
      futureItems = fetchPengajuanItems().then((items) => items.where((item) => item.nama.toLowerCase().contains(query.toLowerCase())).toList());
    } else if (_tabController.index == 1) {
      futureItems = fetchDipinjamItems().then((items) => items.where((item) => item.nama.toLowerCase().contains(query.toLowerCase())).toList());
    } else if (_tabController.index == 2) {
      futureItems = fetchSelesaiItems().then((items) => items.where((item) => item.nama.toLowerCase().contains(query.toLowerCase())).toList());
    }
  });
}

  void _launchWhatsApp(String phoneNumber) async {
    final whatsappUrl = Uri.parse("https://wa.me/$phoneNumber");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $whatsappUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  CurvedWidget(
                    child: Container(
                      color: _blueColor,
                      padding: const EdgeInsets.all(0),
                      child: SizedBox(
                        height: 240,
                        child: Stack(
                          children: [
                            Positioned(
                              top: -50,
                              right: -250,
                              child: CircularContainer(
                                backgroundColor: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            Positioned(
                              top: 50,
                              right: -300,
                              child: CircularContainer(
                                backgroundColor: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                children: [
                                  const SizedBox(height: 60),
                                  SearchWidget(controller: controller, onSearch: onSearch),
                                  const SizedBox(height: 30),
                                  TabBarWidget(
                                    tabController: _tabController,
                                    pengajuanCount: pengajuanCount,
                                    dipinjamCount: dipinjamCount,
                                    selesaiCount: selesaiCount,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CustomAppBar(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Color(0xffD3D3D3),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          userDepartment,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UncheckedItemsPage()),
                          );
                        },
                        icon: const Icon(
                          Iconsax.notification,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              FutureBuilder<List<Item>>(
                future: futureItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load items'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No items found'));
                  } else {
                    List<Item> items = snapshot.data!;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(idPemesanan: item.id_pemesanan.toString()),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: Card(
                                color: Colors.white,
                                surfaceTintColor: Colors.white,
                                elevation: 2,
                                shadowColor: const Color(0xffD3D3D3),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.person_pin, color: _blueColor, size: 15),
                                                const SizedBox(width: 5),
                                                Text(
                                                  item.nama,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              item.kelas,
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                                              ),
                                            ),
                                            
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Tanggal Pinjam",
                                                  style: TextStyle(color: Colors.grey, fontSize: 17, fontWeight: FontWeight.w400),
                                                ),
                                                Text(
                                                  item.tanggal_pinjam,
                                                  style: TextStyle(color: Colors.grey, fontSize: 17, fontWeight: FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Tanggal Kembali",
                                                  style: TextStyle(color: Colors.grey, fontSize: 17, fontWeight: FontWeight.w400),
                                                ),
                                                Text(
                                                  item.tanggal_kembali,
                                                  style: TextStyle(color: Colors.grey, fontSize: 17, fontWeight: FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  item.nomor_hp,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(color: Colors.grey, fontSize: 17),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => DetailPage(idPemesanan: item.id_pemesanan.toString()),
                                                          ),
                                                        );
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "View Detail",
                                                            style: GoogleFonts.poppins(
                                                              textStyle: const TextStyle(color: _blueColor, fontSize: 12),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          const Icon(Iconsax.arrow_circle_right5, color: _blueColor, size: 12),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
