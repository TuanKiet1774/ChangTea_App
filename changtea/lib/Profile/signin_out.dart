import 'package:changtea/HomeChangTea/home_controller.dart';
import 'package:changtea/Profile/page_profile.dart';
import 'package:changtea/Profile/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../HomeChangTea/home.dart';

final supabase = Supabase.instance.client;
AuthResponse? response;

class PageAuthMilktea extends StatelessWidget {
  const PageAuthMilktea({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng nhập"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: ListView(
            children: [
              SizedBox(height: 50,),
              Image.asset("asset/Images/Logo_ChangTea.png", width: 200, height: 200,),
              SupaEmailAuth(
                onSignInComplete: (res) {
                  response = res;
                  Navigator.of(context).pop();
                },
                onSignUpComplete: (response) {
                  if(response.user!=null)
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PageVerifyOTP(email: response.user!.email!),)
                    );
                },
                showConfirmPasswordField: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageVerifyOTP extends StatelessWidget {
  PageVerifyOTP({super.key, required this.email});
  String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify your OTP"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OtpTextField(
            numberOfFields: 6,
            borderColor: Colors.black,
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              //handle validation or checks here
            },
            //runs when every textfield is filled
            onSubmit: (String verificationCode) async {
              final response = await Supabase.instance.client.auth.verifyOTP(
                email: email,
                token: verificationCode,
                type: OtpType.email,
              );

              if (response.session != null && response.user != null) {
                final idKH = response.user!.id;

                // Thêm hồ sơ khách hàng mới vào bảng
                await UserChangteaSnapshot.inserProfile(
                    UserChangTea(idKH: idKH, tenKH: "", diaChi: "", sdt: "")
                );

                // Điều hướng sang trang Profile
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false,
                );
              } else {
                // Xác minh thất bại
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Xác minh thất bại"),
                      content: Text("Mã OTP không hợp lệ hoặc đã hết hạn."),
                    );
                  },
                );
              }
            }
          ),
          SizedBox(height: 50,),
          ElevatedButton(
            onPressed: () async {
              MessDialog.showSnackBar(context, message: "Đang gửi mã OTP", seconds: 600);
              final response = await supabase.auth.signInWithOtp(email: email);
              MessDialog.showSnackBar(context, message: "Mã OTP đã gửi vào $email của bạn", seconds: 3);
            },
            child: Text("Gửi lại"),
          )
        ],
      ),
    );
  }
}