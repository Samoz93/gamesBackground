import 'package:backgrounds/Widgets/LoadingWidget.dart';
import 'package:backgrounds/Widgets/MyErrorPage.dart';
import 'package:backgrounds/Widgets/MyScaffold.dart';
import 'package:backgrounds/Widgets/TypeCarousel.dart';
import 'package:backgrounds/services/AuthService.dart';
import 'package:backgrounds/services/ImageService.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ket = PageController(viewportFraction: 0.8);
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    final prUser = Provider.of<AuthService>(context);
    final pr = Provider.of<ImageService>(context, listen: false);
    return MyScaffold(
      child: FutureBuilder(
        future: prUser.isloggedIn,
        initialData: false,
        builder: (context, snap) {
          if (snap.data)
            return StreamBuilder<List<dynamic>>(
              stream: pr.types,
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return LoadingWidget();
                if (snapshot.hasError) return MyErrorPage(err: snapshot.error);
                final data = snapshot.data;
                return Container(
                  height: media.height,
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                      aspectRatio: 0.7,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.vertical,
                      // viewportFraction: 0.79,
                    ),
                    itemCount: data.length,
                    key: PageStorageKey("main"),
                    itemBuilder: (BuildContext context, int index) {
                      return TypeCarousel(
                        type: data[index],
                      );
                    },
                  ),
                );
              },
            );

          return LoadingWidget();
        },
      ),
    );
  }
}
