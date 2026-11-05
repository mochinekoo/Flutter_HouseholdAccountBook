import 'dart:math';

import 'package:flutter/material.dart';
import 'package:householdaccountbook/DatabaseManager.dart';
import 'package:intl/intl.dart';

class InputView extends StatefulWidget {
  const InputView({super.key});

  @override
  State<InputView> createState() => InputViewState();
}

class InputViewState extends State<InputView> {
  int _selectdIndex = 0;
  final TextEditingController dataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("入力"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .start,
          children: [
            TextField(
              textAlign: TextAlign.right,
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: dataController,
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  locale: const Locale("ja"),
                  context: context,
                  firstDate: DateTime(1000),
                  lastDate: DateTime(3000)
                );
                if (picked != null) {
                  dataController.text = "${picked.year}/${picked.month}/${picked.day} ${picked.hour}:${picked.minute}";
                }
            },),
            TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.orange
                ),
                onPressed: () {
                  Navigator.pop(context);
                  DateTime time = DateFormat("yyyy/MM/dd HH:mm").parse(dataController.text);
                  DatabaseManager.GetInstance().Add(time, "aa", "ii", 10, 10);
                },
                child: Text('保存')
            )
          ],
        ),
      ),
    );
  }
}