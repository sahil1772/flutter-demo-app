import 'package:flutter/material.dart';
import 'employment_bloc.dart';
import 'employment_type_mapper.dart';

class EmploymentDetailsScreen extends StatefulWidget {
  const EmploymentDetailsScreen({super.key});

  @override
  State<EmploymentDetailsScreen> createState() => _EmploymentDetailsScreenState();
}

class _EmploymentDetailsScreenState extends State<EmploymentDetailsScreen> {
  String? selectedEmploymentType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employment Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedEmploymentType,
              hint: const Text('Select Employment Type'),
              items: ['Salaried', 'Self-Employed', 'Business']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedEmploymentType = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final apiValue = EmploymentTypeMapper.toApiValue(selectedEmploymentType ?? '');
                print('Sending to API: $apiValue');
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
