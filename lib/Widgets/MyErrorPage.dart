import 'package:flutter/material.dart';

class MyErrorPage extends StatelessWidget {
  final dynamic err;
  const MyErrorPage({Key key, this.err}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(err.toString()),
    );
  }
}
