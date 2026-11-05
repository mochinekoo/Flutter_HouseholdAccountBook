import 'package:flutter/material.dart';
import 'package:householdaccountbook/DatabaseManager.dart';
import 'package:householdaccountbook/InputView.dart';
import 'package:intl/intl.dart';

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
    debugPrint("${list.length}");
    for (var i in list) {
      var dateRaw = i.dateTime;
      var date = DateFormat("yyyy年mm月dd日 (E)", 'ja').format(dateRaw);
      var shopName = i.shopName;
      var itemName = i.itemName;
      var price = i.price;
      var someID = i.someID.toString();

      if (!map.containsKey(someID)) {
        map[someID] = [
          Text(
            date,
            style: TextStyle(),
          ),
          Text(
              shopName,
              style: TextStyle(),
          )
        ];
      }

      map[someID]?.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("　　$itemName"),
              Text(
                  price.toString(),
                  style: TextStyle(),
              )
            ],
          )
      );
    }

    List<Widget> _pageList = [
      Center(
        child:  Container(
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...map.values.expand((widgets) => widgets),
                ],
              ),
            ),
          ),
        ),
      ),
      Center()
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("ホーム"),
        actions: [
          IconButton(onPressed: () => {

              },
              icon: Icon(Icons.search)
          ),
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
      body: _pageList[_selectdIndex],
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
                label: "支出と収入"
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