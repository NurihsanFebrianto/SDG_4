import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

// ✅ Import global navigator
import 'services/navigation_service.dart';

// ✅ Import Notification Service
import 'services/notification_service.dart';
import 'services/local_notification_helper.dart';

// ✅ Semua provider
import 'providers/user_provider.dart';
import 'providers/modul_provider.dart';
import 'providers/catatan_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/friends_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/auth_provider.dart' as app_auth;

// ✅ Screens
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

// ✅ Handler untuk notifikasi background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("✅ Background FCM: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ✅ INIT local notifikasi
  await LocalNotificationHelper.init();

  // ✅ FCM background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Aplikasi Materi Kurikulum',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const RootPage(),
      ),
    );
  }
}

/// ✅ Pisahkan RootPage supaya initFCM berjalan setelah MaterialApp dibuat
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    NotificationService.init(); // ✅ jalankan FCM listener
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasData) return const HomeScreen();
        return const LoginScreen();
      },
    );
  }
}
