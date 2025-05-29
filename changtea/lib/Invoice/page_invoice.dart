import 'package:changtea/Cart/cart_model.dart';
import 'package:changtea/HomeChangTea/home.dart';
import 'package:changtea/HomeChangTea/home_controller.dart';
import 'package:changtea/Invoice/invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../Cart/cart_controller.dart';
import '../Profile/profile_controller.dart';
import '../Profile/profile_model.dart';

class InvoicePage extends StatefulWidget {
  InvoicePage({Key? key, required this.selectedItems}) : super(key: key);
  final List selectedItems;

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  UserChangTea? userChangTea;
  var monGioHang = Get.put(CartController());
  final user = Supabase.instance.client.auth.currentUser;
  TextEditingController ghiChuTxt = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final service = UserService();
    final user = await service.getCurrentUserChangTea();
    setState(() {
      userChangTea = user;
    });
  }


  @override
  Widget build(BuildContext context) {
    // num tongThanhToan = widget.selectedItems.fold(0, (sum, item) => sum + (item.mon.gia + item.giaTopping) * item.soLuong);
    num tongThanhToan = widget.selectedItems.fold(0, (sum, item) {
      final giaTheoSize = item.mon.gia[item.size] ?? 0;
      return sum + (giaTheoSize + item.giaTopping) * item.soLuong;
    },);


    return Scaffold(
      appBar: AppBar(
        title: Text("Hóa đơn"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Thông tin khách hàng", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Divider(),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('👤 Khách hàng: ', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${userChangTea?.tenKH}', style: const TextStyle(fontSize: 18,)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('📧 Email: ', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(' ${user?.email}', style: const TextStyle(fontSize: 18,)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('🏠 Địa chỉ: ', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(' ${userChangTea?.diaChi}', style: const TextStyle(fontSize: 18,)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('📞 Số điện thoại: ', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(' ${userChangTea?.sdt}', style: const TextStyle(fontSize: 18,)),
                  ],
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Text("Danh sách sản phẩm", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Divider(),
            SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  // Lấy cartItem từ cartItems
                  var cartItem = widget.selectedItems[index];
                  String size = cartItem.size;
                  String mucDa = cartItem.mucDa;
                  String topping = cartItem.topping;
                  // Hiển thị topping dưới dạng tên
                  //String tenTopping = topping.map((tp) => tp.ten).join(', ');

                  double giaTheoSize = cartItem.mon.gia[cartItem.size] ?? 0;
                  double tongTienMotMon = (giaTheoSize + cartItem.giaTopping) * cartItem.soLuong;

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 5,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: cartItem.mon.anh != null ? Image.network(
                              cartItem.mon.anh!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ) : Icon(Icons.local_drink),
                          ),
                        ],
                      ),
                      title: Text(
                        cartItem.mon.ten,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Giá gốc: ${cartItem.mon.gia[cartItem.size]} VNĐ'),
                          Text('Size: ${size}'),
                          if (mucDa.isNotEmpty) Text('Mức đá: ${mucDa}'),
                          if (topping.isNotEmpty) Text('Topping: $topping'),
                          Text('Số lượng: ${cartItem.soLuong}'),
                          Text('Thành tiền: ${tongTienMotMon} VNĐ',),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: widget.selectedItems.length,
              ),
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text("📝 Ghi chú: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black))),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: ghiChuTxt,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Text("💸Tổng thanh toán: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),

                Text("$tongThanhToan VNĐ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final hoaDon = HoaDon(
                      tongTien: tongThanhToan.toDouble(),
                      thoiGian: DateTime.now(),
                      ghiChu: ghiChuTxt.text,
                    );
                    // await HoaDonSnapshot.insertInvoice(hoaDon);
                    final idHD = await HoaDonSnapshot.insertInvoice(hoaDon);
                    print('Invoice created with idHD = $idHD');

                    for(var i in widget.selectedItems){
                      var cthd = new CTHD(
                        idHD: idHD.toString(),
                        mon: i.mon,
                        size: i.size,
                        soLuong: i.soLuong
                      );
                      await CTHDSnapshot.insertDetailInvoice(cthd);
                      await CartSnapshot.deleteCart(i.mon.id, user!.id);
                    }

                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Thanh toán thành công"),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    await monGioHang.fetchCart();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(),)
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Xác nhận thanh toán", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Hủy đơn hàng", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
