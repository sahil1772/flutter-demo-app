import 'package:flutter/material.dart';

class LoanAmountForm extends StatefulWidget {
  const LoanAmountForm({super.key});

  @override
  State<LoanAmountForm> createState() => _LoanAmountFormState();
}

class _LoanAmountFormState extends State<LoanAmountForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter amount';
    }
    // BUG TKT-004: Missing range validation
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loan Amount')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                validator: _validateAmount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Loan Amount'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('Amount: ${_amountController.text}');
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
