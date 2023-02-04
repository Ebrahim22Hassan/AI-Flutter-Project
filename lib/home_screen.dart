import 'package:flutter/material.dart';
import 'package:ml_app/Components/body.dart';
import 'package:ml_app/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Center(child: Text('Plant Disease Detector')),
        elevation: 0,
      ),
      body: const Body(),
    );
  }
}
