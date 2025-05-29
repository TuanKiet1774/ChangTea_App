import 'package:changtea/Drink_Food/chitiet_mon/chitiet_drink.dart';
import 'package:changtea/Drink_Food/chitiet_mon/chitiet_food.dart';
import 'package:changtea/Drink_Food/menu_model.dart';
import 'package:flutter/cupertino.dart';

class ChitietItem extends StatelessWidget {
  final Mon menu_changtea;

  ChitietItem({super.key, required this.menu_changtea});

  @override
  Widget build(BuildContext context) {
    if (menu_changtea.loai == 1 || menu_changtea.loai == 2) {
      return ChitietDrink(drink_changtea: menu_changtea); // ép kiểu rõ ràng
    }
    else if (menu_changtea.loai == 3) {
      return ChitietFood(food_changtea: menu_changtea); // ép kiểu rõ ràng
    }
    return Center(
      child: Text("Không có thông tin chi tiết cho món này")
    );
  }
}



