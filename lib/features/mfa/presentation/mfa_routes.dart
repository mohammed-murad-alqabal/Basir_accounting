import 'package:basir_accounting_system/features/mfa/presentation/screens/mfa_challenge_screen.dart';
import 'package:basir_accounting_system/features/mfa/presentation/screens/mfa_gate_screen.dart';
import 'package:basir_accounting_system/features/mfa/presentation/screens/mfa_security_center_screen.dart';
import 'package:basir_accounting_system/features/mfa/presentation/screens/phone_otp_screen.dart';
import 'package:basir_accounting_system/features/mfa/presentation/screens/phone_verification_screen.dart';
import 'package:flutter/material.dart';

/// MFA Routes Configuration
class MfaRoutes {
  static const String mfaGate = '/mfa-gate';
  static const String mfaSecurityCenter = '/mfa-security';
  static const String mfaChallenge = '/mfa-challenge';
  static const String phoneVerification = '/phone-verify';
  static const String phoneOtp = '/phone-otp';

  /// Register MFA routes in app router
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mfaGate:
        return MaterialPageRoute(
          builder: (_) => const MfaGateScreen(),
          settings: settings,
        );

      case mfaSecurityCenter:
        return MaterialPageRoute(
          builder: (_) => const MfaSecurityCenterScreen(),
          settings: settings,
        );

      case mfaChallenge:
        final args = settings.arguments as Map<String, dynamic>?;
        final afterRoute = args?['after'] as String?;
        return MaterialPageRoute(
          builder: (_) => MfaChallengeScreen(
            afterRoute: afterRoute,
          ),
          settings: settings,
        );

      case phoneVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        final afterRoute = args?['after'] as String?;
        return MaterialPageRoute(
          builder: (_) => PhoneVerificationScreen(
            afterRoute: afterRoute,
          ),
          settings: settings,
        );

      case phoneOtp:
        final args = settings.arguments as Map<String, dynamic>?;
        final phone = args?['phone'] as String? ?? '';
        final afterRoute = args?['after'] as String?;
        return MaterialPageRoute(
          builder: (_) => PhoneOtpScreen(
            phone: phone,
            afterRoute: afterRoute,
          ),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }

  /// Add MFA routes to existing routes map
  static Map<String, WidgetBuilder> addToRoutes(
    Map<String, WidgetBuilder> existingRoutes,
  ) {
    final mfaRoutes = <String, WidgetBuilder>{
      mfaGate: (_) => const MfaGateScreen(),
      mfaSecurityCenter: (_) => const MfaSecurityCenterScreen(),
      mfaChallenge: (BuildContext context) {
        final settings = ModalRoute.of(context)?.settings;
        final args = settings?.arguments as Map<String, dynamic>?;
        final afterRoute = args?['after'] as String?;
        return MfaChallengeScreen(afterRoute: afterRoute);
      },
      phoneVerification: (BuildContext context) {
        final settings = ModalRoute.of(context)?.settings;
        final args = settings?.arguments as Map<String, dynamic>?;
        final afterRoute = args?['after'] as String?;
        return PhoneVerificationScreen(afterRoute: afterRoute);
      },
      phoneOtp: (BuildContext context) {
        final settings = ModalRoute.of(context)?.settings;
        final args = settings?.arguments as Map<String, dynamic>?;
        final phone = args?['phone'] as String? ?? '';
        final afterRoute = args?['after'] as String?;
        return PhoneOtpScreen(
          phone: phone,
          afterRoute: afterRoute,
        );
      },
    };

    return {...existingRoutes, ...mfaRoutes};
  }

  /// Get list of all MFA routes
  static List<String> get allRoutes => [
        mfaGate,
        mfaSecurityCenter,
        mfaChallenge,
        phoneVerification,
        phoneOtp,
      ];
}
