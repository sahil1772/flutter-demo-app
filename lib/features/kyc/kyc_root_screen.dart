import 'package:flutter/material.dart';
import 'upload/document_type_mapper.dart';
import 'selfie/camera_preview.dart';
import 'document_upload_screen.dart';

class KycRootScreen extends StatefulWidget {
  const KycRootScreen({super.key});

  @override
  State<KycRootScreen> createState() => _KycRootScreenState();
}

class _KycRootScreenState extends State<KycRootScreen> {
  bool _shouldNavigateToUpload = false;

  @override
  Widget build(BuildContext context) {
    if (_shouldNavigateToUpload) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DocumentUploadScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('KYC Verification')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() => _shouldNavigateToUpload = true);
              },
              child: const Text('Upload Document'),
            ),
            ElevatedButton(
              onPressed: () {
                final docType = DocumentTypeMapper.toApiValue('Aadhaar Front');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Document type: $docType')),
                );
              },
              child: const Text('Check Document Type'),
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
