import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/services/f_auth.dart';
import 'core/services/f_firestore.dart';
import 'core/theme/t_app_theme.dart';
import 'features/auth/s_auth_gate.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authService = AuthService();
  await authService.tryRestoreSession();
  final firestoreService = FirestoreService();
  await AppTheme.initTheme();

  runApp(
    MyApp(
      authService: authService,
      firestoreService: firestoreService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final FirestoreService firestoreService;

  const MyApp({
    super.key,
    required this.authService,
    required this.firestoreService,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'egy_tracker',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          home: AuthGate(
            authService: authService,
            firestoreService: firestoreService,
          ),
        );
      },
    );
  }
}
