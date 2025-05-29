import 'package:changtea/Drink_Food/chitiet_mon/chitiet_drink.dart';
import 'package:changtea/Drink_Food/chitiet_mon/chitiet_item.dart';
import 'package:changtea/Drink_Food/menu_controller.dart';
import 'package:flutter/material.dart';
import '../Drink_Food/menu_model.dart'; // Đảm bảo bạn đã import controller của mình

class SearchResult extends StatelessWidget {
  final List<Mon> dsDeXuatFilter;
  SearchResult(this.dsDeXuatFilter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kết quả tìm kiếm"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: dsDeXuatFilter.isEmpty ? Center(
          child: Text("Không tìm thấy món nào phù hợp.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
        )
        :Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  var mon = dsDeXuatFilter[index];
                  String giaHienThi = '${mon.gia.entries.first.value} VNĐ';

                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: mon.anh != null ? Image.network(
                          mon.anh!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                            : Icon(Icons.local_drink),
                      ),
                      title: Text(
                        mon.ten,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(giaHienThi),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.of(context).push(
                         MaterialPageRoute(
                           builder: (context) => ChitietItem(menu_changtea: mon),
                         ),
                        );
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemCount: dsDeXuatFilter.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

