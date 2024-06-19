import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sarprasonlinemobile/features/detail_item/widgets/custom_text.dart';

class UncheckedItemsPage extends StatefulWidget {
  const UncheckedItemsPage({Key? key}) : super(key: key);

  @override
  _UncheckedItemsPageState createState() => _UncheckedItemsPageState();
}

class _UncheckedItemsPageState extends State<UncheckedItemsPage> {
  late Future<List<Map<String, dynamic>>> futureUncheckedItems;

  @override
  void initState() {
    super.initState();
    futureUncheckedItems = fetchUncheckedItems();
  }

  Future<List<Map<String, dynamic>>> fetchUncheckedItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    List<Map<String, dynamic>> uncheckedItems = [];

    for (String key in keys) {
      if (key.startsWith('details_')) {
        List<String>? savedDetails = prefs.getStringList(key);
        String idPemesanan = key.replaceFirst('details_', '');
        List<String>? savedChecks = prefs.getStringList('checkedItems_$idPemesanan');

        if (savedDetails != null && savedChecks != null) {
          for (int i = 0; i < savedDetails.length; i++) {
            Map<String, dynamic> detail = Map<String, dynamic>.from(json.decode(savedDetails[i]));
            bool isChecked = savedChecks[i] == 'true';
            if (!isChecked) {
              uncheckedItems.add(detail);
            }
          }
        }
      }
    }
    return uncheckedItems;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Unchecked Items', style: GoogleFonts.poppins()),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: futureUncheckedItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No unchecked items found'));
            } else {
              final uncheckedItems = snapshot.data!;
              return ListView.builder(
                itemCount: uncheckedItems.length,
                itemBuilder: (context, index) {
                  final item = uncheckedItems[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: item['nama_barang'],
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 10),
                            CustomText(
                              text: 'Nomor Seri: ${item['nomor_seri']}',
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                            CustomText(
                              text: 'Merk: ${item['merk']}',
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
