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
  final _key = GlobalKey<FormState>();
  final TextEditingController dataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("入力"),
      ),
      body: Form(
        key: _key,
        child: Column(
          mainAxisAlignment: .start,
          children: [
            TextFormField(
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '値段',
                hintText: '値段を入力してください'
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "必須です";
                }
                return null;
              },
            ),
            TextFormField(
              controller: dataController,
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
                final DateTime? picked = await showDatePicker(
                  locale: const Locale("ja"),
                  context: context,
                  firstDate: DateTime(1000),
                  lastDate: DateTime(3000)
                );
                if (picked != null) {
                  dataController.text = DateFormat("yyyy/MM/dd HH:mm").format(picked);
                }
            },),
            TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.orange
                ),
                onPressed: () {
                  if (!_key.currentState!.validate()) {
                    return;
                  }

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