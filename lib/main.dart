import 'package:flutter/material.dart';

import 'package:sarprasonlinemobile/features/dashboard/dashboard.dart';
import 'package:sarprasonlinemobile/features/detail_item/detail.dart';
// import 'package:sarprasonlinemobile/features/inventory/card_test.dart';
import 'package:sarprasonlinemobile/features/inventory/inventory.dart';
import 'package:sarprasonlinemobile/features/login/login.dart';
import 'package:sarprasonlinemobile/features/profile/profile.dart';
import 'package:sarprasonlinemobile/features/register/register_page.dart';
import 'package:sarprasonlinemobile/features/tambah_barang/tambah_barang.dart';
import 'package:sarprasonlinemobile/features/login/login.dart';
import 'package:sarprasonlinemobile/features/listview.dart';
import 'package:sarprasonlinemobile/bottom_navigation/navigation_menu.dart';
import 'package:sarprasonlinemobile/main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primaryColor: primaryColor,
      //   canvasColor: Colors.transparent,
      // ),
      home:  LoginPage(),
    );
  }
}

//  NavigationMenu()