import 'package:changtea/Cart/cart.dart';
import 'package:changtea/Invoice/bill_detail.dart';
import 'package:changtea/Invoice/invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({super.key});

  @override
  State<PurchaseHistory> createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  late Future<List<HoaDon>> dsHD;

  @override
  void initState() {
    super.initState();
    dsHD = HoaDonSnapshot.getInvoice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử mua hàng"),
      ),
      body: FutureBuilder<List<HoaDon>>(
        future: dsHD,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Bạn chưa có hóa đơn nào."));
          }

          final hoaDons = snapshot.data!;
          return ListView.builder(
            itemCount: hoaDons.length,
            itemBuilder: (context, index) {
              final hoaDon = hoaDons[index];
              Future<List<CTHD>> ds = CTHDSnapshot.getDetailInvoice(hoaDon.idHD.toString());
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => BillDetail(dsCTHD: ds),)
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🧾${hoaDon.idHD}",
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Divider(),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: "🕒 Thời gian: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: hoaDon.thoiGian.toString()),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: "💰 Tổng tiền: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: "${hoaDon.tongTien} VNĐ"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: "📝 Ghi chú: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: hoaDon.ghiChu ?? "Không có"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },

          );
        },
      ),
    );
  }
}
