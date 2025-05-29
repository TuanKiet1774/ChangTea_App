import 'package:changtea/Profile/profile_controller.dart';
import 'package:changtea/Profile/signin_out.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Cart/cart_controller.dart';
import '../Profile/profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final UserService _userService;
  Future<UserChangTea?>? _userFuture;
  late final Stream<AuthChangeEvent> _authStateChanges;
  var pc = new ProfileController();

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _userFuture = _userService.getCurrentUserChangTea();
    _loadUser();

    _authStateChanges = Supabase.instance.client.auth.onAuthStateChange.map((data) => data.event);
    _authStateChanges.listen((event) {
      // Mỗi khi có thay đổi trạng thái auth, tải lại user
      _loadUser();
    });
  }

  void _loadUser() {
    setState(() {
      _userFuture = _userService.getCurrentUserChangTea();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<CartController>(
          id: "user_infor",
          init: Get.put(CartController()),
          builder: (controller) {
            // Nếu chưa đăng nhập
            if (user == null) {
              return pc.buildGuestView(context);
            }

            // Nếu đã đăng nhập thì tải thông tin userChangTea
            return FutureBuilder<UserChangTea?>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final userChangTea = snapshot.data;

                if (userChangTea == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.amberAccent,
                              width: 3),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              "asset/Images/NoUser.jpg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(
                          "Không tìm thấy thông tin người dùng.\nVui lòng đăng nhập lại.",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
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
                  );
                }
                return pc.buildProfileView(context, user, userChangTea);
              },
            );
          },
        ),
      ),
    );
  }
}
