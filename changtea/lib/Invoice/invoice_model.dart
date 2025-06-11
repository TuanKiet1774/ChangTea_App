import 'package:changtea/Cart/cart_model.dart';

import '../Drink_Food/chitiet_mon/chitiet_drink.dart';
import '../Drink_Food/menu_model.dart';

class HoaDon {
  final String? idHD;
  final double tongTien;
  final DateTime thoiGian;
  final String ghiChu;

  HoaDon({
    this.idHD,
    required this.tongTien,
    required this.thoiGian,
    required this.ghiChu,
  });

  factory HoaDon.fromMap(Map<String, dynamic> map) {
    return HoaDon(
      idHD: map['idHD'],
      tongTien: (map['tongTien'] as num).toDouble(),
      thoiGian: DateTime.parse(map['thoiGian']),
      ghiChu: map['ghiChu'] ?? "",
    );
  }

  Map<String, dynamic> toMap(String userId) {
    return {
      "idKH": userId,
      "tongTien": tongTien,
      "thoiGian": thoiGian.toIso8601String(),
      "ghiChu": ghiChu,
    };
  }
}


class HoaDonSnapshot{
  static Future<List<HoaDon>> getInvoice() async{
    final user = supabase.auth.currentUser;
    var response = await supabase.from('HoaDonChangTea').select("idHD, thoiGian, tongTien, ghiChu").eq("idKH", user!.id);
    return response.map((e) => HoaDon.fromMap(e),).toList();
  }

  static Future<String?> insertInvoice(HoaDon h) async{
    final user = supabase.auth.currentUser;
    final response = await supabase.from('HoaDonChangTea').insert(h.toMap(user!.id)).select('idHD').single();
    return response['idHD'] as String?;
  }
}

class CTHD{
  final String idHD;
  final Mon mon;
  final int soLuong;
  final String size;

  CTHD({
    required this.idHD,
    required this.mon,
    required this.size,
    required this.soLuong,
  });

  factory CTHD.fromMap(Map<String, dynamic> map){
    return CTHD(
      idHD: map['idHD'] ?? '',
      mon: Mon.fromJson(map['TraSuaChangTea']),
      soLuong: map['soLuong'] as int,
      size: map['size'],
    );
  }
}

class CTHDSnapshot{
  static Future<List<CTHD>> getDetailInvoice(String idHD) async{
    var response = await supabase.from('CTHDChangTea').select("soLuong, size, HoaDonChangTea(*), TraSuaChangTea(*)").eq("idHD", idHD);
    return response.map((e) => CTHD.fromMap(e),).toList();
  }

  static Future<void> insertDetailInvoice(CTHD ct) async{
    await supabase.from('CTHDChangTea').insert({
      "idHD": ct.idHD,
      "idMon": ct.mon.id,
      "soLuong": ct.soLuong,
      "size": ct.size
    });
  }
}

