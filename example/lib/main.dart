import 'package:flutter/material.dart';
import 'package:fancytabs/fancytabs.dart';

void main() {
  runApp(MaterialApp(
    home: ExampleApp(),
  ));
}

class ExampleApp extends StatelessWidget {
  final controller = FancyTabsController();

  ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FancyTabs test")),
      body: Padding(
        child: Column(
          children: [
            FancyTabs(
                labels: const ["1", "2"],
                onChanged: (index) => print(index),
                controller: controller),
            const SizedBox(height: 16),
            Wrap(
              children: [
                ElevatedButton(
                    onPressed: () => controller.jumpTo(1),
                    child: const Text("2"))
              ],
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
      ),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
    );
  }
}
