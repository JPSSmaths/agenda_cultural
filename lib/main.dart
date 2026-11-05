import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // No Android a configuração vem do android/app/google-services.json.
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  await NotificationService.inicializar();

  runApp(const AgendaApp());

  // Depois do primeiro frame o Navigator já existe e podemos navegar
  // caso o app tenha sido iniciado pelo toque na notificação.
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => NotificationService.tratarAberturaInicial(),
  );
}

class AgendaApp extends StatelessWidget {
  const AgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Cultural',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE65100)),
      ),
      home: const HomeScreen(),
    );
  }
}
