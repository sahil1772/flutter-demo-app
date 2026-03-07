import 'package:flutter/material.dart';
import 'dart:io';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  File? _selectedFile;
  bool _isUploading = false;

  Future<void> _pickDocument() async {
    final result = await _showFilePicker();
    setState(() {
      _selectedFile = File(result!.path);
    });
    _uploadFile(_selectedFile!);
  }

  Future<FilePickerResult?> _showFilePicker() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return null;
  }

  Future<void> _uploadFile(File file) async {
    setState(() => _isUploading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Document')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedFile != null)
              Text('Selected: ${_selectedFile!.path}'),
            if (_isUploading)
              const CircularProgressIndicator(),
            ElevatedButton(
              onPressed: _isUploading ? null : _pickDocument,
              child: const Text('Select Document'),
            ),
          ],
        ),
      ),
    );
  }
}

class FilePickerResult {
  final String path;
  FilePickerResult(this.path);
}
