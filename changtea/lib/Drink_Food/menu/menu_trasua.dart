import 'package:changtea/Drink_Food/menu_model.dart';
import 'package:flutter/material.dart';
import '../../Cart/cart.dart';
import '../../Cart/cart_controller.dart';
import '../../Search/search_controller.dart';
import '../menu_controller.dart';

class TraSua extends StatefulWidget {
  const TraSua({super.key});

  @override
  State<TraSua> createState() => _TraSuaState();
}

class _TraSuaState extends State<TraSua> {
  late Future<List<Mon>> dsDrinkTS;

  @override
  void initState() {
    super.initState();
    dsDrinkTS = ChangTeaSnapshot.getMon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trà Sữa", style: TextStyle(fontStyle: FontStyle.italic)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Cart(),
          SizedBox(width: 20,)
        ],
      ),
      body: FutureBuilder<List<Mon>>(
        future: dsDrinkTS,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty){
            print("Lỗi: ${snapshot.error}");
            return Center(child: Text("Đã xảy ra lỗi: ${snapshot.error}"));
          }

          final drinks = snapshot.data!.where((mon) => mon.loai == 1).toList();
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
