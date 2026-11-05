import 'package:flutter/material.dart';
import 'package:householdaccountbook/DatabaseManager.dart';
import 'package:householdaccountbook/InputView.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.title});
  final String title;

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int _selectdIndex = 0;

  @override
  Widget build(BuildContext context) {
    var dbManager = DatabaseManager.GetInstance();

    Map<String, List<Widget>> map = {};
    var list = dbManager.GetRawData();
    for (var i in list) {
      var date = i.dateTime.toIso8601String();
      var shopName = i.shopName;
      var itemName = i.itemName;
      var price = i.price;
      var someID = i.someID.toString();

      if (!map.containsKey(someID)) {
        map[someID] = [Text(date), Text(shopName)];
      }

      map[someID]?.add(
          Row(
            children: [
              Text(itemName),
              Text(price.toString())
            ],
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("ホーム"),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'app_about': {
                  showAboutDialog(
                      context: context,
                      children: [
                        Text('作者:もちねこ'),
                        Text('ライセンス：MITライセンス')
                      ]
                  );
                  break;
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                  value: 'app_about',
                  child: Text('アプリについて')
              ),
            ]
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...map.values.expand((widgets) => widgets),
            ],
          ),
        )
      ),
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectdIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectdIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
                icon: Icon(Icons.home_filled),
                label: "ホーム"
            ),
            NavigationDestination(
                icon: Icon(Icons.home_filled),
                label: "ホーム"
            ),
          ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InputView()));
        },
        tooltip: '追加',
        child: const Icon(Icons.add),
      ),
    );
  }
}