import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class IPFSService {
  Future<String> uploadToIPFS(String filePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(IPFS_API_URL));
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      var response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final respJson = jsonDecode(respStr);
        return respJson['Hash'];
      } else {
        throw Exception('Failed to upload to IPFS');
      }
    } catch (e) {
      print('Error uploading to IPFS: $e');
      rethrow;
    }
  }
}
