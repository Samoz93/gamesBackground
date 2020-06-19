import 'package:backgrounds/Screens/MainScreed.dart';
import 'package:backgrounds/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'Tools/ProvidersSetup.dart';
import 'Widgets/Splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Games Wallpaper',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.graduateTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AnimatedSplash(
          imagePath: 'images/icon.jpeg',
          home: MainScreen(),
          customFunction: () async {
            //await for login
            final prUser = locator<AuthService>();
            await prUser.loginAnonymously();
            return "s";
          },
          duration: 100,
          outputAndHome: {"s": MainScreen()},
          type: AnimatedSplashType.BackgroundProcess,
        ),
      ),
    );
  }
}
