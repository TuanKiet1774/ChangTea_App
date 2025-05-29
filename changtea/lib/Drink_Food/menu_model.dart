import 'package:supabase_flutter/supabase_flutter.dart';

class Mon {
  int id;
  String ten;
  Map<String, double> gia;
  String? moTa;
  String? anh;
  bool tag;
  double danhGia;
  int loai;

  Mon({
    required this.id,
    required this.ten,
    required this.gia,
    this.moTa,
    this.anh,
    required this.tag,
    required this.danhGia,
    required this.loai,
  });

  factory Mon.fromJson(Map<String, dynamic> json) {
    return Mon(
      id: json["id"],
      ten: json["ten"],
      gia: (json['gia'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, (value as num).toDouble())),
      moTa: json["moTa"],
      anh: json["anh"],
      tag: json["tag"],
      danhGia: (json["danhGia"] as num).toDouble(),
      loai: json["loai"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "ten": ten,
      "gia": gia,
      "moTa": moTa,
      "anh": anh,
      "tag": tag,
      "danhGia": danhGia,
      "loai": loai
    };
  }
}

class Topping{
  int id;
  String ten;
  double gia;

  Topping({
    required this.id,
    required this.ten,
    required this.gia,
  });

  factory Topping.fromJson(Map<String, dynamic> json) {
    return Topping(
      id: json["id"],
      ten: json["ten"],
      gia: (json["gia"] as num).toDouble()
    );
  }
}

class ChangTeaSnapshot{
  static Future <List<Mon>> getMon() async{
    final supabase = Supabase.instance.client;
    List<Mon> dsMon = [];
    final data = await supabase.from('TraSuaChangTea').select();
    dsMon = data.map((e) => Mon.fromJson(e),).toList();
    return dsMon;
  }

  static Future <List<Topping>> getTopping() async{
    final supabase = Supabase.instance.client;
    List<Topping> dsTopping = [];
    final data = await supabase.from('ToppingChangTea').select();
    dsTopping = data.map((e) => Topping.fromJson(e),).toList();
    return dsTopping;
  }

  static double tinhTongGiaTopping(List<Topping> toppings) {
    double tong = 0;
    for(var i in toppings)
      tong += i.gia;
    return tong;
  }

  static void addTopping(Topping t, List<Topping> ds){
    if(ds.contains(t.id)){
      ds.add(t);
    }
  }
}





