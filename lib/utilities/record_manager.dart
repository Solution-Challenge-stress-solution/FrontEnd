import 'dart:io' show Platform;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class RecordManager {
  static final record = AudioRecorder();

  static Future<bool> checkPermission() async {
    bool hasPermission = await record.hasPermission();
    return hasPermission;
  }

  static Future<void> startRecord() async {
    bool isPermitted = await checkPermission();

    if (isPermitted) {
      final dir =
          await getApplicationDocumentsDirectory(); // or getTemporaryDirectory()
      String filePath = path.join(dir.path, 'diary.flac');

      await record.start(
          const RecordConfig(
            encoder: AudioEncoder.flac,
            sampleRate: 48000,
            numChannels: 1,
          ),
          path: filePath);
    }
  }

  static Future<String> stopRecord() async {
    final path = await record.stop();

    if (path is! String) {
      print(path);
      throw Exception('Path is empty!');
    } else {
      return path;
    }
  }

  static void disposeRecord() {
    record.dispose();
  }

  static Future<String> postFile(String filePath) async {
    var uri = Uri.parse(
        'http://34.64.90.112:8080/stt?os=${Platform.isAndroid ? 'android' : 'ios'}');
    var request = http.MultipartRequest('POST', uri);

    // Attach the file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'audioFile',
      filePath,
      contentType:
          MediaType('audio', 'x-flac'), // Ensure the file type is .flac
    ));

    try {
      var streamResponse = await request.send();
      var responseString = await streamResponse.stream.bytesToString();
      var jsonResponse = json.decode(responseString);

      if (streamResponse.statusCode == 200) {
        print("File uploaded successfully");
        return jsonResponse['data'];
      } else {
        print("Failed to upload file: ${streamResponse.statusCode}");
        return jsonResponse['message'] ?? 'Unknown error';
      }
    } catch (e) {
      print("Error sending file: $e");
      return '';
    }
  }
}
