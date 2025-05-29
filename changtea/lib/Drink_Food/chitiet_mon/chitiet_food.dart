import 'package:changtea/Drink_Food/menu_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../../Cart/cart_controller.dart';
import '../../Profile/signin_out.dart';
import '../menu_model.dart';

final supabase = Supabase.instance.client;
AuthResponse? response;

class ChitietFood extends StatelessWidget {
  final Mon food_changtea;

  const ChitietFood({super.key, required this.food_changtea});

  @override
  Widget build(BuildContext context) {
    final cart = Get.put(CartController());
    final price = food_changtea.gia["M"] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(food_changtea.ten),
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
                food_changtea.anh ?? " ",
                height: 400,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),

            // Tên sản phẩm
            Text(
              food_changtea.ten,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Mô tả
            Text(
              food_changtea.moTa ?? "Không có mô tả",
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 8),
            // Tag: Best Seller
            if (food_changtea.tag)
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
                  rating: food_changtea.danhGia,
                  itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 30.0,
                  direction: Axis.horizontal,
                ),
              ],
            ),
            SizedBox(height: 16),
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
              builder: (context) => foodsOption(food_changtea, "M", price),
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
