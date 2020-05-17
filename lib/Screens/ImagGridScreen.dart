import 'package:backgrounds/Screens/ImageScreen.dart';
import 'package:backgrounds/Tools/BaseWidget.dart';
import 'package:backgrounds/Tools/Consts.dart';
import 'package:backgrounds/Tools/MyImage.dart';
import 'package:backgrounds/Widgets/CustomNetImage.dart';
import 'package:backgrounds/Widgets/LoadingWidget.dart';
import 'package:backgrounds/Widgets/MyErrorPage.dart';
import 'package:backgrounds/Widgets/MyScaffold.dart';
import 'package:backgrounds/services/ImagePagination.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageGridScreen extends StatefulWidget {
  final String type;
  const ImageGridScreen({Key key, this.type}) : super(key: key);

  @override
  _ImageGridScreenState createState() => _ImageGridScreenState();
}

class _ImageGridScreenState extends State<ImageGridScreen> {
  var isSlide = false;
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
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
                pr.extendLimit();
              },
              child: Stack(
                children: <Widget>[
                  isSlide
                      ? CarouselSlider.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ImageScreen(
                                    url: data[index].url,
                                  ),
                                ),
                              );
                            },
                            child: ImageScreen(
                              url: data[index].url,
                            ),
                          ),
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
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _getImage(context, data[index].url);
                          },
                        ),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: SizedBox(
                  //     width: media.width * 0.7,
                  //     height: media.width * 0.15,
                  //     child: Card(
                  //       color: mainColorYellow,
                  //       child: FlatButton(
                  //         onPressed: () {
                  //           setState(
                  //             () {
                  //               isSlide = !isSlide;
                  //             },
                  //           );
                  //         },
                  //         materialTapTargetSize:
                  //             MaterialTapTargetSize.shrinkWrap,
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: <Widget>[
                  //             Text(isSlide ? "Grid" : "Slide Show"),
                  //             Icon(isSlide ? Icons.grid_on : Icons.slideshow),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getImage(context, url) {
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
}
