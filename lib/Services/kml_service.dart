import 'dart:math' as Math;

import 'package:lg_pilot/entities/coordinate_entity.dart';
import 'package:lg_pilot/entities/model_entity.dart';

class KmlService {
  final Coordinate start;
  final Coordinate end;
  Model model = Model(
    href: 'model.dae',
    scaleX: 100000.0,
    scaleY: 100000.0,
    scaleZ: 100000.0,
  );

  late List<Coordinate> coordinates;
  late double timeInt;
  KmlService({required this.start, required this.end, required this.model}) {
    timeInt = start.timeInterval;
    coordinates = Coordinate.interpolate(start, end);
  }

  double calculateAlt() {
    // double dist = Math.sqrt(
    //   Math.pow(end.latitude - start.latitude, 2) +
    //       Math.pow(end.longitude - start.longitude, 2) +
    //       Math.pow((end.altitude ?? 0) - (start.altitude ?? 0), 2),
    // );
    // return dist * 1e4;
    return 2 * 1e4;
  }

  double calculateRange() {
    // double dist = Math.sqrt(
    //   Math.pow(end.latitude - start.latitude, 2) +
    //       Math.pow(end.longitude - start.longitude, 2) +
    //       Math.pow((end.altitude ?? 0) - (start.altitude ?? 0), 2),
    // );
    // return dist * 1e4;
    return 5 * 1e5;
  }

  String generateCoordinateTags(double? altitude) {
    return coordinates
        .map((coordinate) {
          return '${coordinate.longitude},${coordinate.latitude},${altitude ?? coordinate.altitude}';
        })
        .join(' ');
  }

  double calculateHeading(Coordinate start, Coordinate end) {
    double deltaLongitude = end.longitude - start.longitude;
    double deltaLatitude = end.latitude - start.latitude;
    double heading =
        Math.atan2(deltaLongitude, deltaLatitude) * (180 / Math.pi);
    return (heading + 180) % 360; // Normalize to 0-360 degrees
  }

