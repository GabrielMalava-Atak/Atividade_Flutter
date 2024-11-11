import '../models/service_model.dart';

class ApiService {
  final List<ServiceModel> _services = [
    ServiceModel(
      id: '1',
      name: 'Aulas de Programação',
      description: 'Aulas sobre Flutter e Dart para iniciantes',
      availabilityDate: DateTime.parse('2023-12-31T00:00:00Z'),
    ),
    ServiceModel(
      id: '2',
      name: 'Aulas de Inglês',
      description: 'Curso intensivo de inglês focado em conversação',
      availabilityDate: DateTime.parse('2023-11-30T00:00:00Z'),
    ),
  ];

  Future<List<ServiceModel>> fetchServices() async {
    return Future.value(_services);
  }

  void addService(ServiceModel service) {
    _services.add(service);
    print('Serviço adicionado: ${service.name}'); // Verifica se o serviço está sendo adicionado
  }
}
