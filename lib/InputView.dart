import 'package:flutter/material.dart';

class InputView extends StatefulWidget {
  const InputView({super.key});

  @override
  State<InputView> createState() => InputViewState();
}

class InputViewState extends State<InputView> {
  int _selectdIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("入力"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text(''),
          ],
        ),
      ),
    );
  }
}