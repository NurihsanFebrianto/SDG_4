import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'navigation_service.dart';
import '../screens/detail_pengumuman_screen_by_id.dart';

class LocalNotificationHelper {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: android);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // 🚀 Ketika user klik notifikasi
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          final String? id = data["id"];
          if (id != null && id.isNotEmpty) {
            print("🧭 Navigasi ke DetailPengumumanScreenById, id: $id");
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (_) => DetailPengumumanScreenById(id: id),
              ),
            );
          }
        }
      },
    );
  }

  static Future<void> show(
    String title,
    String body, {
    Map<String, dynamic>? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      "default_channel",
      "Default Notifications",
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      title,
      body,
      platformDetails,
      payload: payload != null ? jsonEncode(payload) : null,
    );
  }
}
