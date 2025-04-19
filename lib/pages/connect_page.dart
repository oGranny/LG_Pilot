import 'package:flutter/material.dart';
import 'package:lg_pilot/utils/colors.dart';
import 'package:lg_pilot/widgets/appbar.dart';
import 'package:lg_pilot/widgets/button.dart';
import 'package:lg_pilot/widgets/input_bar.dart';

class ConnectPage extends StatelessWidget {
  const ConnectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor,
      appBar: AppBarPilot(title: "Connect"),
      // drawer: DrawerPilot(  ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PilotButton(onPressed: () {}, text: "Scan Using QR"),
            ChoiceDivider(),
            FormInput(hintText: "192.168.56.121", labelText: "Host"),
            FormInput(
              hintText: "22",
              labelText: "Port",
              textInputType: TextInputType.number,
            ),
            FormInput(hintText: "lg", labelText: "Username"),
            FormInput(hintText: "lg", labelText: "Password"),
            FormInput(
              hintText: "3",
              labelText: "Number of Screens",
              textInputType: TextInputType.number,
            ),
            SizedBox(height: 20),
            PilotButton(
              text: "CONNECT",
              onPressed: () {},
              fillColor: ThemeColors.inverseBackgroundColor,
              // textColor: ThemeColors.inverseTextColor,
              textDecoration: TextStyle(
                fontSize: 20.0,
                color: ThemeColors.inverseTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormInput extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  const FormInput({
    super.key,
    required this.hintText,
    required this.labelText,
    this.controller,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 5),
          child: Text(
            labelText,
            style: TextStyle(color: ThemeColors.primaryTextColor),
          ),
        ),
        InputBar(
          hintText: hintText,
          showIcon: false,
          textInputType: textInputType,
        ),
        SizedBox(height: 3),
      ],
    );
  }
}

class ChoiceDivider extends StatelessWidget {
  const ChoiceDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 28),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("or", style: TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Divider(color: Colors.grey, thickness: 1)),
        ],
      ),
    );
  }
}
