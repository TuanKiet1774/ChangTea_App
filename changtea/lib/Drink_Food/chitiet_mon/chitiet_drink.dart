import 'package:changtea/Profile/signin_out.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../menu_controller.dart';
import '../menu_model.dart';

final supabase = Supabase.instance.client;
AuthResponse? response;

class ChitietDrink extends StatelessWidget {
  final Mon drink_changtea;

  const ChitietDrink({super.key, required this.drink_changtea});

  @override
  Widget build(BuildContext context) {
    final double price = drink_changtea.gia["M"] ?? 0;
    var sortedPrices = drink_changtea.gia.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return Scaffold(
      appBar: AppBar(
        title: Text(drink_changtea.ten),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh sản phẩm
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                drink_changtea.anh ?? "https://via.placeholder.com/150",
                height: 400,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),

            // Tên sản phẩm
            Text(
              drink_changtea.ten,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Mô tả
            Text(
              drink_changtea.moTa ?? "Không có mô tả",
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 8),
            // Tag: Best Seller
            if (drink_changtea.tag)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Best Seller",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            SizedBox(height: 12),
            // Đánh giá
            Row(
              children: [
                Text("Tỷ lệ yêu thích:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 10,),
                RatingBarIndicator(
                  rating: drink_changtea.danhGia,
                  itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 30.0,
                  direction: Axis.horizontal,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text("Bảng giá theo Size:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Size", style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Giá", style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                    ),
                  ],
                ),
                ...sortedPrices.map(
                      (e) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e.key),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${e.value} VNĐ"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final user = supabase.auth.currentUser;
          if (user == null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PageAuthMilktea()),
            );
          }
          else {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => drinksOption(drink_changtea, "M", price),
            );
          }
        },
        child: Icon(Icons.add, size: 30),
        backgroundColor: Colors.amberAccent,
        elevation: 6,
      ),
    );
  }
}
