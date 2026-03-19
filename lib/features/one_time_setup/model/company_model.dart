// ignore_for_file: non_constant_identifier_names

class CompanyEntity {
  CompanyEntity({required this.id, required this.text, required this.IdStr});

  CompanyEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    IdStr = json['IdStr'];
  }

  late final int id;
  late final String text;
  late final String IdStr;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['id'] = id;
    data['text'] = text;
    data['IdStr'] = IdStr;
    return data;
  }
}
