import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../data/eventos.dart';
import '../screens/detalhes_screen.dart';

/// Chave usada para navegar a partir de fora da árvore de widgets
/// (quando a notificação é tocada).
final navigatorKey = GlobalKey<NavigatorState>();

/// Chamado pelo FCM quando chega uma mensagem com o app em segundo plano
/// ou fechado. Mensagens com o campo "notification" já são exibidas pelo
/// próprio Android, então aqui só registramos o recebimento.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  debugPrint('Mensagem em segundo plano: ${message.messageId}');
}

class NotificationService {
  NotificationService._();

  static final _messaging = FirebaseMessaging.instance;
  static final _local = FlutterLocalNotificationsPlugin();

  /// Mesmo id declarado no AndroidManifest (default_notification_channel_id).
  static const _canal = AndroidNotificationChannel(
    'agenda_eventos',
    'Eventos da agenda',
    description: 'Avisos sobre novos eventos e destaques da agenda cultural',
    importance: Importance.high,
  );

  /// Token do aparelho, usado no Firebase Console em "Enviar mensagem de teste".
  static final token = ValueNotifier<String?>(null);

  static Future<void> inicializar() async {
    // Android 13+ pede a permissão POST_NOTIFICATIONS ao usuário.
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_canal);

    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      // Toque em notificação exibida com o app aberto (primeiro plano).
      onDidReceiveNotificationResponse: (resposta) {
        final payload = resposta.payload;
        if (payload == null) return;
        _abrirPelaMensagem(Map<String, dynamic>.from(jsonDecode(payload)));
      },
    );

    // getToken() continua sendo o token aceito pelo "Enviar mensagem de
    // teste" do Firebase Console, por isso é mantido apesar de deprecado.
    // ignore: deprecated_member_use
    token.value = await _messaging.getToken();
    debugPrint('FCM token: ${token.value}');
    // ignore: deprecated_member_use
    _messaging.onTokenRefresh.listen((t) => token.value = t);

    // App aberto: o Android não exibe a notificação sozinho, então
    // mostramos manualmente com o flutter_local_notifications.
    FirebaseMessaging.onMessage.listen(_exibirEmPrimeiroPlano);

    // App em segundo plano: usuário tocou na notificação.
    FirebaseMessaging.onMessageOpenedApp.listen(
      (m) => _abrirPelaMensagem(m.data),
    );
  }

  /// Deve ser chamado depois que o Navigator existir. Trata o caso em que o
  /// app estava fechado e foi iniciado pelo toque na notificação.
  static Future<void> tratarAberturaInicial() async {
    final inicial = await _messaging.getInitialMessage();
    if (inicial != null) {
      _abrirPelaMensagem(inicial.data);
      return;
    }
    final detalhes = await _local.getNotificationAppLaunchDetails();
    final payload = detalhes?.notificationResponse?.payload;
    if ((detalhes?.didNotificationLaunchApp ?? false) && payload != null) {
      _abrirPelaMensagem(Map<String, dynamic>.from(jsonDecode(payload)));
    }
  }

  /// Desafio 3: lê o campo "evento_id" dos dados da mensagem e abre a
  /// tela de detalhes do evento correspondente.
  static void _abrirPelaMensagem(Map<String, dynamic> dados) {
    final evento = buscarEvento(dados['evento_id']?.toString());
    if (evento == null) return;
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => DetalhesScreen(evento: evento, viaNotificacao: true),
      ),
    );
  }

  static Future<void> _exibirEmPrimeiroPlano(RemoteMessage message) async {
    final notificacao = message.notification;
    if (notificacao == null) return;

    // Desafio 2 com o app aberto: baixa a imagem e usa o estilo BigPicture.
    StyleInformation? estilo;
    final imagemUrl = notificacao.android?.imageUrl;
    if (imagemUrl != null) {
      final bytes = await _baixarImagem(imagemUrl);
      if (bytes != null) {
        estilo = BigPictureStyleInformation(
          ByteArrayAndroidBitmap(bytes),
          largeIcon: ByteArrayAndroidBitmap(bytes),
          contentTitle: notificacao.title,
          summaryText: notificacao.body,
          hideExpandedLargeIcon: true,
        );
      }
    }

    await _local.show(
      id: notificacao.hashCode,
      title: notificacao.title,
      body: notificacao.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _canal.id,
          _canal.name,
          channelDescription: _canal.description,
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: estilo,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  static Future<Uint8List?> _baixarImagem(String url) async {
    try {
      final cliente = HttpClient();
      final resposta = await (await cliente.getUrl(Uri.parse(url))).close();
      if (resposta.statusCode != 200) return null;
      final bytes = await consolidateHttpClientResponseBytes(resposta);
      cliente.close();
      return bytes;
    } catch (e) {
      debugPrint('Falha ao baixar imagem da notificação: $e');
      return null;
    }
  }

  static Future<void> copiarToken() async {
    final t = token.value;
    if (t != null) await Clipboard.setData(ClipboardData(text: t));
  }
}
