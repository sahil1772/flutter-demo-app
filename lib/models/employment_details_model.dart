class EmploymentDetailsModel {
  final String employmentType;
  final String companyName;
  final double monthlyIncome;

  EmploymentDetailsModel({
    required this.employmentType,
    required this.companyName,
    required this.monthlyIncome,
  });

  Map<String, dynamic> toJson() {
    return {
      'employment_type': employmentType,
      'company_name': companyName,
      'monthly_income': monthlyIncome,
    };
  }
}
