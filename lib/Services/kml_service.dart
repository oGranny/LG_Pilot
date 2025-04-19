import 'package:lg_pilot/entities/coordinate_entity.dart';
import 'package:lg_pilot/entities/model_entity.dart';

class KmlService {
  final Coordinate start;
  final Coordinate end;
  int? numberOfPoints = 1000;
  Model model = Model(
    href: 'model.dae',
    scaleX: 1000.0,
    scaleY: 1000.0,
    scaleZ: 1000.0,
  );

  late List<Coordinate> coordinates;

  KmlService({required this.start, required this.end, required this.model}) {
    coordinates = Coordinate.interpolate(start, end, 1000);
  }

  String generateCoordinateTags() {
    return coordinates
        .map((coordinate) {
          return '${coordinate.longitude},${coordinate.latitude},${coordinate.altitude}';
        })
        .join(' ');
  }

  String generateKmlHead() {
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
      <BalloonStyle>
        <bgColor>ffffffff</bgColor>
        <text><![CDATA[
              <b><font size="+2">TRANSIT 5B-5 <font color="#5D5D5D">(ALIVE)</font></font></b>
    <br/><br/>
    <img height="200" src="https://db-satnogs.freetls.fastly.net/media/satellites/transit-o__1.jpg"><br/><br/>
    <b>NORAD ID:</b> 965
    <br/>
    <b>Alternames:</b> OPS 6582
    <br/>
    <b>Countries:</b> US
    <br/>
    <b>Operator:</b> None
    <br/>
    <b>Transmitters:</b> 6
    <br/>
    <b>Launched:</b> December 13, 1964 12:00 AM
    <br/>
    <b>Deployed:</b> Never
    <br/>
    <b>Decayed:</b> Never
  
        ]]></text>
      </BalloonStyle>
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
          <altitude>${coordinates[0].altitude}</altitude>
        <range>${coordinates[0].range}</range>
        <tilt>60</tilt>
        <heading>0</heading>
        <gx:altitudeMode>relativeToGround</gx:altitudeMode>
      </LookAt>
    
      <Model>
      <altitudeMode>relativeToGround</altitudeMode>
        <Location>
          <longitude>${coordinates[0].longitude}</longitude>
          <latitude>${coordinates[0].latitude}</latitude>
          <altitude>${coordinates[0].altitude}</altitude>
        </Location>
        <Orientation>
          <heading>0</heading>
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
            ${generateCoordinateTags()}
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
    String tail = "";
    for (Coordinate cord in coordinates) {
      tail += '''
<gx:FlyTo>
<gx:duration>0.4</gx:duration>
<gx:flyToMode>smooth</gx:flyToMode>
<LookAt>
  <longitude>${cord.longitude}</longitude>
  <latitude>${cord.latitude}</latitude>
  <altitude>${cord.altitude}</altitude>
  <heading>1.0</heading>
  <tilt>60</tilt>
  <range>${1000000}</range>
  <gx:altitudeMode>relativeToGround</gx:altitudeMode>
</LookAt>
</gx:FlyTo>

<gx:AnimatedUpdate>
  <gx:duration>0.7</gx:duration>
  <Update>
    <targetHref/>
    <Change>
      <Placemark targetId="p-SCHX-0895-2361-9925-0309">
        <Model>
          <Location>
            <longitude>${cord.longitude}</longitude>
            <latitude>${cord.latitude}</latitude>
            <altitude>${cord.altitude}</altitude>
          </Location>
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
