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

  late DateTime _dataSelecionada;
  late TimeOfDay _horarioSelecionado;
  late String _tipoEventoSelecionado;
  late double _quantidadeConvidados;
  late Visibilidade _visibilidadeSelecionada;

   static const Map<String, bool> _servicosPadrao = {
    'Buffet' : false,
    'Fotógrafo': false,
    'Decoração': false,
    'DJ': false,
   };

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
      print('[DEBUT - DatePicker] Data selecionada: $data');
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
        '[DEBUT - TimePicker] Horário selecionado: ${horario.format(context)}',
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
          ],
        ),
      ),
    );
  }
}