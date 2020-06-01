import 'package:backgrounds/Screens/ImagGridScreen.dart';
import 'package:backgrounds/Screens/ImageScreen.dart';
import 'package:backgrounds/Tools/Consts.dart';
import 'package:backgrounds/Tools/MyImage.dart';
import 'package:backgrounds/Widgets/CustomNetImage.dart';
import 'package:backgrounds/Widgets/MyErrorPage.dart';
import 'package:backgrounds/services/ImageService.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import 'LoadingWidget.dart';

class TypeCarousel extends StatelessWidget {
  final String type;
  TypeCarousel({Key key, this.type}) : super(key: key);
  final List<String> lst = [];
  final key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    final pr = Provider.of<ImageService>(context, listen: false);
    final media = MediaQuery.of(context).size;
    return StreamBuilder<List<MyImage>>(
      stream: pr.getImageStream(type: type, limit: 10),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<MyImage>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return LoadingWidget();
        if (snapshot.hasError) return MyErrorPage(err: snapshot.error);
        if (!snapshot.hasData || snapshot.data.isEmpty)
          return SizedBox.shrink();
        final dataSet = snapshot.data.toSet();
        return Column(
          children: <Widget>[
            Card(
              color: mainColorYellow,
              child: Container(
                width: media.width * 0.7,
                height: 45,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    type,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          letterSpacing: 8,
                          color: Colors.black,
                        ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CarouselSlider.builder(
              itemCount: dataSet.length + 1,
              itemBuilder: (context, index) {
                if (index >= dataSet.length)
                  return Center(
                      child: Container(
                          height: media.height,
                          width: media.width,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: _getSeeMore(context)));
                final url = dataSet.elementAt(index).url;
                var heroTag = "$url";
                if (lst.contains(heroTag))
                  heroTag = DateTime.now().microsecondsSinceEpoch.toString();
                lst.add(heroTag);
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: ScaleAnimation(
                    scale: 0.4,
                    child: Hero(
                      key: key,
                      tag: heroTag,
                      child: CustomNetImage(
                        url: url,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ImageScreen(
                                url: url,
                              ),
                            ),
                          );
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                aspectRatio: 1.05,
                autoPlay: false,
                pageViewKey: PageStorageKey(type),
                autoPlayAnimationDuration: Duration(milliseconds: 200),
                autoPlayCurve: Curves.easeInQuart,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                scrollPhysics: BouncingScrollPhysics(),
                viewportFraction: 0.6,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: media.width * 0.45,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _getSeeMore(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _getSeeMore(BuildContext context) {
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "See More",
            style: TextStyle(
              color: mainColorYellow,
              fontSize: 20,
            ),
          ),
          Icon(
            Icons.navigate_next,
            color: mainColorYellow,
          )
        ],
      ),
      onPressed: () async {
        // final pr = locator<ImageService>();
        // await pr.rewriteData();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ImageGridScreen(
              type: type,
            ),
          ),
        );
      },
    );
  }
}
