import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../Drink_Food/menu_model.dart';
import '../Profile/profile_model.dart';

class CartItem {
  final Mon mon;
  final int soLuong;
  final String size;
  final String mucDa;
  final String topping;
  final double giaTopping;

  CartItem({
    required this.mon,
    required this.soLuong,
    required this.size,
    required this.mucDa,
    required this.topping,
    required this.giaTopping,
  });

  factory CartItem.fromMap(Map<String, dynamic> map){
    return CartItem(
      mon: Mon.fromJson(map['TraSuaChangTea']),
      soLuong: map['soLuong'] as int,
      size: map['size'],
      mucDa: map['mucDa'],
      topping: map['topping'],
      giaTopping:  (map['giaTopping'] as num).toDouble(),
    );
  }
}

class CartSnapshot {
  static Future<List<CartItem>> getCart() async{
    final user = supabase.auth.currentUser;
    var response = await supabase.from('GioHangChangTea').select("soLuong, size, mucDa, topping, giaTopping, TraSuaChangTea(*)").eq("idKH", user!.id);
    return response.map((e) => CartItem.fromMap(e),).toList();
  }

  static Future<void> insertCart(CartItem c) async{
    final user = supabase.auth.currentUser;
    await supabase.from('GioHangChangTea').insert({
      "idKH": user!.id,
      "idMon": c.mon.id,
      "soLuong": c.soLuong,
      "size": c.size,
      "mucDa": c.mucDa,
      "topping": c.topping,
      "giaTopping": c.giaTopping,
    });
  }

  static Future<void> deleteCart(int idMon, String idKH) async {
    final user = supabase.auth.currentUser;
    final idKH = user?.id;

    await supabase.from('GioHangChangTea').delete().eq('idMon', idMon).eq('idKH', idKH!);
  }
}