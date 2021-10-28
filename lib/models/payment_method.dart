// @dart=2.9
class PaymentMethod {
  bool active;
  String name;
  String id;
  int orderId;
  String logoUrl;


  PaymentMethod({this.logoUrl, this.name, this.id, this.orderId, this.active});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    logoUrl = json['logoUrl'];
    name = json['name'];
    id = json['id'];
    active = json['active'];
    orderId = json['orderId'];

  }

}