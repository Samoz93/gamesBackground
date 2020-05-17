import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget appBar;
  const MyScaffold({Key key, this.child, this.appBar}) : super(key: key);

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
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(gradient: gradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: child,
      ),
    );
  }
}
