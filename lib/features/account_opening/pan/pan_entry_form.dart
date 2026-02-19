import 'package:flutter/material.dart';

class PanEntryForm extends StatefulWidget {
  const PanEntryForm({super.key});

  @override
  State<PanEntryForm> createState() => _PanEntryFormState();
}

class _PanEntryFormState extends State<PanEntryForm> {
  final panController = TextEditingController();

  void _submit() {
    // BUG TKT-002: Missing null check
    final panValue = panController.text;
    print('PAN submitted: $panValue');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter PAN')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: panController,
              decoration: const InputDecoration(labelText: 'PAN Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
