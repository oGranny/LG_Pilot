import 'package:flutter/material.dart';
import 'package:lg_pilot/utils/colors.dart';
import 'package:lg_pilot/widgets/appbar.dart';
import 'package:lg_pilot/widgets/drawer.dart';
import 'package:lg_pilot/widgets/input_bar.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPilot(title: "Pilot"),
      drawer: DrawerPilot(),
      backgroundColor: ThemeColors.backgroundColor,
      body: Column(
        children: [
          Expanded(child: PlaceholderMainPage()),
          InputBar(
            hintText: "Ask Pilot",
            onIconPressed: () => {},
            showIcon: true,
            icon: Icons.mic_none_outlined,
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}

class PlaceholderMainPage extends StatelessWidget {
  const PlaceholderMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // SvgPicture.asset(
          //   'assets/pilot vector.svg',
          //   width: MediaQuery.of(context).size.width * 0.4,
          //   // height: 200,
          //   colorFilter: ColorFilter.mode(
          //     ThemeColors.primaryTextColor,
          //     BlendMode.srcIn,
          //   ),
          // ),
          Lottie.asset(
            'assets/plane_lottie.json',
            width: MediaQuery.of(context).size.width * 0.6,
            height: 200,
            alignment: Alignment.center,
            repeat: false,
          ),
          // const SizedBox(hei ght: 18),
          Text(
            'Welcome aboard, Captain.',
            style: TextStyle(
              color: ThemeColors.primaryTextColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            "What's our next destination?",
            style: TextStyle(
              color: ThemeColors.secondaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
