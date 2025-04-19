import 'package:flutter/material.dart';
import 'package:lg_pilot/utils/colors.dart';
import 'package:lg_pilot/widgets/appbar.dart';
import 'package:lg_pilot/widgets/button.dart';
import 'package:lg_pilot/widgets/input_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiKeyPage extends StatelessWidget {
  const ApiKeyPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    SharedPreferences.getInstance().then((prefs) {
      controller.text = prefs.getString("api_key") ?? '';
    });
    return Scaffold(
      appBar: AppBarPilot(title: 'Pilot'),
      backgroundColor: ThemeColors.backgroundColor,
      body: Column(
        children: [
          SizedBox(height: 20),
          InputBar(
            showIcon: true,
            hintText: 'Gemini API Key',
            onIconPressed: () {
              launchUrl(Uri.parse("https://aistudio.google.com/apikey"));
            },
            icon: Icons.info_outline,
            controller: controller,
          ),
          SizedBox(height: 20),
          PilotButton(
            text: "SAVE",
            onPressed: () {
              SharedPreferences.getInstance().then((prefs) {
                prefs.setString("api_key", controller.text);
              });

              Navigator.pop(context);
            },
            fillColor: ThemeColors.inverseBackgroundColor,
            textDecoration: TextStyle(
              fontSize: 17.0,
              color: ThemeColors.inverseTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
