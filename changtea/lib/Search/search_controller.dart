import 'package:changtea/Search/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../Drink_Food/menu_model.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SearchChangTea()),
        );
      },
      icon: Icon(Icons.search_rounded, color: Colors.white, size: 30),
    );
  }
}


//search_controller
class lichSuTimKiem extends GetxController {
  var dstk = <String>[].obs;
  var dsDeXuat = <Mon>[].obs;
  var dsDeXuatFilter = <Mon>[].obs;
  TextEditingController txtSearch = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    layMenu();
    txtSearch.addListener(() {
      timKiemTheoTen(txtSearch.text);
    });
  }

  void layMenu() async {
    List<Mon> allItems = await ChangTeaSnapshot.getMon();
    dsDeXuat.value = allItems;
    dsDeXuatFilter.value = allItems;
  }

  void addTimKiem(String txt) {
    if (!dstk.contains(txt)) {
      dstk.add(txt);
    }
  }

  void timKiemTheoTen(String txt) {
    final tuKhoa = txt.toLowerCase().trim();
    dsDeXuatFilter.value = dsDeXuat.where(
            (item) => item.ten.toLowerCase().contains(tuKhoa)
    ).toList();
  }
}