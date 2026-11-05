import 'package:flutter/material.dart';

import '../data/eventos.dart';

class DetalhesScreen extends StatelessWidget {
  final Evento evento;

  /// Indica que a tela foi aberta pelo toque em uma notificação (Desafio 3).
  final bool viaNotificacao;

  const DetalhesScreen({
    super.key,
    required this.evento,
    this.viaNotificacao = false,
  });

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(evento.categoria),
        backgroundColor: evento.cor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Container(
            height: 160,
            color: evento.cor,
            alignment: Alignment.center,
            child: Icon(evento.icone, size: 96, color: Colors.white70),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viaNotificacao)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Chip(
                      avatar: Icon(Icons.notifications_active, size: 18),
                      label: Text('Aberto pela notificação'),
                    ),
                  ),
                Text(evento.titulo, style: texto.headlineSmall),
                const SizedBox(height: 16),
                _Info(icone: Icons.calendar_today, texto: evento.data),
                _Info(icone: Icons.schedule, texto: evento.horario),
                _Info(icone: Icons.place, texto: evento.local),
                _Info(icone: Icons.confirmation_number, texto: evento.preco),
                const Divider(height: 32),
                Text(evento.descricao, style: texto.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final IconData icone;
  final String texto;
  const _Info({required this.icone, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icone, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }
}
