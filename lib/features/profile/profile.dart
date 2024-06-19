import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sarprasonlinemobile/common_widgets/appbar/appbar.dart';
import 'package:sarprasonlinemobile/features/reset_password/input_nomor.dart';
import 'package:sarprasonlinemobile/features/login/login.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sarprasonlinemobile/database/api.dart';
import 'package:url_launcher/url_launcher.dart';

const _blueColor = Color(0xFF3B82F6);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> profile = {};

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<Map<String, dynamic>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    print('User ID: $userId');

    if (userId != null) {
      final url = Uri.parse('${Api.lmao}?id_user=$userId');
      print('Request URL: $url');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load profile');
      }
    } else {
      throw Exception('User ID not found in SharedPreferences');
    }
  }

  Future<void> fetchProfile() async {
    try {
      Map<String, dynamic> profileData = await getProfile();
      setState(() {
        profile = profileData;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void openWhatsApp(String phoneNumber) async {
    var whatsappUrl = "whatsapp://send?phone=$phoneNumber";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(
                title: Text(
                  "Profile Account",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              profile.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                profile['nama'] ?? 'N/A',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                profile['jurusan'] ?? 'N/A',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: _blueColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 15),
                              Divider(color: Colors.grey[300]),
                              ListTile(
                                leading: const Icon(Icons.phone, color: _blueColor, size: 28),
                                title: Text(
                                  profile['nomor_hp'] ?? 'N/A',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  if (profile['nomor_hp'] != null) {
                                    openWhatsApp(profile['nomor_hp']);
                                  }
                                },
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.enhanced_encryption_outlined, color: _blueColor, size: 28),
                                title: Text(
                                  "Ubah Password",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(color: Colors.black87, fontSize: 17),
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const InputNomorPage()),
                                  );
                                },
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.logout_rounded, color: Colors.red, size: 28),
                                title: Text(
                                  "Keluar",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(color: Colors.black87, fontSize: 17),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginPage()),
                                  );
                                },
                              ),
                            ],
                          ),
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
