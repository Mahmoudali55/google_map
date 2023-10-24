import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Transform(transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
              ..rotateX(0.01 * _offset.dy)
            )
          ],
        ),
      ),
    );
  }
}
