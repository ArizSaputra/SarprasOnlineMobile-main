import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sarprasonlinemobile/common_widgets/appbar/appbar.dart';
import 'package:sarprasonlinemobile/features/login/login.dart';

class UbahPasswordPage extends StatefulWidget {
  const UbahPasswordPage({super.key});

  @override
  State<UbahPasswordPage> createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends State<UbahPasswordPage> {
  TextEditingController nomorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackArrow: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/illustration3.png",
                  width: 170,
                  height: 170,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 25),
                Text(
                  "Ubah Password",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "Masukkan password baru dan login kembali ke akun anda",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: nomorController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey, 
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.blue, 
                        width: 1.5,
                      ),
                    ),
                    counterText: '',
                    hintText: 'Masukkan password baru',
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
                ),
                SizedBox(height: 60),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        title: 'Konfirmasi',
                        text: 'Apakah password sudah benar?',
                        confirmBtnText: 'Ya',
                        cancelBtnText: 'Tidak',
                        onConfirmBtnTap: () async {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const LoginPage())
                          );
                          Navigator.of(context).pop();
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: 'Data berhasil disimpan!',
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop(); 
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginPage()), 
                              );
                            },
                          );
                        },
                        onCancelBtnTap: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                        ),
                        backgroundColor: const Color(0xFF3B82F6),
                        elevation: 0,
                      ),
                    child: Text(
                      "Simpan",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}