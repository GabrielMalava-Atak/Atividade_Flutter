class ServiceModel {
  final String? id;
  final String name;
  final String description;
  final DateTime availabilityDate;

  ServiceModel({
    this.id, // Agora o ID é opcional
    required this.name,
    required this.description,
    required this.availabilityDate,
  });

  // Construtor para criar um objeto a partir de um JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id']?.toString(), // Converte o ID para String, caso esteja presente
      name: json['name'],
      description: json['description'],
      availabilityDate: DateTime.parse(json['availabilityDate']),
    );
  }

  // Método para converter o objeto em JSON
  Map<String, dynamic> toJson() {
    // Cria o mapa e adiciona campos opcionais apenas se não forem nulos
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'availabilityDate': availabilityDate.toIso8601String(),
    };

    // Adiciona o campo 'id' somente se não for nulo
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
