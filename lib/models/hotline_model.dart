// @dart=2.9
class HotlineModel {
  String id;
  String type;
  String phoneNo;
  String viber;
  String messangerId;
  String title;

  HotlineModel(
      {this.id,
      this.type,
      this.phoneNo,
      this.viber,
      this.title,
      this.messangerId});

  HotlineModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    phoneNo = json['phone_no'];
    viber = json['viber'];
    messangerId = json['messanger_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['phone_no'] = this.phoneNo;
    data['viber'] = this.viber;
    data['title'] = this.title;
    data['messanger_id'] = this.messangerId;
    return data;
  }
}
