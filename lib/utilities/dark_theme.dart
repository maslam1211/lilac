import 'package:flutter/material.dart';
import 'package:lilac_project/shared_preference/provider/dark_theme.dart';
import 'package:provider/provider.dart';

class DarkThemeScreen extends StatelessWidget {
  const DarkThemeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListTile(
            leading: Text(
              "Change Theme",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Switch(
              value: themeChange.darkTheme,
              onChanged: (value) {
                themeChange.darkTheme = value;
              },
            ),
            minLeadingWidth: 1,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
