import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:householdaccountbook/DatabaseManager.dart';
import 'package:intl/intl.dart';

class InputView extends StatefulWidget {
  const InputView({super.key});

  @override
  State<InputView> createState() => InputViewState();
}

class ItemRow {
  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController();

  void dispose() {
    name.dispose();
    price.dispose();
  }
}

class InputViewState extends State<InputView> {
  int _selectdIndex = 0;
  final _key = GlobalKey<FormState>();
  final TextEditingController dateTextController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();

  final List<ItemRow> _itemRowList = [ItemRow()];

  @override
  void dispose() {
    dateTextController.dispose();
    for (final item in _itemRowList) {
      item.dispose();
    }
    super.dispose();
  }

  Widget buildItemRow(ItemRow item) {
    return   Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: item.name,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: '買ったもの',
              hintText: '買ったものを入力してください',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "必須です";
              }
              return null;
            },
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: item.price,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '値段',
              hintText: '値段を入力してください',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "必須です";
              }
              return null;
            },
          ),
        ),
        Expanded(child: IconButton(
            onPressed: () => {
              if (_itemRowList.length > 1) {
                setState(() {
                  _itemRowList.remove(item);
                  item.dispose();
                })
              }
            },
            icon: Icon(Icons.remove))
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("入力"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: .start,
            children: [
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: '支出'),
                        Tab(text: '収入'),
                      ],
                    ),
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        children: [
                          Center(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: dateTextController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                        labelText: '日付',
                                        hintText: '日付を入力してください'
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return "必須です";
                                      }
                                      return null;
                                    },
                                    onTap: () async {
                                      final DateTime? pickDate = await showDatePicker(
                                          locale: const Locale("ja"),
                                          context: context,
                                          firstDate: DateTime(1000),
                                          lastDate: DateTime(3000)
                                      );
                                      final TimeOfDay? pickTime = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now()
                                      );

                                      DateTime date = DateTime(
                                        pickDate!.year,
                                        pickDate.month,
                                        pickDate.day,
                                        pickTime!.hour,
                                        pickTime.minute,
                                      );

                                      dateTextController.text = DateFormat("yyyy/MM/dd HH:mm").format(date);
                                    },
                                  ),
                                  TextFormField(
                                    controller: shopNameController,
                                    textAlign: TextAlign.right,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        labelText: '店名',
                                        hintText: '店名を入力してください'
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return "必須です";
                                      }
                                      return null;
                                    },
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () => {
                                          setState(() {
                                            _itemRowList.add(ItemRow());
                                          })
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                                      ..._itemRowList.map(buildItemRow),
                                    ],
                                  ),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.orange
                                      ),
                                      onPressed: () {
                                        if (!_key.currentState!.validate()) {
                                          return;
                                        }

                                        Navigator.pop(context);
                                        DateTime time = DateFormat("yyyy/MM/dd HH:mm").parse(dateTextController.text);
                                        var dbManager = DatabaseManager.GetInstance();
                                        var dbData = dbManager.GetRawData();
                                        var someID = 0;
                                        if (dbData.length >= 2) {
                                          someID = dbData[dbData.length - 1].someID + 1;
                                        }

                                        for (var itemRow in _itemRowList) {
                                          var itemName = itemRow.name.text;
                                          var price = itemRow.price.text;
                                          debugPrint("$itemName,$price");
                                          dbManager.Add(time, shopNameController.text, itemName, int.parse(price), someID);
                                        }
                                      },
                                      child: Text('保存')
                                  )
                                ],
                              )
                          ),
                          Center(
                              child: Column(
                                children: [],
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}