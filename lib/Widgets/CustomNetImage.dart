import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double width;
  final double height;
  final Function onTap;
  const CustomNetImage(
      {Key key,
      @required this.url,
      this.fit,
      this.height,
      this.width,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: url,
            fit: fit,
            width: width ?? media.width,
            height: height ?? media.height,
            placeholder: (context, s) => Center(
                child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
              valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
            )), //LoadingWidget(),
            errorWidget: (_, ss, s) => Stack(
              children: <Widget>[
                Image(
                  image: AssetImage("assets/err.png"),
                ),
                Center(
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    color: Colors.black26,
                    child: Center(
                      child: Text(
                        "No Pic Found",
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
