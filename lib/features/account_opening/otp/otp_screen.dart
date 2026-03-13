import 'package:flutter/material.dart';
import 'dart:async';

class OtpScreen extends StatefulWidget {
  final int otpExpirySeconds;
  const OtpScreen({super.key, this.otpExpirySeconds = 120});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  Timer? _timer;
  late int _countdown; // Initialize based on widget.otpExpirySeconds
  late DateTime _otpSentTime; // To track actual time since OTP was sent
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _countdown = widget.otpExpirySeconds; // Correctly initialize countdown with actual expiry
    _otpSentTime = DateTime.now(); // Record the time the OTP was 'sent' (screen loaded)
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOtp() async {
    setState(() => _isVerifying = true);

    if (_otpController.text.isEmpty || _otpController.text.length != 6) {
      _showError('Please enter a valid 6-digit OTP.');
      setState(() => _isVerifying = false);
      return;
    }

    // Client-side pre-submission check: prevent sending if UI timer expired
    if (_countdown <= 0) {
      _showError('OTP has expired on the client-side. Please request a new one.');
      setState(() => _isVerifying = false);
      return;
    }

    final OtpVerificationService service = OtpVerificationService();
    final String otp = _otpController.text;

    // Call actual service, passing intended expiry to the backend
    final bool isServerAccepted = await service.verifyOtp(
      otp,
      'some_user_id', // Placeholder for user/session identifier
      widget.otpExpirySeconds,
    );

    setState(() {
      _isVerifying = false;
      if (isServerAccepted) {
        // Client-side post-submission re-validation:
        // Even if the server accepted it, check if it truly should have expired
        // based on the intended expiry, overriding lenient server behavior.
        final Duration elapsedTime = DateTime.now().difference(_otpSentTime);
        final bool trulyExpiredOnClient = elapsedTime.inSeconds > widget.otpExpirySeconds;

        if (trulyExpiredOnClient) {
          _showError('OTP verification failed: OTP expired. Server accepted it, but it was past its intended validity period.');
          // Optionally log this server discrepancy for further investigation.
        } else {
          _showSuccess('OTP verified successfully!');
          // Navigate or perform next action
        }
      } else {
        _showError('OTP verification failed. Please check your OTP and try again.');
      }
    });
  }

  // Helper methods for showing messages
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _countdown > 0 ? 'Time remaining: $_countdown seconds' : 'OTP expired',
              style: TextStyle(
                fontSize: 16,
                color: _countdown > 0 ? Colors.black : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(labelText: 'Enter OTP'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isVerifying ? null : _verifyOtp,
              child: _isVerifying
                  ? const CircularProgressIndicator()
                  : const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
