import 'package:changtea/HomeChangTea/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Drink_Food/chitiet_mon/chitiet_drink.dart';
import 'cart_model.dart';

final user = Supabase.instance.client.auth.currentUser;
class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final gh = Get.put(CartController());

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => buildCart(),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 30,
            ),
          ),

          if (user != null)
            FutureBuilder<int>(
              future: gh.tongCart(user.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == 0) {
                  return SizedBox(); // không hiển thị gì nếu không có
                }

                return Positioned(
                  top: 3,
                  left: 30,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${snapshot.data}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class CartController extends GetxController {
  var cartItems = <String, CartItem>{}.obs;
  var selectedItems = <String, bool>{}.obs;
  var isAllSelected = false.obs;
  var cartList = <CartItem>[].obs;

  Future<void> fetchCart() async {
    if (user == null) return;
    final result = await CartSnapshot.getCart();
    cartList.value = result;
  }

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  static CartController get() => Get.find();

  Future<int> tongCart(String id) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return 0;

    final response = await Supabase.instance.client
        .from('GioHangChangTea')
        .select('soLuong')
        .eq('idKH', user!.id);

    final data = response as List<dynamic>;
    int total = 0;

    for (var item in data) {
      // total += item['soLuong'] as int;
      total += 1 as int;
    }

    return total;
  }

  // Tổng tiền các mặt hàng đã chọn trong Giỏ hàng
  double tinhTongTien(Map choMH) {
    double tong = 0;
    choMH.forEach((key, isSelected) {
      if (isSelected && cartItems.containsKey(key)) {
        final item = cartItems[key]!;
        final giaSize = item.mon.gia[item.size] ?? 0;
        tong += (giaSize + item.giaTopping) * item.soLuong;
      }
    });
    return tong;
  }

  int soLuongDaChon(Map selectedItems) {
    int count = 0;
    selectedItems.forEach((key, isSelected) {
      if (isSelected) count++;
    });
    return count;
  }

  void chonTatCa(bool value) {
    isAllSelected.value = value;
    for (var key in cartItems.keys) {
      selectedItems[key] = value;
    }
  }

  void auth(){
    update(['user_infor']);
  }

  void removeItem(CartItem i) {
    final user = Supabase.instance.client.auth.currentUser;
    CartSnapshot.deleteCart(i.mon.id, user!.id);
    update(); // hoặc notifyListeners nếu bạn dùng Provider
  }
}

