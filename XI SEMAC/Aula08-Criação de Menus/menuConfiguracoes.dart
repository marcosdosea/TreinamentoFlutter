import 'package:flutter/material.dart';

void main() => runApp(const SettingsApp());

class SettingsApp extends StatelessWidget {
  const SettingsApp({super.key});

  static const appTitle = 'App de Configurações';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.teal, 
        appBarTheme: const AppBarTheme(
          color: Colors.teal,
        ),
      ),
      home: const SettingsHomePage(title: appTitle),
    );
  }
}

class SettingsHomePage extends StatefulWidget {
  const SettingsHomePage({super.key, required this.title});

  final String title;

  @override
  State<SettingsHomePage> createState() => _SettingsHomePageState();
}

class _SettingsHomePageState extends State<SettingsHomePage> {

  int _selectedIndex = 0;

  //Opções de tela (Widgets) que serão exibidas no corpo do Scaffold
  static const List<Map<String, dynamic>> _menuOptions = [
    {'title': 'Geral', 'icon': Icons.settings},
    {'title': 'Notificações', 'icon': Icons.notifications},
    {'title': 'Privacidade', 'icon': Icons.lock},
    {'title': 'Sobre', 'icon': Icons.info_outline},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Passo 01: Criar um Scaffold
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 4, 
      ),
      body: Center(
        // Exibe o conteúdo da tela selecionada
        child: Text(
          'Conteúdo da Seção: ${_menuOptions[_selectedIndex]['title']}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.teal),
        ),
      ),
      
      // Passo 02: Adicionar um Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, 
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.tune, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text('Menu de Configurações', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            
            // Passo 03: Preencher o Drawer com itens usando ListTile
            ..._menuOptions.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> option = entry.value;

              return ListTile(
                leading: Icon(option['icon'], color: _selectedIndex == index ? Colors.teal : Colors.grey),
                title: Text(
                  option['title'],
                  style: TextStyle(
                    fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: _selectedIndex == index, // Indica se o item está selecionado
                selectedTileColor: Colors.teal.shade50, 
                onTap: () => _onItemTapped(index),
              );
            }).toList(),
            
            const Divider(), 
            
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair do App'),
              onTap: () {
                // Apenas fecha o menu, como exemplo
                Navigator.pop(context); 
              },
            ),
          ],
        ),
      ),
    );
  }
}