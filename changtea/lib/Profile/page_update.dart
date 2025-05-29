import 'dart:io';
import 'package:changtea/HomeChangTea/home_controller.dart';
import 'package:changtea/Profile/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PageUpdateProfile extends StatefulWidget {
  PageUpdateProfile({super.key, required this.userChangTea});
  UserChangTea userChangTea;

  @override
  State<PageUpdateProfile> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<PageUpdateProfile> {
  TextEditingController tenController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController diaChiController = TextEditingController();
  TextEditingController sdtController = TextEditingController();

  File? _avatarImage;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    tenController.text = widget.userChangTea.tenKH ?? "";
    diaChiController.text = widget.userChangTea.diaChi ?? "";
    sdtController.text = widget.userChangTea.sdt ?? "";
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _avatarImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cập nhật thông tin"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _avatarImage != null
                    ? FileImage(_avatarImage!)
                    : AssetImage('asset/Images/avatar.jpg') as ImageProvider,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: tenController,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: "Tên khách hàng",
                labelStyle: TextStyle(fontSize: 20),
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: diaChiController,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: "Địa chỉ",
                labelStyle: TextStyle(fontSize: 20),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: sdtController,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: "Số điện thoại",
                labelStyle: TextStyle(fontSize: 20),
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                //Thong bao dang cap nhat
                UserChangTea userChangtea = widget.userChangTea;
                userChangtea.tenKH = tenController.text;
                userChangtea.diaChi = diaChiController.text;
                userChangtea.sdt = sdtController.text;

                await UserChangteaSnapshot.updateProfile(userChangtea);
                MessDialog.showSnackBar(
                    context,
                    message: "Đã cập nhật ${tenController.text}...",
                    seconds: 5
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor:  Colors.white,
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // để nút không chiếm hết chiều ngang
                children: [
                  Icon(Icons.save, color: Colors.white,), // biểu tượng lưu
                  SizedBox(width: 8), // khoảng cách giữa icon và text
                  Text("Cập nhật", style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
