import 'dart:async';
import 'package:changtea/Cart/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../HomeChangTea/home_controller.dart';
import '../Invoice/page_invoice.dart';
import 'cart_model.dart';

final user = Supabase.instance.client.auth.currentUser;
class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var monGioHang = Get.put(CartController());
  late Future<List<CartItem>> dsCart;

  late final StreamSubscription<AuthState> _listenAuth;
  Map<int, bool> selectedItems = {};

  @override
  void initState() {
    super.initState();
    dsCart = CartSnapshot.getCart();
    _listenAuth = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      setState(() {
        dsCart = CartSnapshot.getCart();
        selectedItems.clear();
      });
    });
  }

  @override
  void dispose() {
    _listenAuth.cancel();
    super.dispose();
  }

  // Hàm để chọn/bỏ chọn tất cả sản phẩm
  void selectAll(bool? value, List<CartItem> cartItems) {
    setState(() {
      for (var item in cartItems) {
        selectedItems[item.mon.id] = value ?? false;
      }
    });
  }

  // Hàm kiểm tra xem tất cả sản phẩm đã được chọn chưa
  bool isAllSelected(List<CartItem> cartItems) {
    if (cartItems.isEmpty) return false;
    return cartItems.every((item) => selectedItems[item.mon.id] == true);
  }

  // Hàm đếm số lượng sản phẩm đã chọn
  int getSelectedCount() {
    return selectedItems.values.where((selected) => selected == true).length;
  }

  // Hàm tính tổng tiền của các sản phẩm đã chọn
  double calculateTotalPrice(List<CartItem> cartItems) {
    double total = 0;
    for (var item in cartItems) {
      if (selectedItems[item.mon.id] == true) {
        total += (item.giaTopping + item.mon.gia[item.size]!) * item.soLuong;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(child: Text("Vui lòng đăng nhập để xem giỏ hàng")),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: user == null ? Center(child: Text("Vui lòng đăng nhập để xem giỏ hàng"))
              : FutureBuilder<List<CartItem>>(
              future: dsCart,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());

                if (snapshot.hasError)
                  return Center(child: Text("Giỏ hàng trống"));

                if (!snapshot.hasData || snapshot.data!.isEmpty)
                  return Center(child: Text("Giỏ hàng trống"));

                final cartItems = snapshot.data!;

                // Khởi tạo selectedItems cho các sản phẩm mới
                for (var item in cartItems) {
                  if (!selectedItems.containsKey(item.mon.id)) {
                    selectedItems[item.mon.id] = false;
                  }
                }

                // dsCart = CartSnapshot.getCart(user!.id);
                return ListView.separated(
                  itemCount: cartItems.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Slidable(
                      key: ValueKey(item.mon.id),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                            flex: 1,
                            onPressed: (context) async {
                              await CartSnapshot.deleteCart(item.mon.id, user!.id);
                              setState(() {
                                selectedItems.remove(item.mon.id);
                                dsCart = CartSnapshot.getCart();
                              });
                              MessDialog.showSnackBar(context, message: "Đã xóa ${item.mon.ten} ra khỏi giỏ hàng");
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete_forever,
                            label: 'Xóa',
                          ),
                        ],
                      ),
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                      value: selectedItems[item.mon.id] ?? false,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedItems[item.mon.id] = value ?? false;
                                        });
                                      }
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: 110,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        child: Image.network(
                                          item.mon.anh ?? " ",
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[300],
                                              child: Icon(Icons.image_not_supported),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(item.mon.ten,
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                        Text("Giá: ${item.mon.gia[item.size]} VNĐ", style: TextStyle(fontSize: 13)),
                                        Text("Size: ${item.size}", style: TextStyle(fontSize: 13)),
                                        Text("Số lượng: ${item.soLuong}", style: TextStyle(fontSize: 13)),
                                        if (item.mucDa.isNotEmpty)
                                          Text("Đá: ${item.mucDa}",
                                              style: TextStyle(fontSize: 13),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        if (item.topping.isNotEmpty)
                                          Text("Topping: ${item.topping}",
                                              style: TextStyle(fontSize: 13),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    "${((item.giaTopping + item.mon.gia[item.size]!) * item.soLuong).toStringAsFixed(0)} VNĐ",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )),
          FutureBuilder<List<CartItem>>(
            future: dsCart,
            builder: (context, snapshot) {
              final cartItems = snapshot.data ?? [];
              bool isLoggedIn = user != null;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isLoggedIn ? isAllSelected(cartItems) : false,
                          onChanged: isLoggedIn ? (value) {
                            selectAll(value, cartItems);
                          }: null, // Disable checkbox nếu chưa đăng nhập
                        ),
                        Text("Tất cả")
                      ],
                    ),
                    Row(
                      children: [
                        Text('Tổng: ',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        Text(isLoggedIn ? '${calculateTotalPrice(cartItems).toStringAsFixed(0)} VNĐ' : '0 VNĐ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent,),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //Nếu chưa chọn sản phẩm nào
                        if (getSelectedCount() == 0) {
                          ScaffoldMessenger.of(Get.context!).showSnackBar(
                            SnackBar(
                              content: Text("Bạn chưa chọn sản phẩm nào!", style: TextStyle(fontSize: 16,)),
                              backgroundColor: Colors.black,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        // Lấy danh sách các sản phẩm đã chọn
                        List<CartItem> selectedProducts = cartItems.where((item) => selectedItems[item.mon.id] == true).toList();

                        // Điều hướng đến trang chi tiết hóa đơn
                        Navigator.push(context, MaterialPageRoute(builder: (context) => InvoicePage(selectedItems: selectedProducts),),
                        );
                      },
                      child: Text(
                        isLoggedIn ? "Mua hàng (${getSelectedCount()})" : "Mua hàng (0)",
                        style: TextStyle(fontSize: 16,),
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}