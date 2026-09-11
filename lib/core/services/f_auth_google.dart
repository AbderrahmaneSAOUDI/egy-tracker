import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/app_config.dart';

/// Helper handling Google Sign-In initialization and lifecycle
class GoogleAuthHelper {
  static const String serverClientId = AppConfig.serverClientId;
  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (kIsWeb || _initialized) return;
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId: serverClientId,
      );
      _initialized = true;
    } catch (e) {
      debugPrint('GoogleSignIn initialize caught error: $e');
    }
  }

  static Future<GoogleSignInAccount?> attemptLightweight() async {
    final attempt = GoogleSignIn.instance.attemptLightweightAuthentication();
    if (attempt != null) {
      return await attempt;
    }
    return null;
  }

  static Future<GoogleSignInAccount> authenticate() async {
    return await GoogleSignIn.instance.authenticate();
  }

  static Future<void> signOut() async {
    if (!kIsWeb) {
      await GoogleSignIn.instance.signOut();
    }
  }
}
