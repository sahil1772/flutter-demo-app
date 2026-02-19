import 'package:flutter/material.dart';
import 'upload/document_type_mapper.dart';
import 'selfie/camera_preview.dart';

class KycRootScreen extends StatelessWidget {
  const KycRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KYC Verification')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Document upload logic
                final docType = DocumentTypeMapper.toApiValue('Aadhaar Front');
                print('Document type: $docType');
              },
              child: const Text('Upload Document'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CameraPreview()),
              ),
              child: const Text('Take Selfie'),
            ),
          ],
        ),
      ),
    );
  }
}
