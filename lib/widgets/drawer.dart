import 'package:flutter/material.dart';
import 'package:lg_pilot/pages/api_key.dart';
import 'package:lg_pilot/pages/connect_page.dart';
import 'package:lg_pilot/pages/tools_page.dart';
import 'package:lg_pilot/utils/colors.dart';

class DrawerPilot extends StatelessWidget {
  const DrawerPilot({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ThemeColors.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Text(
                'Pilot',
                style: TextStyle(
                  color: ThemeColors.primaryTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: Colors.white),
            title: const Text(
              'Connection',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => ConnectPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.code_outlined, color: Colors.white),
            title: const Text('API Key', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => ApiKeyPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.build_outlined, color: Colors.white),
            title: const Text('Tools', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => ToolsPage()));
            },
          ),
        ],
      ),
    );
  }
}
