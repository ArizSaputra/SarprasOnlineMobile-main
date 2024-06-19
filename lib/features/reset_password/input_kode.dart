import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sarprasonlinemobile/common_widgets/appbar/appbar.dart';
import 'package:sarprasonlinemobile/features/reset_password/ubah_password.dart';

class InputKodePage extends StatefulWidget {
  const InputKodePage({super.key});

  @override
  State<InputKodePage> createState() => _InputKodePageState();
}

class _InputKodePageState extends State<InputKodePage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final _focusNode4 = FocusNode();

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  void _nextField({required String value, required FocusNode focusNode}) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

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
                  "assets/images/illustration1.png",
                  width: 170,
                  height: 170,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 25),
                Text(
                  "Kode Verifikasi",
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
                  "Masukkan kode verifikasi yang terkirim di handphone anda",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildVerificationCodeField(
                      controller: _controller1,
                      focusNode: _focusNode1,
                      nextFocusNode: _focusNode2,
                    ),
                    _buildVerificationCodeField(
                      controller: _controller2,
                      focusNode: _focusNode2,
                      nextFocusNode: _focusNode3,
                    ),
                    _buildVerificationCodeField(
                      controller: _controller3,
                      focusNode: _focusNode3,
                      nextFocusNode: _focusNode4,
                    ),
                    _buildVerificationCodeField(
                      controller: _controller4,
                      focusNode: _focusNode4,
                      nextFocusNode: null,
                    ),
                  ],
                ),
                SizedBox(height: 60),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const UbahPasswordPage())
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
                      "Continue",
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
  Widget _buildVerificationCodeField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
  }) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
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
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (value) {
          if (value.length == 1 && nextFocusNode != null) {
            _nextField(value: value, focusNode: nextFocusNode);
          }
        },
      ),
    );
  }
}
