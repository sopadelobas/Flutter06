import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agendamento de evento',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AgendamentoEventoTela(),
    );
  }
}

class AgendamentoEventoTela extends StatefulWidget {
  const AgendamentoEventoTela({super.key});

  @override
  State<AgendamentoEventoTela> createState() => _AgendamentoEventoTelaState();
}

enum Visibilidade { public, private, vip }

class _AgendamentoEventoTelaState extends State<AgendamentoEventoTela> {
  static final DateTime _dataPadrao = DateTime.now();
  static const TimeOfDay _horarioPadrao = TimeOfDay(hour: 19, minute: 0);
  static const String _tipoPadrao = 'Aniversário';
  static const double _convidadosPadrao = 50.0;
  static const Visibilidade _visibilidadePadrao = .private;

  static const Map<String, bool> _servicosPadrao = {
    'Buffet': false,
    'Fotógrafo': false,
    'Decoração': false,
    'DJ': false,
  };

  static const List<String> _tagsDisponiveis = [
    'Vegetariano',
    'Sem glúten',
    'Sem lactose',
    'Vegano',
  ];

  static const List<String> _tagsPadrao = [];
  static const bool _lembretePadrao = true;

  late DateTime _dataSelecionada;
  late TimeOfDay _horarioSelecionado;
  late String _tipoEventoSelecionado;
  late double _quantidadeConvidados;
  late Visibilidade _visibilidadeSelecionada;
  late Map<String, bool> _servicosSelecionados;
  late List<String> _tagsSelecionadas;
  late bool _notificacaoAtiva;

  @override
  void initState() {
    super.initState();
    _resetarValores();
  }

  void _resetarValores() {
    setState(() {
      _dataSelecionada = _dataPadrao;
      _horarioSelecionado = _horarioPadrao;
      _tipoEventoSelecionado = _tipoPadrao;
      _quantidadeConvidados = _convidadosPadrao;
      _visibilidadeSelecionada = _visibilidadePadrao;
      _servicosSelecionados = Map<String, bool>.from(_servicosPadrao);
      _tagsSelecionadas = List<String>.from(_tagsPadrao);
      _notificacaoAtiva = _lembretePadrao;
    });
    print('[DEBUT] Formulário resetado para os valores padrão');
  }

