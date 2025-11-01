import 'package:aplikasi_materi_kurikulum/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// ✅ Import semua provider
import 'providers/user_provider.dart';
import 'providers/modul_provider.dart';
import 'providers/catatan_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/friends_provider.dart';
import 'providers/progress_provider.dart'; // ✅ Penting

// ✅ Import service dan screen
import 'services/auth_preferens.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 🔥 Inisialisasi Firebase tanpa firebase_options
  await Firebase.initializeApp();

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
        ChangeNotifierProvider(
            create: (_) => ProgressProvider()), // ✅ sudah didaftarkan
        ChangeNotifierProvider(
            create: (_) => AuthProvider()..loadLoginStatus()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aplikasi Materi Kurikulum',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),

        // ✅ Tambahkan ChangeNotifierProvider di sini untuk memastikan
        // context FutureBuilder juga punya akses ke ProgressProvider
        home: FutureBuilder<bool>(
          future: AuthPreferens().isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else {
              return ChangeNotifierProvider(
                create: (_) => ProgressProvider(),
                child: snapshot.data == true
                    ? const HomeScreen()
                    : const LoginScreen(),
              );
            }
          },
        ),
      ),
    );
  }
}