  String generateKmlHead() {
    double alt = calculateAlt();
    double range = calculateRange();
    print('range: $range');
    print('alt: $alt');
    print(model.scaleX);
    String head = '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <name>Flight Visualization</name>
    <open>1</open>
    <Folder>
          <Style id="high-SCHX-0895-2361-9925-0309">
      <IconStyle>
        <scale>3.0</scale>
        <Icon>
          <href>satellite.png</href>
        </Icon>
        <hotSpot x="0.5" y="0.5" xunits="fraction" yunits="fraction" />
      </IconStyle>
    </Style>
    <Style id="normal-SCHX-0895-2361-9925-0309">
      <IconStyle>
        <scale>2.5</scale>
        <Icon>
          <href>satellite.png</href>
        </Icon>
        <hotSpot x="0.5" y="0.5" xunits="fraction" yunits="fraction" />
      </IconStyle>

    </Style>
    <Style id="line-SCHX-0895-2361-9925-0309">
      <LineStyle>
        <color>ffefedf0</color>
        <colorMode>normal</colorMode>
        <width>5.0</width>
        <gx:outerColor>ffefedf0</gx:outerColor>
        <gx:outerWidth>0.0</gx:outerWidth>
        <gx:physicalWidth>0.0</gx:physicalWidth>
        <gx:labelVisibility>0</gx:labelVisibility>
      </LineStyle>
      <PolyStyle>
        <color>00000000</color>
      </PolyStyle>
    </Style>
    <StyleMap id="SCHX-0895-2361-9925-0309">
      <Pair>
        <key>normal</key>
        <styleUrl>normal-SCHX-0895-2361-9925-0309</styleUrl>
      </Pair>
      <Pair>
        <key>highlight</key>
        <styleUrl>high-SCHX-0895-2361-9925-0309</styleUrl>
      </Pair>
    </StyleMap>
    <Placemark id="p-SCHX-0895-2361-9925-0309">
      <name>TRANSIT 5B-5 (ALIVE)</name>
      <description><![CDATA[https://secwww.jhuapl.edu/techdigest/Content/techdigest/pdf/V05-N04/05-04-Danchik.pdf https://www.satellitenwelt.de/transit_5b-5.htm]]></description>
      <LookAt>
          <longitude>${coordinates[0].longitude}</longitude>
          <latitude>${coordinates[0].latitude}</latitude>
          <altitude>$alt</altitude>
        <range>$range</range>
        <tilt>60</tilt>
        <heading>0</heading>
        <gx:altitudeMode>relativeToGround</gx:altitudeMode>
      </LookAt>
    
      <Model>
      <altitudeMode>relativeToGround</altitudeMode>
        <Location>
          <longitude>${coordinates[0].longitude}</longitude>
          <latitude>${coordinates[0].latitude}</latitude>
          <altitude>$alt</altitude>
        </Location>
        <Orientation>
            <heading>${calculateHeading(coordinates[0], coordinates[1])}</heading>
          <tilt>0</tilt>
          <roll>0</roll>
        </Orientation>
        <Scale>
          <x>${model.scaleX}</x>
          <y>${model.scaleY}</y>
          <z>${model.scaleZ}</z>
        </Scale>
        <Link>
          <href>${model.href}</href>
        </Link>
      </Model>
    
      <visibility>1</visibility>
      <gx:balloonVisibility>0</gx:balloonVisibility>
    </Placemark>
    <Placemark>
      <name>Flight Path</name>
      <styleUrl>line-SCHX-0895-2361-9925-0309</styleUrl>
            <Polygon id="SCHX-0895-2361-9925-0309">
        <extrude>0</extrude>
        <altitudeMode>absolute</altitudeMode>
        <outerBoundaryIs>
          <LinearRing>
            <coordinates>
            ${generateCoordinateTags(alt)}
            </coordinates>
          </LinearRing>
        </outerBoundaryIs>
      </Polygon>
    </Placemark>
    <gx:Tour>
      <name>Flight</name>
      <gx:Playlist>
''';
    return head;
  }

  String generateKMLTail() {
    double alt = calculateAlt();
    double range = calculateRange();

    String tail = "";
    for (Coordinate cord in coordinates) {
      tail += '''
<gx:FlyTo>
<gx:duration>$timeInt</gx:duration>
<gx:flyToMode>smooth</gx:flyToMode>
<LookAt>
  <longitude>${cord.longitude}</longitude>
  <latitude>${cord.latitude}</latitude>
  <altitude>$alt</altitude>
  <heading>1.0</heading>
  <tilt>60</tilt>
  <range>$range</range>
  <gx:altitudeMode>relativeToGround</gx:altitudeMode>
</LookAt>
</gx:FlyTo>

<gx:AnimatedUpdate>
  <gx:duration>$timeInt</gx:duration>
  <Update>
    <targetHref/>
    <Change>
      <Placemark targetId="p-SCHX-0895-2361-9925-0309">
        <Model>
          <Location>
            <longitude>${cord.longitude}</longitude>
            <latitude>${cord.latitude}</latitude>
            <altitude>$alt</altitude>
          </Location>
          <Orientation>
            <heading>${coordinates.indexOf(cord) < coordinates.length - 1 ? calculateHeading(cord, coordinates[coordinates.indexOf(cord) + 1]) : calculateHeading(coordinates[coordinates.indexOf(cord) - 1], cord)}</heading>
            <tilt>0</tilt>
            <roll>0</roll>
          </Orientation>

        </Model>
      </Placemark>
    </Change>
  </Update>
</gx:AnimatedUpdate>

        ''';
    }
    return tail;
  }

  String generateKml() {
    return '''${generateKmlHead()}
    ${generateKMLTail()}      
      </gx:Playlist>
    </gx:Tour>
  
    </Folder>
  </Document>
</kml>
''';
  }
}
