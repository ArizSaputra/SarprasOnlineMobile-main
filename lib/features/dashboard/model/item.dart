import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'dart:typed_data';

part 'item.g.dart';

@JsonSerializable()
class Item {
  // final String id_pemesanan; // Properti baru
  final int id_pemesanan;
  final String nama;
  final String nomor_hp;
  final String kelas;
  final String tanggal_pinjam;
  final String tanggal_kembali;

  const Item({
    // required this.id_pemesanan, // Constructor dengan properti baru
    required this.id_pemesanan,
    required this.nama,
    required this.nomor_hp,
    required this.kelas,
    required this.tanggal_pinjam,
    required this.tanggal_kembali
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}



// const allItem = [
 
//   Item(
//     nama: "Nathan Tjoe Hubner", 
//     image: "assets/images/laptop.png",
//     deskripsi: "Laptop Asus",
//     kelas: "XII TKJ"),
//   Item(
//     nama: "Nathan Tjoe Hubner", 
//     image: "assets/images/laptop.png",
//     deskripsi: "Laptop Asus",
//     kelas: "XII TKJ"),
//   Item(
//     nama: "Nathan Tjoe Hubner", 
//     image: "assets/images/laptop.png",
//     deskripsi: "Laptop Asus",
//     kelas: "XII TKJ"),
//   Item(
//     nama: "Nathan Tjoe Hubner", 
//     image: "assets/images/laptop.png",
//     deskripsi: "Laptop Asus",
//     kelas: "XII TKJ"),
//   Item(
//     nama: "Nathan Tjoe Hubner", 
//     image: "assets/images/laptop.png",
//     deskripsi: "Laptop Asus",
//     kelas: "XII TKJ"),
//   Item(
//     nama: "Nathan Tjoe Hubner", 
//     image: "assets/images/laptop.png",
//     deskripsi: "Laptop Asus",
//     kelas: "XII TKJ"),
//   Item(
//     nama: "Nathan Tjoe Hubner", 
//     image: "assets/images/laptop.png",
//     deskripsi: "Laptop Asus",
//     kelas: "XII TKJ"),
// ];