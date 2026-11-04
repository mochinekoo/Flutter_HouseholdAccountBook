import 'package:flutter/material.dart';
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
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text(''),
          ],
        ),
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