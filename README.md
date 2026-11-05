# Agenda Cultural Belém

Aplicativo mobile em Flutter que reúne a programação cultural de Belém do Pará — shows, festivais, exposições, cinema e teatro — e usa notificações push (Firebase Cloud Messaging) para avisar o público sobre novidades da agenda.

Projeto da disciplina de Programação para Dispositivos Móveis (CESUPA), desenvolvido como atividade prática sobre notificações push.

## Sobre o app

- **Finalidade:** divulgar eventos culturais da cidade e lembrar o usuário do que está por vir.
- **Público-alvo:** moradores e turistas que querem acompanhar a agenda cultural de Belém.
- **Telas:**
  - **Início:** lista de eventos e o token FCM do aparelho.
  - **Detalhes:** data, horário, local, preço e descrição do evento.
- **Dados:** os cinco eventos ficam definidos no código, em `lib/data/eventos.dart`. O app não tem login nem banco de dados.

## Notificações

O app trata três tipos de notificação, todos enviados manualmente pelo Firebase Console:

| Tipo | Exemplo de uso | Comportamento |
|---|---|---|
| Simples | Aviso de que a programação da semana foi atualizada | Aparece no Android com o app em segundo plano |
| Com imagem | Destaque de um evento com sua imagem | A imagem aparece na notificação expandida, com o app em segundo plano ou aberto |
| Com navegação | Lembrete de um evento específico | Ao tocar, abre a tela de detalhes do evento indicado |

### Navegação a partir da notificação

A mensagem carrega o dado personalizado `evento_id`, que identifica o evento (valores de `1` a `5`). O app lê esse dado e abre a tela de detalhes correspondente em qualquer um destes estados:

- **Segundo plano:** `FirebaseMessaging.onMessageOpenedApp`
- **App fechado:** `FirebaseMessaging.getInitialMessage()`
- **Primeiro plano:** notificação local com o dado no `payload`, tratada em `onDidReceiveNotificationResponse`

### Imagem com o app aberto

Com o app em segundo plano, o próprio Android exibe a imagem. Com o app aberto, o Android não mostra a notificação sozinho, então o app baixa a imagem e a exibe no estilo *BigPicture* com o `flutter_local_notifications`.

## Tecnologias

- Flutter e Dart
- `firebase_core` e `firebase_messaging`
- `flutter_local_notifications`
- Plano gratuito Spark do Firebase

## Estrutura do projeto

```
lib/
  main.dart                          # inicialização do Firebase e das notificações
  data/eventos.dart                  # modelo e lista de eventos
  services/notification_service.dart # permissões, canal, primeiro plano e navegação
  screens/home_screen.dart           # lista de eventos e token FCM
  screens/detalhes_screen.dart       # detalhes do evento
```

## Como executar

Requisitos: Flutter instalado e um aparelho ou emulador **Android com Google Play**.

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com) e registre um app Android com o pacote `br.cesupa.agenda_cultural`.
2. Baixe o `google-services.json` e coloque-o em `android/app/`. Esse arquivo contém as chaves do projeto e não é versionado.
3. Instale as dependências e rode o app:
   ```
   flutter pub get
   flutter run
   ```
4. Aceite a permissão de notificações. O token FCM aparece na tela inicial.
5. No Console, em **Messaging**, crie uma notificação e use **Enviar mensagem de teste** com o token copiado. Para a notificação com navegação, adicione o dado personalizado `evento_id` com o id do evento.
