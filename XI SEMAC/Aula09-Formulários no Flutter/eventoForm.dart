import 'package:flutter/material.dart';

void main() {
  runApp(const EventRegistrationApp());
}

class EventRegistrationApp extends StatelessWidget {
  const EventRegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Evento Flutter',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      home: const EventRegistrationPage(),
    );
  }
}

class EventRegistrationPage extends StatefulWidget {
  const EventRegistrationPage({super.key});
  
  @override
  // A classe deve ser um StatefulWidget para gerenciar o estado do formulário
  _EventRegistrationPageState createState() => _EventRegistrationPageState();
}

class _EventRegistrationPageState extends State<EventRegistrationPage> {
  // Passo 01: GlobalKey para identificar e validar o Form
  final _formKey = GlobalKey<FormState>();
  
  // Controllers para capturar o texto dos campos
  final _nomeController = TextEditingController();
  final _dataController = TextEditingController(); 
  final _emailController = TextEditingController();
  
  String _selectedEventType = 'Workshop'; // Valor inicial
  
  // Lista de opções para o Dropdown 
  final List<String> _eventTypes = ['Workshop', 'Conferência', 'Webinar', 'Encontro'];


  @override
  void dispose() {
    _nomeController.dispose();
    _dataController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Validação dos campos de entrada (Passo 04)
    if (_formKey.currentState!.validate()) {
      // Campos de entrada foram salvos (Passo 05)
      String nome = _nomeController.text;
      String data = _dataController.text;
      String email = _emailController.text;
      String tipo = _selectedEventType;

      // Exibindo os dados salvos no console 
      print('--- DADOS DO EVENTO CADASTRADO ---');
      print('Nome do Evento: $nome');
      print('Data: $data');
      print('E-mail de Contato: $email');
      print('Tipo de Evento: $tipo');
      
      // Feedback visual para o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulário de Evento Válido e Enviado!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Novo Evento'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(24.0),
        child: Form( 
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Evento / Título',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome do evento não pode ser vazio!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              TextFormField(
                controller: _dataController,
                decoration: const InputDecoration(
                  labelText: 'Data do Evento (Ex: 24/11/2025)',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 20.0),
              
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail de Contato',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && !value.contains('@')) {
                    return 'Por favor, insira um e-mail válido!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo de Evento',
                  prefixIcon: Icon(Icons.category),
                ),
                value: _selectedEventType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedEventType = newValue!;
                  });
                },
                items: _eventTypes
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30.0),

              ElevatedButton.icon(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.send),
                label: const Text(
                  'Cadastrar Evento',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}