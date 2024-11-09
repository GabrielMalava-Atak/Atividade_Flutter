import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../services/api_service.dart';
import 'register_service_screen.dart';

class WikiScreen extends StatefulWidget {
  @override
  _WikiScreenState createState() => _WikiScreenState();
}

class _WikiScreenState extends State<WikiScreen> {
  final ApiService _apiService = ApiService();
  List<ServiceModel> _services = [];

  @override
  void initState() {
    super.initState();
    _loadServices(); // Carrega a lista inicial de serviços
  }

  void _loadServices() {
    _apiService.fetchServices().then((services) {
      setState(() {
        _services = services;
      });
    });
  }

  Future<void> _navigateToRegisterService() async {
    final newService = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterServiceScreen()),
    );

    if (newService != null && newService is ServiceModel) {
      setState(() {
        _services.add(newService); // Adiciona o serviço recém-adicionado à lista
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Serviços Registrados'),
      ),
      body: ListView.builder(
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final service = _services[index];
          return ListTile(
            title: Text(service.name),
            subtitle: Text(service.description),
            trailing: Text('Disponível em: ${service.availabilityDate.toLocal()}'.split(' ')[0]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRegisterService, // Navega para a tela de registro de serviço
        child: Icon(Icons.add),
      ),
    );
  }
}
