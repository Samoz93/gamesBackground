import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  final Widget child;
  const MyScaffold({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clr1 = Color(0xff2a5298);
    final clr2 = Color(0xff1e3c72);
    final gradient = LinearGradient(
      colors: [clr1, clr2],
      begin: Alignment.topCenter,
      tileMode: TileMode.mirror,
      end: Alignment.bottomRight,
    );
    return SafeArea(
      child: Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(gradient: gradient),
            child: child),
      ),
    );
  }
}
