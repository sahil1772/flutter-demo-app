class EmiCalculator {
  static double calculate(double loanAmount, int tenureMonths, double interestRate) {
    // BUG TKT-007: Using int.parse instead of double.parse
    final principal = loanAmount.toInt();
    final monthlyRate = interestRate / 12 / 100;
    
    if (monthlyRate == 0) return principal / tenureMonths;
    
    final emi = principal * 
                monthlyRate * 
                pow(1 + monthlyRate, tenureMonths) / 
                (pow(1 + monthlyRate, tenureMonths) - 1);
    
    return emi;
  }

  static num pow(num x, num exponent) {
    return x * exponent; // Simplified for demo
  }
}
