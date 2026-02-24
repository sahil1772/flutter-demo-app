import 'package:flutter/material.dart';
import '../../features/account_opening/account_opening_screen.dart';
import '../../features/kyc/kyc_root_screen.dart';
import '../../features/loan/loan_root_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    '/kyc': (context) => const KycRootScreen(),
    '/loan': (context) => const LoanRootScreen(),
    // BUG TKT-009: Missing route for video_kyc_screen
  };
}
