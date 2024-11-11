import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../services/api_service.dart';

class RegisterServiceScreen extends StatefulWidget {
  @override
  _RegisterServiceScreenState createState() => _RegisterServiceScreenState();
}

class _RegisterServiceScreenState extends State<RegisterServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _serviceDescriptionController = TextEditingController();
  DateTime? _selectedDate;
  final ApiService _apiService = ApiService();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _registerService() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final newService = ServiceModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _serviceNameController.text,
        description: _serviceDescriptionController.text,
        availabilityDate: _selectedDate!,
      );

      try {
        final createdService = await _apiService.addService(newService); // Envia o serviço para o JSON Server

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Serviço registrado com sucesso!')),
        );

        Navigator.pop(context, createdService); // Retorna o serviço recém-adicionado para WikiScreen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao registrar serviço')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Serviço'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _serviceNameController,
                decoration: InputDecoration(labelText: 'Nome do Serviço'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do serviço';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _serviceDescriptionController,
                decoration: InputDecoration(labelText: 'Descrição do Serviço'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição do serviço';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Nenhuma data selecionada'
                        : 'Data: ${_selectedDate!.toLocal()}'.split(' ')[0],
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => _pickDate(context),
                    child: Text('Selecionar Data'),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _registerService,
                  child: Text('Registrar Serviço'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
