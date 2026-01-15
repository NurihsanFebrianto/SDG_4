import 'package:aplikasi_materi_kurikulum/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'package:aplikasi_materi_kurikulum/screens/profile_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/edit_profile_screen.dart';
import 'package:aplikasi_materi_kurikulum/providers/profile_provider.dart';
import 'package:aplikasi_materi_kurikulum/models/profile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('INTEGRATION TEST – REGISTER & PROFILE FLOW (10 TEST)', () {
    /// ==============================
    /// 🔐 REGISTER
    /// ==============================

    /// 1. Field kosong
    testWidgets('1. Register gagal jika field kosong', (tester) async {
      await tester.pumpWidget(const TestApp());
      await tester.pumpAndSettle();
      _setScreenSize(tester);

      final btn = find.byKey(const ValueKey('signup_button'));
      await tester.ensureVisible(btn);
      await tester.tap(btn);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    /// 2. Password tidak sama
    testWidgets('2. Password tidak sama', (tester) async {
      await tester.pumpWidget(const TestApp());
      await tester.pumpAndSettle();
      _setScreenSize(tester);

      await tester.enterText(
          find.byKey(const ValueKey('full_name_field')), 'Budi');
      await tester.enterText(
          find.byKey(const ValueKey('email_field')), 'budi@gmail.com');
      await tester.enterText(
          find.byKey(const ValueKey('password_field')), '123456');
      await tester.enterText(
          find.byKey(const ValueKey('confirm_password_field')), '000000');

      final btn = find.byKey(const ValueKey('signup_button'));
      await tester.ensureVisible(btn);
      await tester.tap(btn);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    /// 3. Password < 6
    testWidgets('3. Password kurang dari 6', (tester) async {
      await tester.pumpWidget(const TestApp());
      await tester.pumpAndSettle();
      _setScreenSize(tester);

      await tester.enterText(
          find.byKey(const ValueKey('full_name_field')), 'Ani');
      await tester.enterText(
          find.byKey(const ValueKey('email_field')), 'ani@gmail.com');
      await tester.enterText(
          find.byKey(const ValueKey('password_field')), '123');
      await tester.enterText(
          find.byKey(const ValueKey('confirm_password_field')), '123');

      final btn = find.byKey(const ValueKey('signup_button'));
      await tester.ensureVisible(btn);
      await tester.tap(btn);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    /// 4. Email kosong
    testWidgets('4. Email kosong', (tester) async {
      await tester.pumpWidget(const TestApp());
      await tester.pumpAndSettle();
      _setScreenSize(tester);

      await tester.enterText(
          find.byKey(const ValueKey('full_name_field')), 'Andi');
      await tester.enterText(
          find.byKey(const ValueKey('password_field')), '123456');
      await tester.enterText(
          find.byKey(const ValueKey('confirm_password_field')), '123456');

      final btn = find.byKey(const ValueKey('signup_button'));
      await tester.ensureVisible(btn);
      await tester.tap(btn);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    /// 5. Nama kosong
    testWidgets('5. Nama kosong', (tester) async {
      await tester.pumpWidget(const TestApp());
      await tester.pumpAndSettle();
      _setScreenSize(tester);

      await tester.enterText(
          find.byKey(const ValueKey('email_field')), 'test@gmail.com');
      await tester.enterText(
          find.byKey(const ValueKey('password_field')), '123456');
      await tester.enterText(
          find.byKey(const ValueKey('confirm_password_field')), '123456');

      final btn = find.byKey(const ValueKey('signup_button'));
      await tester.ensureVisible(btn);
      await tester.tap(btn);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    /// ==============================
    /// 👤 PROFILE
    /// ==============================

    /// 6. Profile tampil setelah set user
    testWidgets('6. Profile tampil setelah set user', (tester) async {
      await tester.pumpWidget(const TestApp(withUser: true));
      await tester.pumpAndSettle();

      expect(find.text('Profil Saya'), findsOneWidget);
      expect(find.text('Nurihsan'), findsOneWidget);
      expect(find.text('nur@gmail.com'), findsOneWidget);
    });

    /// 7. Tombol Edit ada
    testWidgets('7. Tombol Edit muncul di Profile', (tester) async {
      await tester.pumpWidget(const TestApp(withUser: true));
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsOneWidget);
    });

    /// 8. Klik Edit pindah ke EditProfileScreen
    testWidgets('8. Klik Edit pindah ke EditProfileScreen', (tester) async {
      await tester.pumpWidget(const TestApp(withUser: true));
      await tester.pumpAndSettle();

      final editBtn = find.text('Edit');
      await tester.ensureVisible(editBtn);
      await tester.tap(editBtn);
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileScreen), findsOneWidget);
    });

    /// ==============================
    /// 👤 Edit PROFILE
    /// ==============================

    /// 9. Field Nama ada di Edit Profile
    testWidgets('9. Field Nama ada di Edit Profile', (tester) async {
      await tester.pumpWidget(const TestApp(withUser: true));
      await tester.pumpAndSettle();

      final editBtn = find.text('Edit');
      await tester.ensureVisible(editBtn);
      await tester.tap(editBtn);
      await tester.pumpAndSettle();

      expect(find.text('Nama Lengkap'), findsOneWidget);
    });

    /// 10. Email disabled di Edit Profile
    testWidgets('10. Email field disabled di Edit Profile', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) {
            final p = ProfileProvider(enableFirebase: false);
            p.setUser(mockUser());
            return p;
          },
          child: const MaterialApp(home: EditProfileScreen()),
        ),
      );

      await tester.pumpAndSettle();

      final emailField = tester.widget<TextFormField>(
        find.byKey(const ValueKey('email_field')),
      );

      expect(emailField.enabled, false);
    });
  });
}

/// ===============================
/// APP WRAPPER
/// ===============================
class TestApp extends StatelessWidget {
  final bool withUser;

  const TestApp({super.key, this.withUser = false});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final p = ProfileProvider(enableFirebase: false);
            if (withUser) {
              p.setUser(mockUser());
            }
            return p;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: withUser ? const ProfileScreen() : const SignupScreen(),
      ),
    );
  }
}

/// ===============================
/// FIX SCREEN SIZE
/// ===============================
void _setScreenSize(WidgetTester tester) {
  tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
  tester.binding.window.devicePixelRatioTestValue = 1.0;

  addTearDown(() {
    tester.binding.window.clearPhysicalSizeTestValue();
    tester.binding.window.clearDevicePixelRatioTestValue();
  });
}

/// ===============================
/// MOCK USER
/// ===============================
ProfileModel mockUser() {
  return ProfileModel(
    uid: 'test',
    name: 'Nurihsan',
    email: 'nur@gmail.com',
    phone: '08123',
    jenisKelamin: 'Laki-laki',
    alamat: 'Medan',
    asalSekolah: 'SMK',
    imagePath: '',
  );
}
