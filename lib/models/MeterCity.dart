// @dart=2.9

class MeterCity {
  String name;
  String name_my;
  String name_zh;
  String apiUrl;
  String id;

  MeterCity(this.id, this.name, this.name_my, this.name_zh, this.apiUrl);

  // formatting for upload to Firbase when creating the MeterCity
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_my': name_my,
        'name_zh': name_zh,
        'apiUrl': apiUrl,
      };

  // creating a MeterCity object from a firebase snapshot
  MeterCity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    name_my = json['name_my'];
    name_zh = json['name_zh'];
    apiUrl = json['apiUrl'];
  }
}
