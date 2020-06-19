import 'dart:async';

import 'package:backgrounds/Tools/AdsConst.dart';
import 'package:backgrounds/Tools/Consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';

import 'LoadingWidget.dart';

class Ad extends StatefulWidget {
  const Ad({Key key}) : super(key: key);

  @override
  _AdState createState() => _AdState();
}

class _AdState extends State<Ad> {
  final _controller = NativeAdmobController();
  Timer timer;
  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 60), (timer) {
      if (!isDev) _controller.reloadAd(forceRefresh: true);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [mainColorYellow, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: NativeAdmob(
          adUnitID: theAdsInfo.nativeAd,
          loading: Center(child: LoadingWidget()),
          error: Text("Failed to load the ad"),
          controller: _controller,
          type: NativeAdmobType.full,
          options: NativeAdmobOptions(
            ratingColor: Colors.red,
            showMediaContent: true,
            bodyTextStyle: NativeTextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
