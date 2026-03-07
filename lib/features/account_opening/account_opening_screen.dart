import 'package:flutter/material.dart';
import 'employment/employment_details_screen.dart';
import 'pan/pan_entry_form.dart';
import 'pan/pan_verification_service.dart';
import 'otp/otp_screen.dart';

class AccountOpeningScreen extends StatefulWidget {
  const AccountOpeningScreen({super.key});

  @override
  State<AccountOpeningScreen> createState() => _AccountOpeningScreenState();
}

class _AccountOpeningScreenState extends State<AccountOpeningScreen> {
  final _panController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isVerifying = false;
  String? _verificationResult;

  Future<void> _verifyPan() async {
    setState(() => _isVerifying = true);

    final service = PanVerificationService();
    final result = await service.verifyPan(_panController.text);

    setState(() {
      _isVerifying = false;
      _verificationResult = result != null ? 'Verified: ${result['name']}' : 'Verification failed';
    });
  }

  @override
  void dispose() {
    _panController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Opening')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _panController,
              decoration: const InputDecoration(labelText: 'PAN Number'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 20),
            if (_isVerifying) const Center(child: CircularProgressIndicator()),
            if (_verificationResult != null)
              Text(_verificationResult!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isVerifying ? null : _verifyPan,
              child: const Text('Verify PAN'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PanEntryForm()),
              ),
              child: const Text('Enter PAN Details'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmploymentDetailsScreen()),
              ),
              child: const Text('Employment Details'),
            ),
          ],
        ),
      ),
    );
  }
}
