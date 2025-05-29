import 'package:changtea/Drink_Food/menu_model.dart';
import 'package:flutter/material.dart';
import '../../Cart/cart_controller.dart';
import '../../Search/search_controller.dart';
import '../menu_controller.dart';


class AnVat extends StatefulWidget {
  const AnVat({super.key});

  @override
  State<AnVat> createState() => _AnVatState();
}

class _AnVatState extends State<AnVat> {
  late Future<List<Mon>> dsFood;

  @override
  void initState() {
    super.initState();
    dsFood = ChangTeaSnapshot.getMon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ăn Vặt", style: TextStyle(fontStyle: FontStyle.italic)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Cart(),
          SizedBox(width: 20,)
        ],
      ),
      body: FutureBuilder<List<Mon>>(
        future: dsFood,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty){
            print("Lỗi: ${snapshot.error}");
            return Center(child: Text("Đã xảy ra lỗi: ${snapshot.error}"));
          }

          final foods = snapshot.data!.where((mon) => mon.loai == 3).toList();
          foods.sort((a, b) => a.id.compareTo(b.id));

          return ListView.separated(
            itemCount: foods.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              return dsMon(foods[index]);
            },
          );
        },
      ),
    );
  }
}
