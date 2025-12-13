import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import 'services/navigation_service.dart';
import 'services/notification_service.dart';
import 'services/local_notification_helper.dart';

import 'providers/user_provider.dart';
import 'providers/modul_provider.dart';
import 'providers/catatan_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/friends_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/auth_provider.dart' as app_auth;
import 'providers/accessibility_provider.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

/// ✅ Handler background FCM
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("✅ Background FCM: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await LocalNotificationHelper.init();
  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  runApp(const AppKurikulum());
}

class AppKurikulum extends StatelessWidget {
  const AppKurikulum({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ModulProvider()),
        ChangeNotifierProvider(create: (_) => CatatanProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => FriendsProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
        ChangeNotifierProvider(create: (_) => AccessibilityProvider()),
      ],
      child: Consumer<AccessibilityProvider>(
        builder: (context, accessibilityProvider, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Aplikasi Materi Kurikulum',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            // ✅ Apply global text scale factor
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: accessibilityProvider.textScaleFactor,
                ),
                child: Stack(
                  children: [
                    child!,
                    // ✅ Brightness overlay
                    if (accessibilityProvider.appBrightness != 0.5)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            color: accessibilityProvider.getBrightnessOverlay(),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
            home: const RootPage(),
          );
        },
      ),
    );
  }
}

/// ✅ ROOTPAGE = TEMPAT SATU-SATUNYA LOAD PROFILE + ACCESSIBILITY
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();

    NotificationService.init();

    /// ✅ LOAD PROFILE + ACCESSIBILITY SETTINGS SEKALI SAAT APP DIBUKA
    Future.microtask(() async {
      // Load accessibility settings first
      await context.read<AccessibilityProvider>().loadSettings();

      // Load user profile if logged in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await context.read<ProfileProvider>().loadUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
