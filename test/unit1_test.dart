import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:aplikasi_materi_kurikulum/screens/signup_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/profile_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/edit_profile_screen.dart';
import 'package:aplikasi_materi_kurikulum/providers/profile_provider.dart';
import 'package:aplikasi_materi_kurikulum/providers/user_provider.dart';
import 'package:aplikasi_materi_kurikulum/models/profile.dart';

void main() {
  /// ==============================
  /// 🔐 REGISTER
  /// ==============================

  Widget wrapSignup() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MaterialApp(home: SignupScreen()),
    );
  }

  testWidgets(' 1️. Register gagal jika field kosong', (tester) async {
    await tester.pumpWidget(wrapSignup());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('signup_button')));
    await tester.tap(find.byKey(const ValueKey('signup_button')));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets(' 2️. Password tidak sama', (tester) async {
    await tester.pumpWidget(wrapSignup());
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const ValueKey('full_name_field')), 'Budi');
    await tester.enterText(
        find.byKey(const ValueKey('email_field')), 'budi@gmail.com');
    await tester.enterText(
        find.byKey(const ValueKey('password_field')), '123456');
    await tester.enterText(
        find.byKey(const ValueKey('confirm_password_field')), '000000');

    await tester.ensureVisible(find.byKey(const ValueKey('signup_button')));
    await tester.tap(find.byKey(const ValueKey('signup_button')));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets(' 3️. Password kurang dari 6', (tester) async {
    await tester.pumpWidget(wrapSignup());
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const ValueKey('full_name_field')), 'Ani');
    await tester.enterText(
        find.byKey(const ValueKey('email_field')), 'ani@gmail.com');
    await tester.enterText(find.byKey(const ValueKey('password_field')), '123');
    await tester.enterText(
        find.byKey(const ValueKey('confirm_password_field')), '123');

    await tester.ensureVisible(find.byKey(const ValueKey('signup_button')));
    await tester.tap(find.byKey(const ValueKey('signup_button')));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  /// ==============================
  /// 👤 PROFILE
  /// ==============================

  Widget wrapProfile(Widget child) {
    final provider = ProfileProvider(enableFirebase: false);
    provider.setUser(mockUser());

    return ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(home: child),
    );
  }

  testWidgets(' 4️. Judul profile tampil', (tester) async {
    await tester.pumpWidget(wrapProfile(const ProfileScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Profil Saya'), findsOneWidget);
  });

  testWidgets(' 5️. Nama tampil', (tester) async {
    await tester.pumpWidget(wrapProfile(const ProfileScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Nurihsan'), findsOneWidget);
  });

  testWidgets(' 6️. Email tampil', (tester) async {
    await tester.pumpWidget(wrapProfile(const ProfileScreen()));
    await tester.pumpAndSettle();
    expect(find.text('nur@gmail.com'), findsOneWidget);
  });

  testWidgets(' 7️. Tombol Edit ada', (tester) async {
    await tester.pumpWidget(wrapProfile(const ProfileScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Edit'), findsOneWidget);
  });

  testWidgets(' 8️. Klik Edit pindah halaman', (tester) async {
    await tester.pumpWidget(wrapProfile(const ProfileScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.byType(EditProfileScreen), findsOneWidget);
  });

  testWidgets(' 9️. Field Nama ada', (tester) async {
    await tester.pumpWidget(wrapProfile(const EditProfileScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Nama Lengkap'), findsOneWidget);
  });

  testWidgets(' 10️. Email disabled', (tester) async {
    await tester.pumpWidget(wrapProfile(const EditProfileScreen()));
    await tester.pump();

    final emailField = tester.widget<TextFormField>(
      find.byKey(const ValueKey('email_field')),
    );

    expect(emailField.enabled, false);
  });

  /// ==============================
  /// 🧪 PROVIDER
  /// ==============================

  test(' 11️. setUser bekerja', () {
    final p = ProfileProvider(enableFirebase: false);
    p.setUser(mockUser());
    expect(p.user?.name, 'Nurihsan');
  });

  test(' 12️. clear bekerja', () {
    final p = ProfileProvider(enableFirebase: false);
    p.setUser(mockUser());
    p.clear();
    expect(p.user, null);
  });

  test(' 13️. enableFirebase false', () {
    final p = ProfileProvider(enableFirebase: false);
    expect(p.enableFirebase, false);
  });

  test(' 14️. isLoading default false', () {
    final p = ProfileProvider(enableFirebase: false);
    expect(p.isLoading, false);
  });
}

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
