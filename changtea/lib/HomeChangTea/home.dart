import 'dart:async';
import 'package:flutter/material.dart';
import '../Cart/cart_controller.dart';
import '../Drink_Food/menu_model.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController slide = PageController();
  int slide_ht = 0;
  Timer? tg;
  late Future<List<Mon>> dsDrinkTS;
  late Future<List<Mon>> dsDrinkTTC;
  late Future<List<Mon>> dsDrinkFood;
  int index = 0;

  @override
  void initState() {
    super.initState();
    final menu = ChangTeaSnapshot.getMon();

    dsDrinkTS = menu.then((list) =>
        list.where((mon) => mon.loai == 1).toList());
    dsDrinkTTC = menu.then((list) =>
        list.where((mon) => mon.loai == 2).toList());
    dsDrinkFood = menu.then((list) =>
        list.where((mon) => mon.loai == 3).toList());

    slide_Anh(
      p: slide,
      getCurrentPage: () => slide_ht,
      totalPages: AnhQC.length,
      onPageChanged: (newPage) {
        setState(() {
          slide_ht = newPage;
        });
      },
      onTimerCreated: (timer) {
        tg = timer;
      },
    );
  }

  @override
  void dispose() {
    tg?.cancel();
    tg = null;
    slide.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (index != 0) {
          setState(() {
            index = 0;
          });
          return false;
        } else {
          return await MessDialog.wannaOut(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Trà Sữa ChangTea"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            Cart(),
            SizedBox(width: 20,)
          ],
        ),
        body: IndexedStack(
          index: index,
          children: [
            buildHome(slide, slide_ht, tg, dsDrinkTS, dsDrinkTTC, dsDrinkFood, context),
            buildSearch(),
            buildProfile(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          selectedItemColor: Colors.orangeAccent,
          unselectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              label: "Trang chủ",
              icon: Icon(Icons.home)
            ),
            BottomNavigationBarItem(
              label: "Tìm Kiếm",
              icon: Icon(Icons.search_outlined)
            ),
            BottomNavigationBarItem(
              label: "Cá nhân",
              icon: Icon(Icons.account_circle)
            ),
          ],
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
        ),
      ),
    );
  }

  Widget buildBody(int index){
    switch(index){
    case 0:return buildHome(slide, slide_ht, tg, dsDrinkTS, dsDrinkTTC, dsDrinkFood, context);
    case 1: return buildSearch();
    case 2: return buildProfile();
    default: return buildHome(slide, slide_ht, tg, dsDrinkTS, dsDrinkTTC, dsDrinkFood, context);
    }
  }
}
