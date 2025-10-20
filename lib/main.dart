import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import semua provider yang dipakai
import 'providers/user_provider.dart';
import 'providers/modul_provider.dart';
import 'providers/catatan_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/friends_provider.dart';

// Import service dan screen
import 'services/auth_preferens.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aplikasi Materi Kurikulum',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: FutureBuilder<bool>(
          future: AuthPreferens().isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else {
              return snapshot.data == true
                  ? const HomeScreen()
                  : const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
