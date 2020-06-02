import 'package:backgrounds/Tools/Consts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetImage extends StatefulWidget {
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
  _CustomNetImageState createState() => _CustomNetImageState();
}

class _CustomNetImageState extends State<CustomNetImage> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Material(
      child: InkWell(
        onTap: widget.onTap,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: widget.url,
            fit: widget.fit,
            width: widget.width ?? media.width,
            height: widget.height ?? media.height,
            placeholder: (context, s) => Container(
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [mainColorYellow, Colors.blue])),
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                )), //LoadingWidget(),
            errorWidget: (_, ss, s) => Stack(
              children: <Widget>[
                Container(
                  height: media.height,
                  width: media.width,
                  child: Image(
                    image: NetworkImage(
                      "https://toppng.com/uploads/preview/emoji-glitch-popart-kpop-text-textbox-error-face-11563322597vypecnobqs.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    color: Colors.black54,
                    child: Center(
                      child: Text(
                        "Error loading Picture",
                        style: TextStyle(color: Colors.white),
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
