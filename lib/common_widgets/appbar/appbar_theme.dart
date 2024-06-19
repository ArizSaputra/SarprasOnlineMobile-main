import 'package:flutter/material.dart';

class AppBarThemee{
  AppBarThemee._();

  static const AppBarCustom = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black, size: 2),
    actionsIconTheme: IconThemeData(color: Colors.black, size: 2),
    titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
  );
}