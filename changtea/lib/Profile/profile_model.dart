import 'package:supabase/supabase.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class UserChangTea {
  String idKH;
  String tenKH;
  String diaChi;
  String sdt;

  UserChangTea({
    required this.idKH,
    required this.tenKH,
    required this.diaChi,
    required this.sdt,
  });

  Map<String, dynamic> toJson() {
    return {
      'idKH': idKH,
      'tenKH': tenKH,
      'diaChi': diaChi,
      'sdt': sdt,
    };
  }

  factory UserChangTea.fromJson(Map<String, dynamic> json) {
    return UserChangTea(
      idKH: json['idKH'] ?? '',
      tenKH: json['tenKH'] ?? '',
      diaChi: json['diaChi'] ?? '',
      sdt: json['sdt'] ?? '',
    );
  }
}

class UserChangteaSnapshot {
  UserChangTea userChangTea;
  UserChangteaSnapshot({required this.userChangTea});

  static Future<dynamic> updateProfile(UserChangTea newUser) async {
    final supabase = Supabase.instance.client;
    var data = await supabase.from("KhachHangChangTea").update(newUser.toJson()).eq('idKH', newUser.idKH);
    return data;
  }

  static Future<dynamic> inserProfile(UserChangTea newUser) async {
    final supabase = Supabase.instance.client;
    var data = await supabase.from("KhachHangChangTea").insert(newUser.toJson()).eq('idKH', newUser.idKH);
    return data;
  }
}







