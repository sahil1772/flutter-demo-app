import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpVerificationService {
  static const _baseUrl = 'https://api.example.com/auth'; // Hypothetical base URL

  /// Verifies the OTP with the backend.
  /// [otp]: The OTP entered by the user.
  /// [identifier]: A unique identifier for the OTP context (e.g., user ID, phone number).
  /// [expectedExpirySeconds]: The intended expiry duration in seconds, passed to the server to aid its validation.
  /// Returns true if OTP is accepted by the server, false otherwise.
  Future<bool> verifyOtp(String otp, String identifier, int expectedExpirySeconds) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'otp': otp,
          'identifier': identifier, // Pass identifier to contextualize OTP verification
          'expectedExpirySeconds': expectedExpirySeconds, // Inform server of intended expiry
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Assuming the server returns a 'verified' boolean or similar status
        return data['verified'] == true;
      }
      return false; // Treat non-200 status as failure
    } catch (e) {
      // Log error for debugging purposes
      print('OTP verification API call failed: $e');
      return false;
    }
  }
}