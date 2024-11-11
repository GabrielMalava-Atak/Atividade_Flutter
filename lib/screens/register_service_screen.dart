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
  List<ServiceModel> _services = []; // Lista interna de serviços

Future<void> _pickDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (picked != null && picked != _selectedDate) {
    setState(() {
      _selectedDate = picked;
    });
  } else {
    // Você pode mostrar uma mensagem ao usuário se necessário
    print("Nenhuma data foi selecionada ou houve um erro.");
  }
}

  void _registerService() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final newService = ServiceModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _serviceNameController.text,
        description: _serviceDescriptionController.text,
        availabilityDate: _selectedDate!,
      );

      _apiService.addService(newService);  // Opcional: Salva o novo serviço na API ou banco de dados

      setState(() {
        _services.add(newService); // Adiciona o serviço à lista local para exibição
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Serviço registrado com sucesso!')),
      );

      // Limpa os campos após adicionar o serviço
      _serviceNameController.clear();
      _serviceDescriptionController.clear();
      _selectedDate = null;
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
        child: Column(
          children: [
            Form(
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
            SizedBox(height: 32),
            Expanded(
              child: _services.isEmpty
                  ? Center(child: Text('Nenhum serviço registrado.'))
                  : ListView.builder(
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
            ),
          ],
        ),
      ),
    );
  }
}
