// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      id_pemesanan: (json['id_pemesanan'] as num).toInt(),
      nama: json['nama'] as String,
      nomor_hp: json['nomor_hp'] as String,
      kelas: json['kelas'] as String,
      tanggal_pinjam: json['tanggal_pinjam'] as String,
      tanggal_kembali: json['tanggal_kembali'] as String,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id_pemesanan': instance.id_pemesanan,
      'nama': instance.nama,
      'nomor_hp': instance.nomor_hp,
      'kelas': instance.kelas,
      'tanggal_pinjam': instance.tanggal_pinjam,
      'tanggal_kembali': instance.tanggal_kembali,
    };
