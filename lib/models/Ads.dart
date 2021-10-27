// @dart=2.9
class Ads {
  String imageUrl;
  String name;
  int id;
  String content;
  String linkUrl;
  String type;

  Ads({this.imageUrl, this.name, this.id, this.content, this.linkUrl,this.type});

  Ads.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    name = json['name'];
    id = json['id'];
    content = json['content'];
    linkUrl = json['linkUrl'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['name'] = this.name;
    data['id'] = this.id;
    data['content'] = this.content;
    data['linkUrl'] = this.linkUrl;
    data['type'] = this.type;
    return data;
  }
}