  void _salvarFormulario() {
    print('============================');
    print('    RESUMO DO AGENDAMENTO   ');
    print('============================');
    print(
      ' Data: ${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}',
    );
    print('Horário: ${_horarioSelecionado.format(context)}');
    print('Tipo de evento: $_tipoEventoSelecionado');
    print('Estimativa de convidados: ${_quantidadeConvidados.round()}');
    print('Visibilidade: $_visibilidadeSelecionada');
    print('Serviços adicionais: $_servicosSelecionados');
    print('Restrições alimentares (tags): $_tagsSelecionadas');
    print('Lembrete automático: $_notificacaoAtiva');
    print('============================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Evento salvo com sucesso! Veja os logs no console'),
      ),
    );
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (data != null && data != _dataSelecionada) {
      setState(() {
        _dataSelecionada = data;
      });
      print('[DEBUG - DatePicker] Data selecionada: $data');
    }
  }

  Future<void> _selecionarHorario(BuildContext content) async {
    final TimeOfDay? horario = await showTimePicker(
      context: context,
      initialTime: _horarioSelecionado,
    );

    if (horario != null && horario != _horarioSelecionado) {
      setState(() {
        _horarioSelecionado = horario;
      });
      print(
        '[DEBUG - TimePicker] Horário selecionado: ${horario.format(context)}',
      );
    }
  }

  @override
  Widget build(BuildContext content) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo evento social'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data e horário',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      '${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}',
                    ),
                    onPressed: () => _selecionarData(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(_horarioSelecionado.format(context)),
                    onPressed: () => _selecionarHorario(context),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            Text(
              'Tipo de evento',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _tipoEventoSelecionado,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: ['Aniversário', 'Casamento', 'Corporativo', 'Outro']
                  .map(
                    (tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)),
                  )
                  .toList(),
              onChanged: (novoValor) {
                if (novoValor != null) {
                  setState(() {
                    _tipoEventoSelecionado = novoValor;
                  });
                  print(
                    '[DEBUG - Menu] Tipo de evento selecionado: $novoValor',
                  );
                }
              },
            ),
            const Divider(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantidade de convidados',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${_quantidadeConvidados.round()} pessoas',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Slider(
              value: _quantidadeConvidados,
              min: 10,
              max: 500,
              divisions: 49,
              label: _quantidadeConvidados.round().toString(),
              onChanged: (novoValor) {
                setState(() {
                  _quantidadeConvidados = novoValor;
                });
                print(
                  '[DEBUT - Slider] Quantidade de convidados: ${novoValor.round()}',
                );
              },
            ),
            const Divider(height: 32),

            Text(
              'Visiblidade do evento',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            RadioGroup<Visibilidade>(
              groupValue: _visibilidadeSelecionada,
              onChanged: (Visibilidade? visibilidade) {
                setState(() {
                  _visibilidadeSelecionada = visibilidade!;
                  print('[DEBUG - Radio ] Visibilidade: $visibilidade');
                });
              },
              child: Column(
                children: [
                  ListTile(
                    title: Text('Público'),
                    leading: Radio<Visibilidade>(value: Visibilidade.public),
                  ),

                  ListTile(
                    title: Text('Privado'),
                    leading: Radio<Visibilidade>(value: Visibilidade.private),
                  ),

                  ListTile(
                    title: Text('Apenas convidados'),
                    leading: Radio<Visibilidade>(value: Visibilidade.vip),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),

            Text(
              'Serviços adicionais',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Column(
              children: _servicosSelecionados.keys.map((servico) {
                return CheckboxListTile(
                  dense: true,
                  title: Text(servico),
                  value: _servicosSelecionados[servico],
                  onChanged: (bool? marcado) {
                    setState(() {
                      _servicosSelecionados[servico] = marcado ?? false;
                    });
                    print(
                      '[DEBUG - Checkbox] Serviço "$servico" alterado para: $marcado',
                    );
                  },
                );
              }).toList(),
            ),
            const Divider(height: 32),

            Text(
              'Restrições alimentares (tags)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: _tagsDisponiveis.map((tag) {
                final estaSelecionado = _tagsSelecionadas.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: estaSelecionado,
                  onSelected: (bool selecionado) {
                    setState(() {
                      if (selecionado) {
                        _tagsSelecionadas.add(tag);
                      } else {
                        _tagsSelecionadas.remove(tag);
                      }
                    });
                    print(
                      '[DEBUG - Chip] Tag "$tag" ${selecionado ? "adicionada" : "removida "}. Lista Atual: $_tagsSelecionadas',
                    );
                  },
                );
              }).toList(),
            ),
            const Divider(height: 32),

            SwitchListTile(
              title: const Text('Enviar lembrete automático'),
              subtitle: const Text(
                'Notificar convidados 24 horas antes do evento',
              ),
              value: _notificacaoAtiva,
              onChanged: (bool ativo) {
                setState(() {
                  _notificacaoAtiva = ativo;
                });
                print(
                  '[DEBUG - Switch] Notificação automática alterada para: $ativo',
                );
              },
            ),
            const Divider(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetarValores,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {

                      _salvarFormulario();
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            height: 300,
                            color: Colors.purple,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: .center,
                                mainAxisSize: .min,
                                children: <Widget>[
                                  Text(
                                    'Data: ${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}\n'
                                    'Horário: ${_horarioSelecionado.format(context)}\n'
                                    'Tipo de evento: $_tipoEventoSelecionado\n'
                                    'Estimativa de convidados: ${_quantidadeConvidados.round()}\n'
                                    'Visibilidade: $_visibilidadeSelecionada\n'
                                    'Serviços adicionais: $_servicosSelecionados\n'
                                    'Restrições alimentares: ${_tagsSelecionadas.join(", ")}\n'
                                    'Lembrete automático: $_notificacaoAtiva\n', 
                                    textAlign: TextAlign.left,
                                  ),
                                  ElevatedButton(
                                    child: const Text('Fechar'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Salvar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
