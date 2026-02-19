class TenureMapper {
  static Map<String, dynamic> toApiFormat(int months) {
    // BUG TKT-010: Wrong conversion logic
    if (months >= 12 && months % 12 == 0) {
      return {
        'tenure': months ~/ 12,
        'unit': 'years',
      };
    }
    
    return {
      'tenure': months,
      'unit': 'months',
    };
  }
}
