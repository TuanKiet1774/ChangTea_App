import 'package:changtea/Cart/cart_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../Cart/cart_model.dart';
import '../Profile/signin_out.dart';
import 'chitiet_mon/chitiet_drink.dart';
import 'chitiet_mon/chitiet_food.dart';
import 'menu_model.dart';

final supabase = Supabase.instance.client;
Widget drinksOption(Mon d, String size, double price) {
  String chonMucDa = '';
  int soLuongMon = 1;
  double sumTP = 0;
  List<Topping> chonTP = [];
  late Future<List<Topping>> dsTopping;
  dsTopping = ChangTeaSnapshot.getTopping();
  String chonSize = 'M';
  late Future<List<CartItem>> dsCart;

  return SingleChildScrollView(
    child: StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        height: 110,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Image.network(
                            d.anh ?? "link ảnh mặc định",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            d.ten,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            d.moTa ?? "Chưa có mô tả",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      )
                    )
                  ],
                ),
              ),
              Divider(),
              // Mức đá
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Mức Đá", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Column(
                children: ["Đá chung", "Đá riêng", "Ít đá"].map((mucDa) {
                  return CheckboxListTile(
                    value: chonMucDa == mucDa,
                    onChanged: (_) {
                      setState(() {
                        chonMucDa = mucDa;
                      });
                    },
                    title: Text(mucDa),
                  );
                }).toList(),
              ),
              // Topping
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Topping", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              // Hiển thị danh sách topping để chọn
              FutureBuilder<List<Topping>>(
                future: dsTopping,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Không có topping nào.'));
                  }

                  final toppings = snapshot.data!;
                  return Column(
                    children: toppings.map((tp) {
                      return CheckboxListTile(
                        title: Text(tp.ten),
                        subtitle: Text('${tp.gia}đ'),
                        value: chonTP.contains(tp),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              chonTP.add(tp);
                              ChangTeaSnapshot.addTopping(tp, chonTP);
                            } else {
                              chonTP.remove(tp);
                            }
                            // Cập nhật giá của topping đã chọn
                            sumTP = ChangTeaSnapshot.tinhTongGiaTopping(chonTP);
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Size ", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Row(
                children: d.gia.keys.map((size) {
                  return Row(
                    children: [
                      Radio<String>(
                        value: size,
                        groupValue: chonSize,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              chonSize = value;
                            });
                          }
                        },
                      ),
                      Text(size),
                      SizedBox(width: 30,)
                    ],
                  );
                }).toList(),
              ),
              // Chọn số lượng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Số lượng:"),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (soLuongMon > 1) setState(() => soLuongMon--);
                        },
                      ),
                      Text('$soLuongMon'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => setState(() => soLuongMon++),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
              // Thêm vào giỏ hàng
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () async {
                    if (supabase.auth.currentUser == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PageAuthMilktea()),
                      );
                    } else {
                      Navigator.pop(context);

                      String chuoiTopping = chonTP.map((tp) => tp.ten).join(', ');
                      double giaTopping = chonTP.fold(0, (sum, tp) => sum + tp.gia);
                      CartItem c = new CartItem(
                          mon: d,
                          soLuong: soLuongMon,
                          size: chonSize,
                          mucDa: chonMucDa,
                          topping: chuoiTopping,
                          giaTopping: giaTopping
                      );
                      await CartSnapshot.insertCart(c);

                      setState(() {
                        dsCart = CartSnapshot.getCart();
                      });
                    }
                  },
                  child: Text(
                    "Thêm vào giỏ hàng - ${(sumTP + (d.gia[chonSize]!)) * soLuongMon}đ",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        );
      },
    ),
  );
}

Widget foodsOption(Mon d, String size, double price) {
  int soLuongMon = 1;
  double sumTP = 0;
  String chonSize = 'M';
  late Future<List<CartItem>> dsCart;

  return SingleChildScrollView(
    child: StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        height: 110,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Image.network(
                            d.anh ?? "link ảnh mặc định",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            d.ten,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            d.moTa ?? "Chưa có mô tả",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      )
                    )
                  ],
                ),
              ),
              Divider(),
              // Chọn số lượng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Số lượng:"),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (soLuongMon > 1) setState(() => soLuongMon--);
                        },
                      ),
                      Text('$soLuongMon'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => setState(() => soLuongMon++),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
              // Thêm vào giỏ hàng
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed:  () async {
                    if (supabase.auth.currentUser == null) {
                      // Nếu chưa đăng nhập → chuyển đến trang đăng nhập
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PageAuthMilktea()),
                      );
                    }
                    else {
                      Navigator.pop(context);

                      CartItem c = new CartItem(
                          mon: d,
                          soLuong: soLuongMon,
                          size: size,
                          mucDa: '',
                          topping: '',
                          giaTopping: 0
                      );
                      await CartSnapshot.insertCart(c);

                      setState(() {
                        dsCart = CartSnapshot.getCart();
                      });
                    }
                  },
                  child: Text(
                    "Thêm vào giỏ hàng - ${(sumTP + (d.gia[chonSize]!)) * soLuongMon}đ",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget dsMon(Mon d) {
  return StatefulBuilder(
    builder: (context, setState) {
      final double price = d.gia["M"] ?? 0; //Giá cả theo Size
      return GestureDetector(
        onTap: () {
          if (d.loai == 1 || d.loai == 2){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChitietDrink(drink_changtea: d)),
            );
          }
          else if (d.loai == 3){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChitietFood(food_changtea: d)),
            );
          }
        },
        child: Card(
          margin: EdgeInsets.all(5),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              height: 110,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                child: Image.network(
                                  d.anh ?? "link ảnh mặc định",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Text(d.ten, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                                  ],
                                ),
                                Text(d.moTa.toString(), style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (d.tag) Text("Best Seller", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: d.danhGia,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      "${(d.gia["M"] ?? 0)} VNĐ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      onPressed: () {
                        if (d.loai == 1 || d.loai == 2) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) => drinksOption(d, "M", price),
                          );
                        }
                        else if (d.loai == 3) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) => foodsOption(d, "M", price),
                          );
                        }
                      },
                      icon: Icon(Icons.add_circle_outline, size: 20),
                    )

                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
