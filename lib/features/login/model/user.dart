import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'dart:typed_data';

part 'user.g.dart';

@JsonSerializable()
class User {
  // final String id_pemesanan; // Properti baru
  final String role;
  final String Username;
  final String Password;

  const User({
    // required this.id_pemesanan, // Constructor dengan properti baru
    required this.role,
    required this.Username,
    required this.Password,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
