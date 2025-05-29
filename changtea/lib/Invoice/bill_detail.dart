import 'package:flutter/material.dart';
import 'invoice_model.dart'; // Import Mon & CTHD class từ file của bạn

class BillDetail extends StatelessWidget {
  final Future<List<CTHD>> dsCTHD;

  BillDetail({super.key, required this.dsCTHD});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết hóa đơn"),
      ),
      body: FutureBuilder<List<CTHD>>(
        future: dsCTHD,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có dữ liệu chi tiết."));
          }

          final cthds = snapshot.data!;

          return ListView.builder(
            itemCount: cthds.length,
            itemBuilder: (context, index) {
              final item = cthds[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              );
            },
          );
        },
      ),
    );
  }
}
