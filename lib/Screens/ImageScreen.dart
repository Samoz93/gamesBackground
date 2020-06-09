import 'dart:io';

import 'package:backgrounds/Tools/Consts.dart';
import 'package:backgrounds/Widgets/CustomNetImage.dart';
import 'package:backgrounds/Widgets/MyScaffold.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:device_info/device_info.dart';

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

const albumname = "Game Gallery";

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
                  bool isSafeToSaveToGallery;
                  try {
                    setState(() {
                      isDownloading = true;
                    });
                    var file =
                        await DefaultCacheManager().getSingleFile(widget.url);

                    if (Platform.isIOS) {
                      isSafeToSaveToGallery = true;
                    } else {
                      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      AndroidDeviceInfo androidInfo =
                          await deviceInfo.androidInfo;

                      isSafeToSaveToGallery = androidInfo.version.sdkInt < 29;
                      int location = WallpaperManager
                          .HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
                      await WallpaperManager.setWallpaperFromFile(
                          file.path, location);
                    }

                    if (isSafeToSaveToGallery) {
                      GallerySaver.saveImage(file.path, albumName: albumname);
                    }

                    setState(() {
                      isDownloading = false;
                    });
                    showFlush(context, true, isSafeToSaveToGallery);
                    // print(result);
                  } catch (e) {
                    print(e);
                    setState(() {
                      isDownloading = false;
                    });
                    showFlush(context, false, isSafeToSaveToGallery);
                  }
                },
              ),
      ),
    );
  }

  showFlush(BuildContext context, isOk, isSafeToSaveToGallery) {
    final color = isOk ? Colors.green : Colors.red;
    Flushbar(
      duration: Duration(seconds: 2),
      barBlur: 5,
      leftBarIndicatorColor: color,
      routeColor: color,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      shouldIconPulse: true,
      titleText: Text(
        isOk ? "Sucess " : "Error ",
        style: TextStyle(fontSize: 20, color: color),
      ),
      icon: Icon(
        Icons.done,
        color: color,
      ),
      messageText: Text(
        isOk
            ? isSafeToSaveToGallery
                ? "Image have been saved to the album \" $albumname"
                : "Done Setting your wallpaper"
            : "Some error happened try again later",
      ),
      backgroundColor: mainColorYellow,
    ).show(context);
  }
}
