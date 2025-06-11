import 'package:changtea/Search/search_controller.dart';
import 'package:changtea/Search/search_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Drink_Food/chitiet_mon/chitiet_item.dart';

class SearchChangTea extends StatefulWidget {
  const SearchChangTea({super.key});

  @override
  State<SearchChangTea> createState() => _SearchChangTeaState();
}

class _SearchChangTeaState extends State<SearchChangTea> {
  TextEditingController txtSearch = new TextEditingController();
  lichSuTimKiem ds = Get.put(lichSuTimKiem());

  @override
  void initState() {
    super.initState();
    ds.layMenu();
    txtSearch.addListener(() {
      ds.timKiemTheoTen(txtSearch.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: txtSearch,
                    onSubmitted: (value) {
                      ds.timKiemTheoTen(txtSearch.text);
                      ds.addTimKiem(txtSearch.text);
                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SearchResult(ds.dsDeXuatFilter),
                          )
                      );
                    },
                    decoration: InputDecoration(
                      hintText: "Bạn muốn tìm kiếm món gì ?",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      prefixIcon: IconButton(
                        onPressed: () {
                          ds.timKiemTheoTen(txtSearch.text);
                          ds.addTimKiem(txtSearch.text);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SearchResult(ds.dsDeXuatFilter),
                            )
                          );
                        },
                        icon: Icon(Icons.search_outlined),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            //Hiển thị lịch sử tìm kiếm nếu chưa nhập bất kỳ từ khóa nào
            Expanded(
              child: Obx(() {
                if (txtSearch.text.isEmpty) {
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      // Hiển thị kết quả tìm kiếm
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(ds.dstk[index], style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: ds.dstk.length,
                  );
                }
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final item = ds.dsDeXuatFilter[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChitietItem(menu_changtea: item),),);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item.ten, style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: ds.dsDeXuatFilter.length,
                );},
              ),
            )
          ],
        ),
      ),
    );
  }
}
