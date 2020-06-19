import 'package:backgrounds/Screens/ImageScreen.dart';
import 'package:backgrounds/Tools/BaseWidget.dart';
import 'package:backgrounds/Tools/Consts.dart';
import 'package:backgrounds/Tools/MyImage.dart';
import 'package:backgrounds/Widgets/AdWidget.dart';
import 'package:backgrounds/Widgets/CustomNetImage.dart';
import 'package:backgrounds/Widgets/LoadingWidget.dart';
import 'package:backgrounds/Widgets/MyErrorPage.dart';
import 'package:backgrounds/Widgets/MyScaffold.dart';
import 'package:backgrounds/services/ImagePagination.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ImageGridScreen extends StatefulWidget {
  final String type;
  const ImageGridScreen({Key key, this.type}) : super(key: key);

  @override
  _ImageGridScreenState createState() => _ImageGridScreenState();
}

class _ImageGridScreenState extends State<ImageGridScreen> {
  var isSlide = false;

  final wid = Ad();

  @override
  Widget build(BuildContext context) {
    // final media = MediaQuery.of(context).size;
    return MyScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          InkWell(
            onTap: () {
              setState(
                () {
                  isSlide = !isSlide;
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                isSlide ? Icons.grid_on : Icons.slideshow,
                size: 30,
              ),
            ),
          ),
        ],
        title: Text("Images"),
        centerTitle: true,
      ),
      child: BaseWidget<ImagePagination>(
        provider: ImagePagination(type: widget.type),
        builder: (context, pr, ch) => StreamBuilder<List<MyImage>>(
          stream: pr.newStream,
          initialData: [],
          builder:
              (BuildContext context, AsyncSnapshot<List<MyImage>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return LoadingWidget();
            if (snapshot.hasError)
              return MyErrorPage(
                err: snapshot.error,
              );
            final data = snapshot.data;
            if (data.isEmpty) return Text("No Data");
            return NotificationListener<ScrollNotification>(
              onNotification: (da) {
                return pr.extendLimit();
              },
              child: Stack(
                children: <Widget>[
                  isSlide
                      ? CarouselSlider.builder(
                          itemCount: data.length.adDataLength,
                          itemBuilder: (context, index) {
                            final imgIndex = index.adIndex;
                            final img = data[imgIndex];
                            return index % gridAdThreshould == 0
                                ? wid
                                : InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ImageScreen(
                                            url: img.url,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ImageScreen(
                                      url: img.url,
                                    ),
                                  );
                          },
                          options: CarouselOptions(
                            aspectRatio: 0.62,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 1,
                                  mainAxisSpacing: 1),
                          itemCount: data.length.adDataLength,
                          itemBuilder: (BuildContext context, int index) {
                            final imgIndex = index.adIndex;
                            final img = data[imgIndex];
                            return AnimationConfiguration.staggeredGrid(
                              // delay: Duration(milliseconds: 10),
                              position: imgIndex,
                              columnCount: (data.length ~/ 2).toInt(),
                              child: ScaleAnimation(
                                scale: 1.4,
                                child:
                                    index != 0 && index % gridAdThreshould == 0
                                        ? wid
                                        : _getImage(context, img.url, imgIndex),
                              ),
                            );
                          },
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _getImage(context, url, index) {
  return CustomNetImage(
    url: url,
    fit: BoxFit.cover,
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ImageScreen(
            url: url,
          ),
        ),
      );
    },
  );
}

extension MyFloor on num {
  int get adDataLength {
    return this + (this / gridAdThreshould).floor();
  }

  int get adIndex {
    return this - (this / gridAdThreshould).floor();
  }

  int test(ss) {
    return this + ss;
  }
}
