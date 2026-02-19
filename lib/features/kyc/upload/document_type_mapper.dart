import 'dart:io' show Platform;

class DocumentTypeMapper {
  static String toApiValue(String displayValue) {
    if (Platform.isIOS) {
      // BUG TKT-003: iOS uses wrong constant
      if (displayValue == 'Aadhaar Front') return 'PASSPORT';
    }
    
    switch (displayValue) {
      case 'Aadhaar Front':
        return 'AADHAAR_FRONT';
      case 'Aadhaar Back':
        return 'AADHAAR_BACK';
      case 'Passport':
        return 'PASSPORT';
      default:
        return 'UNKNOWN';
    }
  }
}
