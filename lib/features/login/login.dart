import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:sarprasonlinemobile/features/dashboard/dashboard.dart';
import 'package:sarprasonlinemobile/features/register/register_page.dart';
import 'package:sarprasonlinemobile/bottom_navigation/navigation_menu.dart';
import 'package:sarprasonlinemobile/features/reset_password/input_nomor.dart';
import 'package:sarprasonlinemobile/database/api.dart';
import 'package:quickalert/quickalert.dart';

const _blueColor = Color(0xFF3B82F6);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  double _progress = 0.0;
  bool _obscureText = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameController.text = prefs.getString('username') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      prefs.setString('username', usernameController.text);
      prefs.setString('password', passwordController.text);
    } else {
      prefs.remove('username');
      prefs.remove('password');
    }
    prefs.setBool('rememberMe', _rememberMe);
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _progress = 0.0;
    });

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_progress < 1.0) {
        setState(() {
          _progress += 0.01;
        });
      } else {
        timer.cancel();
      }
    });

    final String url = '${Api.urlLogin}';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    setState(() {
      _isLoading = false;
      _progress = 1.0;
    });

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      final token = responseJson['access_token'];
      final userId = responseJson['user']['id'];
      final userName = responseJson['user']['nama'];
      final userDepartment = responseJson['user']['jurusan'];

      await _saveCredentials();

      // Simpan token, user ID, nama, dan jurusan ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setInt('user_id', userId);
      prefs.setString('user_name', userName);
      prefs.setString('user_department', userDepartment);

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Login Successful',
        text: 'Welcome, $userName!',
        confirmBtnText: 'OK',
        onConfirmBtnTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NavigationMenu(),
              settings: RouteSettings(arguments: userId),
            ),
          );
        },
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Login Failed',
        text: 'Please check your username and password.',
        confirmBtnText: 'OK',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B82F6),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/hero.png",
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              labelText: "Username",
                              prefixIcon: Icon(Icons.person_2_rounded),
                              labelStyle: TextStyle(color: Colors.white),
                              prefixStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            cursorColor: Colors.black,
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: Icon(Icons.key),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.white, fontFamily: 'Poppins'),
                              prefixStyle: const TextStyle(
                                  color: Colors.white, fontFamily: 'Poppins'),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            cursorColor: Colors.black,
                            style: const TextStyle(fontFamily: 'Poppins'),
                            obscureText: _obscureText,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Remember Me',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? Column(
                            children: [
                              LinearProgressIndicator(
                                value: _progress,
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(_blueColor),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${(_progress * 100).toStringAsFixed(0)}%",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        : Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: const Color(0xffF8F9FA),
                                elevation: 0,
                              ),
                              child: Text(
                                "Login",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      color: _blueColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 60,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const InputNomorPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: const Color(0xFF3B82F6),
                                elevation: 0,
                              ),
                              child: Text(
                                "Lupa Password",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                        Container(
                          height: 60,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const RegisterPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: const Color(0xFF3B82F6),
                                elevation: 0,
                              ),
                              child: Text(
                                "Register",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
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
    );
  }
}
