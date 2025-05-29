import 'dart:async';
import 'package:changtea/Cart/cart.dart';
import 'package:changtea/Profile/page_profile.dart';
import 'package:changtea/Search/search.dart';
import 'package:flutter/material.dart';
import '../Drink_Food/menu/menu_anvat.dart';
import '../Drink_Food/menu/menu_trasua.dart';
import '../Drink_Food/menu/menu_tratraicay.dart';
import '../Drink_Food/menu_controller.dart';
import '../Drink_Food/menu_model.dart';


final List<String> AnhQC = [
  'asset/Images/image1.jpg',
  'asset/Images/image2.jpg',
  'asset/Images/image3.jpg',
  'asset/Images/image4.jpg',
  'asset/Images/image5.jpg',
  'asset/Images/image6.jpg',
  'asset/Images/image7.JPG',
];

void slide_Anh({
  required PageController p,
  required int Function() getCurrentPage,
  required int totalPages,
  required void Function(int newPage) onPageChanged,
  required void Function(Timer timer) onTimerCreated,
})
{
  Timer t = Timer.periodic(
    const Duration(seconds: 3), (Timer timer) {
    int currentPage = getCurrentPage();
    int nextPage = (currentPage + 1) % totalPages;

    p.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    onPageChanged(nextPage);
    }
  );
  onTimerCreated(t);
}

Widget buildHome(
    PageController slide,
    int slide_ht,
    Timer? tg,
    Future<List<Mon>> dsDrinkTS,
    Future<List<Mon>> dsDrinkTTC,
    Future<List<Mon>> dsDrinkFood,
    BuildContext context,
  ){
  return Padding(
    padding: const EdgeInsets.all(9.0),
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 400,
            child: PageView.builder(
              controller: slide,
              itemCount: AnhQC.length,
              itemBuilder: (context, index) {
                return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        AnhQC[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              onPageChanged: (index) {
                slide_ht = index;
              },
            ),
          ),
          SizedBox(height: 15,),
          Divider(),
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Trà Sữa",
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                ),
              ),
              Spacer(),
              Text("Xem thêm", style: TextStyle(fontStyle: FontStyle.italic),),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TraSua(),)
                    );
                  },
                  icon: Icon(Icons.arrow_right)
              ),
            ],
          ),
          FutureBuilder<List<Mon>>(
            future: dsDrinkTS,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());

              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty){
                print("Lỗi: ${snapshot.error}");
                return Center(child: Text("Đã xảy ra lỗi: ${snapshot.error}"));
              }

              final drinks = snapshot.data!;
              drinks.sort((a, b) => a.id.compareTo(b.id));
              final _3DrinkTS = drinks.take(3).toList();

              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _3DrinkTS.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return dsMon(_3DrinkTS[index]);
                },
              );
            },
          ),
          SizedBox(height: 15,),
          Divider(),
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Trà Trái Cây",
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                ),
              ),
              Spacer(),
              Text("Xem thêm", style: TextStyle(fontStyle: FontStyle.italic),),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TraTraiCay(),)
                    );
                  },
                  icon: Icon(Icons.arrow_right)
              ),
            ],
          ),
          FutureBuilder<List<Mon>>(
            future: dsDrinkTTC,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());

              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty){
                print("Lỗi: ${snapshot.error}");
                return Center(child: Text("Đã xảy ra lỗi: ${snapshot.error}"));
              }

              final drinks = snapshot.data!;
              drinks.sort((a, b) => a.id.compareTo(b.id));
              final _3DrinkTTC = drinks.take(3).toList();

              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _3DrinkTTC.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return dsMon(_3DrinkTTC[index]);
                },
              );
            },
          ),
          SizedBox(height: 15,),
          Divider(),
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Ăn Vặt",
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                ),
              ),
              Spacer(),
              Text("Xem thêm", style: TextStyle(fontStyle: FontStyle.italic),),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AnVat(),)
                  );
                },
                icon: Icon(Icons.arrow_right),
              ),
            ],
          ),
          FutureBuilder<List<Mon>>(
            future: dsDrinkFood,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());

              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty){
                print("Lỗi: ${snapshot.error}");
                return Center(child: Text("Đã xảy ra lỗi: ${snapshot.error}"));
              }

              final foods = snapshot.data!;
              foods.sort((a, b) => a.id.compareTo(b.id));
              final _3Food = foods.where((food) => food.tag == true).take(3).toList();

              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _3Food.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return dsMon(_3Food[index]);
                },
              );
            },
          ),
          Divider(),
        ],
      ),
    ),
  );
}

Widget buildCart(){
  return Center(
    child: CartPage(),
  );
}

Widget buildSearch(){
  return Center(
    child: SearchChangTea(),
  );
}

Widget buildProfile() {
  return ProfilePage();
}

class MessDialog {
  static Future<bool> wannaOut(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Center(
          child: Text(
            'Xác nhận thoát',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.redAccent,
            ),
          ),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn thoát ứng dụng không ?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 16),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Không'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Thoát'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  static void showSnackBar(BuildContext context, {required String message, int seconds = 3}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: Duration(seconds: seconds),)
    );
  }
}
