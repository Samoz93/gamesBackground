import 'dart:io';

import 'package:backgrounds/Tools/Consts.dart';
import 'package:backgrounds/Widgets/CustomNetImage.dart';
import 'package:backgrounds/Widgets/MyScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class ImageScreen extends StatelessWidget {
  final String url;
  const ImageScreen({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MyScaffold(
        child: Stack(
          children: <Widget>[
            Hero(
              tag: url,
              child: CustomNetImage(
                url: url,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SetAsWallpaperButton(
                url: url,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  print("sss");
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SetAsWallpaperButton extends StatefulWidget {
  final String url;
  SetAsWallpaperButton({Key key, this.url}) : super(key: key);

  @override
  _SetAsWallpaperButtonState createState() => _SetAsWallpaperButtonState();
}

class _SetAsWallpaperButtonState extends State<SetAsWallpaperButton> {
  bool isDownloading = false;
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final isIos = Platform.isIOS;
    return Card(
      color: mainColorYellow,
      child: Container(
        width: media.width * 0.7,
        height: media.height * 0.08,
        child: isDownloading
            ? Center(child: CircularProgressIndicator())
            : FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(isIos ? "Save to Gallery" : "Set as Wallpaper"),
                    Icon(Icons.wallpaper)
                  ],
                ),
                onPressed: () async {
                  try {
                    setState(() {
                      isDownloading = true;
                    });

                    int location = WallpaperManager
                        .HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;

                    var file =
                        await DefaultCacheManager().getSingleFile(widget.url);

                    if (!isIos)
                      await WallpaperManager.setWallpaperFromFile(
                          file.path, location);

                    await GallerySaver.saveImage(
                      file.path,
                    );

                    setState(() {
                      isDownloading = false;
                    });
                    // print(result);
                  } catch (e) {
                    print(e);
                  }
                },
              ),
      ),
    );
  }
}
