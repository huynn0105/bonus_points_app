import 'package:flutter/material.dart';

@override
AppBar myAppBar({String? title}) {
  return AppBar(
    backgroundColor: Colors.white,
    title: Text('$title', style: TextStyle(color: Colors.black)),
    centerTitle: true,
    elevation: 0,
  );
}
