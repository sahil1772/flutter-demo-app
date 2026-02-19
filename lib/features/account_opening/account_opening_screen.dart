import 'package:flutter/material.dart';
import 'employment/employment_details_screen.dart';
import 'pan/pan_entry_form.dart';
import 'otp/otp_screen.dart';

class AccountOpeningScreen extends StatelessWidget {
  const AccountOpeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Opening')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PanEntryForm()),
              ),
              child: const Text('Enter PAN'),
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
