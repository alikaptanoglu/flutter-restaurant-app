import 'package:flutter/material.dart';
import 'package:restaurant_app/home_page.dart';
import 'package:restaurant_app/detail_page.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/constraints/constraints.dart';
import 'package:restaurant_app/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(elevation: 0),
        textTheme: customTextTheme,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
              onPrimary: Colors.black,
              secondary: secondaryColor,
            ),
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        HomePage.routeName: (context) => const HomePage(),
        DetailPage.routeName: (context) => DetailPage(
            restaurant:
                ModalRoute.of(context)?.settings.arguments as Restaurant),
      },
    );
  }
}
