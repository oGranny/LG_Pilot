import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';

class LgService {
  String host = "192.168.121.3";
  int port = 22;
  String username = "lg";
  String password = "lg";
  int rigs = 3;

  Future<bool> checkConnection() async {
    try {
      final socket = await SSHSocket.connect(host, port);
      SSHClient(socket, username: username, onPasswordRequest: () => password);
      print('Connected to $host:$port');
      return true;
    } catch (e) {
      print('Failed to connect to $host:$port, $e');
      return false;
    }
  }

  Future<LgService> execCommand(String command) async {
    try {
      final socket = await SSHSocket.connect(host, port);
      final client = SSHClient(
        socket,
        username: username,
        onPasswordRequest: () => password,
      );
      await client.execute(command);
      // ignore: avoid_print
      print('Command sent to $host:$port');
    } catch (e) {
      print('Failed to send command to $host:$port, $e');
    }
    return this;
  }

  Future<LgService> sendFile(String remoteFilepath, Uint8List content) async {
    try {
      final socket = await SSHSocket.connect(host, port);
      final client = SSHClient(
        socket,
        username: username,
        onPasswordRequest: () => password,
      );

      final sftp = await client.sftp();

      final file = await sftp.open(
        remoteFilepath,
        mode:
            SftpFileOpenMode.truncate |
            SftpFileOpenMode.create |
            SftpFileOpenMode.write,
      );

      final fileStream = Stream.fromIterable([content]);
      int offset = 0;

      await for (final chunk in fileStream) {
        await file.write(Stream.fromIterable([chunk]), offset: offset);
        offset += chunk.length;
      }
      print('Done sending file');
    } catch (e) {
      print('Failed to send file to $host:$port, $e');
    }
    return this;
  }

  Future<SSHClient> getClient(host, port, username, password) async {
    final socket = await SSHSocket.connect(host, port);
    return SSHClient(
      socket,
      username: username,
      onPasswordRequest: () => password,
    );
  }
}
