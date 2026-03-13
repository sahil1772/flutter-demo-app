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
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isVerifying = false);
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
