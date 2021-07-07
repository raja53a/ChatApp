import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: const Text(
      'PingMe',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 22.0,
      ),
    ),
    backgroundColor: Colors.white,
    elevation: 0,
  );
}
