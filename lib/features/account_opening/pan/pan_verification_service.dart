import 'dart:convert';
import 'package:http/http.dart' as http;

class PanVerificationService {
  static const _baseUrl = 'https://api.example.com/kyc';

  Future<Map<String, dynamic>?> verifyPan(String panNumber) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/verify-pan'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pan': panNumber}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final verifiedPan = data['panNumber'];
      final name = data['fullName'];

      if (verifiedPan == null) {
        return null;
      }

      return {
        'pan': verifiedPan,
        'name': name,
        'status': data['verification_status'],
      };
    }

    return null;
  }
}
