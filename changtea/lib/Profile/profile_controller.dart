import 'package:changtea/Profile/page_update.dart';
import 'package:changtea/Profile/profile_model.dart';
import 'package:changtea/Profile/signin_out.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../Cart/cart_controller.dart';
import '../Invoice/purchase_history.dart';

class UserService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<UserChangTea?> getCurrentUserChangTea() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await supabase
          .from('KhachHangChangTea')
          .select()
          .eq('idKH', user.id)
          .maybeSingle();

      if (data == null) return null;
      return UserChangTea.fromJson(data);
    } catch (e) {
      return null;
    }
  }
}

class ProfileController{
  Widget buildGuestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_circle, size: 150, color: Colors.amber),
            SizedBox(height: 20),
            Text(
              "Hãy đăng nhập để nhanh chóng đặt món tại quán nhé",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 150,
              child: ElevatedButton.icon(
                icon: Icon(Icons.login),
                label: Text("Đăng nhập"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PageAuthMilktea()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileView(BuildContext context, User user, UserChangTea userChangTea) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 4),
                image: DecorationImage(
                  image: AssetImage("asset/Images/avatar.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Divider(),
          Text("Thông tin khách hàng📑", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Divider(),
          inforRow("📧 Email: ", user.email ?? ""),
          inforRow("👤 Khách hàng: ", userChangTea.tenKH),
          inforRow("🏠 Địa chỉ: ", userChangTea.diaChi),
          inforRow("📞 Số điện thoại: ", userChangTea.sdt),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  // Chuyển đến trang lịch sử mua hàng
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PurchaseHistory()),
                  );
                },
                child: Text(
                  "🕘 Lịch sử mua hàng ▶️",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text("Cập nhật"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PageUpdateProfile(userChangTea: userChangTea),));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.logout),
                label: Text("Đăng xuất"),

                onPressed: () async {
                  await Supabase.instance.client.auth.signOut();
                  CartController.get().auth();
                  CartController.get().update(["user_infor"]);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  foregroundColor: Colors.black,
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget inforRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}