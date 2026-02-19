class EmploymentTypeMapper {
  static const Map<String, String> _typeMap = {
    'Salaried': 'SE',  // BUG TKT-001: Should be 'SA'
    'Self-Employed': 'SE',
    'Business': 'BUS',
  };

  static String toApiValue(String displayValue) {
    return _typeMap[displayValue] ?? 'UNKNOWN';
  }
}
