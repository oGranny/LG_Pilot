import 'dart:convert';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:lg_pilot/Services/kml_service.dart';
import 'package:lg_pilot/Services/lg_service.dart';
import 'package:lg_pilot/entities/coordinate_entity.dart';
import 'package:lg_pilot/entities/message_entity.dart';
import 'package:lg_pilot/entities/model_entity.dart';
import 'package:lg_pilot/utils/colors.dart';
import 'package:lg_pilot/utils/prompt.dart';
import 'package:lg_pilot/widgets/appbar.dart';
import 'package:lg_pilot/widgets/bounce_progress_indicator.dart';
import 'package:lg_pilot/widgets/drawer.dart';
import 'package:lg_pilot/widgets/input_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MessageEntity> response = [];
  TextEditingController controller = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    loadApiKey();
  }

  String? apiKey;

  Future<void> loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      apiKey = prefs.getString('api_key');
    });
  }

  Future<Map<String, dynamic>> fetchResponse(String text) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
    );
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt + text},
              ],
            },
          ],
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode}');
        return {
          "error": "Failed to load data, status code: ${response.statusCode}",
        };
      }
    } catch (e) {
      print('Error: $e');
      return {"error": e};
    }
  }

  void onSubmit() async {
    LgService lgService = Provider.of<LgService>(context, listen: false);
    FlutterTts flutterTts = FlutterTts();
    // await flutterTts.setPitch(0.1);

    String controllerData = controller.text.trim();
    MessageEntity msg = MessageEntity(
      rawMessage: {'request': controllerData},
      response: controllerData,
      isUserMessage: true,
    );
    setState(() {
      response.add(msg);
      controller.clear();
      isLoading = true;
    });

    Map<String, dynamic> data = await fetchResponse(controllerData);
    if (data.containsKey('error')) {
      msg = MessageEntity(
        rawMessage: data,
        response: data['error'],
        isUserMessage: false,
      );
    } else {
      Map<String, dynamic> rawData = jsonDecode(
        data['candidates'][0]['content']['parts'][0]['text']
            .split('```json')[1]
            .split('```')[0],
      );
      msg = MessageEntity(
        rawMessage: rawData,
        response: rawData['response'],
        isUserMessage: false,
      );
    }
    print(msg.rawMessage);
    setState(() {
      response.add(msg);
      isLoading = false;
    });

    if (msg.rawMessage['from'] != null && msg.rawMessage['to'] != null) {
      double dist = Math.sqrt(
        Math.pow(
              msg.rawMessage['from']['lat'] - msg.rawMessage['to']['lat'],
              2,
            ) +
            Math.pow(
              msg.rawMessage['from']['lon'] - msg.rawMessage['to']['lon'],
              2,
            ),
      );
      Coordinate from = Coordinate(
        latitude: msg.rawMessage['from']['lat'],
        longitude: msg.rawMessage['from']['lon'],
        altitude: (msg.rawMessage['from']['alt'] as num?)?.toDouble(),
        // timeInterval: 100,
      );

      Coordinate to = Coordinate(
        latitude: msg.rawMessage['to']['lat'],
        longitude: msg.rawMessage['to']['lon'],
        altitude: (msg.rawMessage['to']['alt'] as num?)?.toDouble(),
      );
      KmlService kmlService = KmlService(
        end: to,
        start: from,
        model: Model(
          href: 'model.dae',
          scaleX: 10000.0,
          scaleY: 10000.0,
          scaleZ: 10000.0,
        ),
      );
      String kmlContent = kmlService.generateKml();
      // print(kmlContent);
      // String content = await rootBundle.loadString('assets/model.dae');
      // await lgService.sendFile('/var/www/html/model.dae', utf8.encode(content));
      flutterTts.setLanguage('en-US');
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(
        "Ladies and gentlemen. Welcome aboard this flight from ${msg.rawMessage['from']['city']} to ${msg.rawMessage['to']['city']}. We’re just about ready for departure, so please sit back, relax, and enjoy the flight.",
      );
      await lgService.sendFile(
        '/var/www/html/pilot.kml',
        (utf8.encode(kmlContent)),
      );
      print('KML file sent to LG server.');
      // await flutterTts.speak(
      //   "flying from ${msg.rawMessage['from']['city']} to ${msg.rawMessage['to']['city']}",
      // );
      await lgService.clearKml();

      print('KML file cleared.');

      await lgService.execCommand(
        'echo "flytoview=<LookAt><longitude>${from.longitude}</longitude><latitude>${from.latitude}</latitude><range>${90200.297285}</range><tilt>${0}</tilt><heading>${0}</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>" > /tmp/query.txt',
      );
      await Future.delayed(Duration(seconds: 7));
      await lgService.execCommand(
        'echo "flytoview=<LookAt><longitude>${to.longitude}</longitude><latitude>${to.latitude}</latitude><range>${90200.297285}</range><tilt>${0}</tilt><heading>${0}</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>" > /tmp/query.txt',
      );
      await Future.delayed(Duration(seconds: 7));
      print('LookAt command executed.');
      await lgService.execCommand(
        'echo "exittour=true" > /tmp/query.txt && > /var/www/html/kmls.txt && echo "http://lg1:81/pilot.kml" > /var/www/html/kmls.txt',
      );
      await lgService.execCommand('echo "playtour=Flight" > /tmp/query.txt');
      await lgService.execCommand("");
    } else if (msg.rawMessage['location'] != null) {
      flutterTts.setLanguage('en-US');
      flutterTts.setSpeechRate(0.5);
      flutterTts.speak("orbiting around ${msg.rawMessage['location']['city']}");
      Coordinate location = Coordinate(
        latitude: msg.rawMessage['location']['lat'],
        longitude: msg.rawMessage['location']['lon'],
        altitude: (msg.rawMessage['location']['alt'] as num?)?.toDouble(),
        range: data['range'] ?? 100000.0,
      );
      await lgService.clearKml();
      String kmlContent = KmlService.generateOrbit(location);
      await lgService.sendFile(
        '/var/www/html/Orbit.kml',
        (utf8.encode(kmlContent)),
      );
      await lgService.execCommand(
        'echo "http://lg1:81/Orbit.kml" >> /var/www/html/kmls.txt',
      );
      await lgService.execCommand('echo "playtour=Orbit" > /tmp/query.txt');
      print('Orbit file sent to LG server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPilot(title: "Pilot"),
      drawer: DrawerPilot(),
      backgroundColor: ThemeColors.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child:
                response.isEmpty
                    ? PlaceholderMainPage()
                    : ChatListView(response: response, isLoading: isLoading),
          ),
          InputBar(
            controller: controller,
            hintText: "Ask Pilot",
            onIconPressed: onSubmit,
            showIcon: true,
            icon: Icons.send_rounded,
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}

class ChatListView extends StatelessWidget {
  const ChatListView({
    super.key,
    required this.response,
    required this.isLoading,
  });

  final List<MessageEntity> response;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: response.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (isLoading && index == response.length) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SpinKitThreeBounce(
                  size: 20,
                  color: ThemeColors.inverseBackgroundColor,
                ),
              ),
            ],
          );
        }
        final message = response[index];
        return Align(
          alignment:
              message.isUserMessage
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth:
                  MediaQuery.of(context).size.width *
                  (message.isUserMessage ? 0.75 : 0.8),
            ),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  message.isUserMessage
                      ? ThemeColors.primaryColor
                      : ThemeColors.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message.response,
              style: TextStyle(color: ThemeColors.primaryTextColor),
            ),
          ),
        );
      },
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
