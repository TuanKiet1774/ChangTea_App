import 'package:changtea/Drink_Food/menu_model.dart';
import 'package:flutter/material.dart';
import '../../Cart/cart_controller.dart';
import '../../Search/search_controller.dart';
import '../menu_controller.dart';
import '../../Cart/cart.dart';

class TraTraiCay extends StatefulWidget {
  const TraTraiCay({super.key});

  @override
  State<TraTraiCay> createState() => _TraTraiCayState();
}

class _TraTraiCayState extends State<TraTraiCay> {
  late Future<List<Mon>> dsDrinkTTC;

  @override
  void initState() {
    super.initState();
    dsDrinkTTC = ChangTeaSnapshot.getMon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trà Trái Cây", style: TextStyle(fontStyle: FontStyle.italic)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Cart(),
          SizedBox(width: 20,)
        ],
      ),
      body: FutureBuilder<List<Mon>>(
        future: dsDrinkTTC,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty){
            print("Lỗi: ${snapshot.error}");
            return Center(child: Text("Đã xảy ra lỗi: ${snapshot.error}"));
          }

          final drinks = snapshot.data!.where((mon) => mon.loai == 2).toList();
          drinks.sort((a, b) => a.id.compareTo(b.id));

          return ListView.separated(
            itemCount: drinks.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              return dsMon(drinks[index]);
            },
          );
        },
      ),
    );
  }
}
