import 'package:flutter/material.dart';

/// Um evento da agenda cultural. Os dados ficam definidos no código
/// (a atividade não exige banco de dados).
class Evento {
  final String id;
  final String titulo;
  final String categoria;
  final String data;
  final String horario;
  final String local;
  final String preco;
  final String descricao;
  final IconData icone;
  final Color cor;

  const Evento({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.data,
    required this.horario,
    required this.local,
    required this.preco,
    required this.descricao,
    required this.icone,
    required this.cor,
  });
}

const eventos = <Evento>[
  Evento(
    id: '1',
    titulo: 'Noite de Carimbó',
    categoria: 'Música',
    data: '14/11/2026',
    horario: '19h',
    local: 'Estação das Docas',
    preco: 'Gratuito',
    descricao:
        'Grupos tradicionais de carimbó se apresentam na orla da Baía do '
        'Guajará. Roda aberta ao público, com oficina de dança antes do show.',
    icone: Icons.music_note,
    cor: Color(0xFFE65100),
  ),
  Evento(
    id: '2',
    titulo: 'Festival Sabores do Ver-o-Peso',
    categoria: 'Gastronomia',
    data: '21/11/2026',
    horario: '11h às 22h',
    local: 'Complexo do Ver-o-Peso',
    preco: 'Entrada gratuita',
    descricao:
        'Chefs paraenses preparam pratos com ingredientes regionais: '
        'tacacá, maniçoba, pato no tucupi e sobremesas de cupuaçu e bacuri.',
    icone: Icons.restaurant,
    cor: Color(0xFF2E7D32),
  ),
  Evento(
    id: '3',
    titulo: 'Exposição Amazônia Viva',
    categoria: 'Arte',
    data: '28/11/2026 a 15/12/2026',
    horario: '9h às 17h',
    local: 'Museu Paraense Emílio Goeldi',
    preco: 'R\$ 6,00 (meia R\$ 3,00)',
    descricao:
        'Fotografias e instalações sobre a fauna e a flora amazônicas. '
        'Visitas guiadas aos sábados às 10h, com inscrição na bilheteria.',
    icone: Icons.photo_camera,
    cor: Color(0xFF00838F),
  ),
  Evento(
    id: '4',
    titulo: 'Cinema no Mangal',
    categoria: 'Cinema',
    data: '05/12/2026',
    horario: '18h30',
    local: 'Mangal das Garças',
    preco: 'Gratuito',
    descricao:
        'Sessão ao ar livre de curtas-metragens produzidos no Pará. '
        'Leve sua canga ou cadeira de praia.',
    icone: Icons.movie,
    cor: Color(0xFF6A1B9A),
  ),
  Evento(
    id: '5',
    titulo: 'Teatro: Auto do Círio',
    categoria: 'Teatro',
    data: '12/12/2026',
    horario: '20h',
    local: 'Theatro da Paz',
    preco: 'R\$ 40,00 (meia R\$ 20,00)',
    descricao:
        'Espetáculo que mistura teatro, música e dança para contar histórias '
        'da maior festa religiosa da Amazônia.',
    icone: Icons.theater_comedy,
    cor: Color(0xFFC62828),
  ),
];

Evento? buscarEvento(String? id) {
  for (final e in eventos) {
    if (e.id == id) return e;
  }
  return null;
}
