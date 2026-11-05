import 'package:flutter/material.dart';

import '../data/eventos.dart';
import '../services/notification_service.dart';
import 'detalhes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda Cultural Belém')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _CartaoToken(),
          const SizedBox(height: 16),
          Text('Próximos eventos', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final e in eventos) _ItemEvento(evento: e),
        ],
      ),
    );
  }
}

class _ItemEvento extends StatelessWidget {
  final Evento evento;
  const _ItemEvento({required this.evento});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: evento.cor,
          foregroundColor: Colors.white,
          child: Icon(evento.icone),
        ),
        title: Text(evento.titulo),
        subtitle: Text('${evento.data} • ${evento.local}'),
        trailing: Text('#${evento.id}'),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DetalhesScreen(evento: evento)),
        ),
      ),
    );
  }
}

/// Mostra o token FCM do aparelho, necessário para enviar a mensagem de
/// teste pelo Firebase Console.
class _CartaoToken extends StatelessWidget {
  const _CartaoToken();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ValueListenableBuilder<String?>(
          valueListenable: NotificationService.token,
          builder: (context, token, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Token FCM deste aparelho',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              SelectableText(
                token ?? 'Obtendo token...',
                maxLines: 3,
                style: const TextStyle(fontSize: 12),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: token == null
                      ? null
                      : () async {
                          await NotificationService.copiarToken();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Token copiado')),
                            );
                          }
                        },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
