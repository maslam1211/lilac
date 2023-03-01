import 'package:flutter/material.dart';
import 'package:lilac_project/shared_preference/provider/dark_theme.dart';
import 'package:lilac_project/shared_preference/provider/theme_data.dart';
import 'package:provider/provider.dart';

import 'login_otp/login_screen.dart';

void main() {
  runApp( const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider =  DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) {
          return themeChangeProvider;
        } ,
        child: Consumer<DarkThemeProvider>(
          builder: (context, value, child) {
            return MaterialApp(
                theme: Styles.themeData(themeChangeProvider.darkTheme, context),
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                home: LoginScreen());
          },
        ));
  }
}
