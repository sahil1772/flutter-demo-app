import 'package:flutter/material.dart';
import 'amount/loan_amount_form.dart';
import 'emi/emi_calculator.dart';
import 'tenure/tenure_mapper.dart';

class LoanRootScreen extends StatelessWidget {
  const LoanRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loan Application')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoanAmountForm()),
              ),
              child: const Text('Enter Loan Amount'),
            ),
            ElevatedButton(
              onPressed: () {
                final emi = EmiCalculator.calculate(250000.50, 12, 10.5);
                print('EMI: $emi');
              },
              child: const Text('Calculate EMI'),
            ),
          ],
        ),
      ),
    );
  }
}
