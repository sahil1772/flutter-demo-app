import 'package:flutter/material.dart';

class CameraPreview extends StatelessWidget {
  const CameraPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take Selfie')),
      body: Center(
        // BUG TKT-006: Missing Expanded wrapper
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: Colors.black,
            child: const Center(
              child: Text('Camera Preview', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
