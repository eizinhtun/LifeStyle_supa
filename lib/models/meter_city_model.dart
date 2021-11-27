// @dart=2.9

class MeterCity {
  String name;
  String nameMy;
  String nameZh;
  String apiUrl;
  String id;

  MeterCity(this.id, this.name, this.nameMy, this.nameZh, this.apiUrl);

  // formatting for upload to Firbase when creating the MeterCity
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_my': nameMy,
        'name_zh': nameZh,
        'apiUrl': apiUrl,
      };

  // creating a MeterCity object from a firebase snapshot
  MeterCity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameMy = json['name_my'];
    nameZh = json['name_zh'];
    apiUrl = json['apiUrl'];
  }
}
