import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

//  Import global navigator
import 'navigation_service.dart';

// Helper notifikasi lokal
import 'local_notification_helper.dart';

// Halaman detail pengumuman
import '../screens/detail_pengumuman_screen_by_id.dart';

class NotificationService {
  static Future<void> init() async {
    final messaging = FirebaseMessaging.instance;

    // Minta izin notifikasi (iOS & Android 13+)
    await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );

    //  Subscribe ke topik umum
    await messaging.subscribeToTopic("all");
    print(" Subscribed to topic: all");

    //  Ambil token FCM
    String? token = await messaging.getToken();
    print(" FCM Token: $token");

    //  FUNGSI HANDLE KLIK NOTIF
    Future<void> _handleClick(Map<String, dynamic> data) async {
      print(" HANDLE CLICK DIPANGGIL");
      print(" DATA: $data");

      final String? id = data["id"];
      if (id == null || id.isEmpty) {
        print("❌ ID tidak ada, tidak bisa buka detail!");
        return;
      }

      //  Tunggu sampai navigator siap
      int retry = 0;
      while (navigatorKey.currentState == null && retry < 10) {
        print("⏳ Menunggu navigator siap...");
        await Future.delayed(const Duration(milliseconds: 300));
        retry++;
      }

      if (navigatorKey.currentState == null) {
        print("❌ Navigator masih null setelah menunggu!");
        return;
      }

      print(" Navigasi ke DetailPengumumanScreenById($id)");
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => DetailPengumumanScreenById(id: id),
        ),
      );
    }

    //  NOTIFIKASI SAAT APP AKTIF (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(" FOREGROUND NOTIF");
      print(" DATA: ${message.data}");

      if (message.notification != null) {
        LocalNotificationHelper.show(
          message.notification!.title ?? "Notifikasi",
          message.notification!.body ?? "",
          payload: message.data, // 👈 kirim data ke notifikasi
        );
      }
    });

    //  SAAT NOTIF DIKLIK DARI BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(" Dibuka dari background");
      print(" DATA: ${message.data}");
      _handleClick(message.data);
    });

    //  SAAT APP DIBUKA DARI TERMINATED (mati total)
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print(" Dibuka dari terminated");
      print(" DATA: ${initialMessage.data}");
      _handleClick(initialMessage.data);
    }
  }
}
