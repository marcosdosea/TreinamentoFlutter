import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveDashboardApp());
}

class ResponsiveDashboardApp extends StatelessWidget {
  const ResponsiveDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Responsivo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, 
      ),
      home: const DashboardHomePage(),
    );
  }
}

class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  // Função auxiliar para construir um "Card" do Dashboard
  Widget _buildDashboardCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
  
  // Função para criar o layout de 1 coluna (telas pequenas)
  Widget _buildSmallLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDashboardCard('Vendas Totais', Icons.monetization_on, Colors.green),
          const SizedBox(height: 16),
          _buildDashboardCard('Novos Usuários', Icons.people_alt, Colors.blue),
          const SizedBox(height: 16),
          _buildDashboardCard('Taxa de Conversão', Icons.timeline, Colors.orange),
          const SizedBox(height: 16),
          _buildDashboardCard('Suporte Ativo', Icons.support_agent, Colors.red),
        ],
      ),
    );
  }

  // Função para criar o layout de 2 colunas (telas grandes)
  Widget _buildLargeLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: GridView.count(
        crossAxisCount: 2, 
        shrinkWrap: true, 
        physics: const NeverScrollableScrollPhysics(), 
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        childAspectRatio: 1.5, 
        children: [
          _buildDashboardCard('Vendas Totais', Icons.monetization_on, Colors.green),
          _buildDashboardCard('Novos Usuários', Icons.people_alt, Colors.blue),
          _buildDashboardCard('Taxa de Conversão', Icons.timeline, Colors.orange),
          _buildDashboardCard('Suporte Ativo', Icons.support_agent, Colors.red),
          _buildDashboardCard('Métricas Extras', Icons.star, Colors.purple),
          _buildDashboardCard('Relatórios', Icons.folder_open, Colors.brown),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Responsivo'),
        backgroundColor: Colors.blueGrey,
      ),
      body: LayoutBuilder( 
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 600) { 
            // Telas pequenas (celulares) usam layout de 1 coluna
            return _buildSmallLayout();
          } else {
            // Telas grandes (tablets, web) usam layout de 2 colunas
            return _buildLargeLayout();
          }
        },
      ),
    );
  }
}