import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littledog/screens/home/home.dart';
import 'package:littledog/screens/startup/login.dart';
import 'package:littledog/screens/startup/register.dart';
import 'package:littledog/screens/startup/splashscreen.dart';
import 'package:littledog/screens/tabscreen.dart';
import 'package:littledog/utils/theme.dart';
import 'package:provider/provider.dart';

import 'modals/appstate.dart';

import 'utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  buildMaterialApp() {
    return MaterialApp(
      title: 'Dogs Life',
      theme: new ThemeData(
          primarySwatch: SalonTheme.color,
          iconTheme: IconThemeData(color: SalonTheme.color)),
      initialRoute: "/",
      routes:{
        '/': (context) => SplashScreen(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/home': (context) => Home(),
        '/tabScreen': (context) => TabScreen(),
      },
      onGenerateRoute: Routes.generateRoute,
      onUnknownRoute: Routes.unknownRoute,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => AppState(),
        )
      ],
      child: Consumer<AppState>(
        builder: (context, counter, _) {
          return buildMaterialApp();
        },
      ),
    );
  }
}
