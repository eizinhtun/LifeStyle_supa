// @dart=2.9
class Ads {

  String name;
  String content;
  int id;
  String linkUrl;
  String type;
  String imageUrl;

  Ads({
   this.name,  this.content,
    this.id,this.linkUrl,this.type,this.imageUrl});

  Ads.fromJson(Map<String, dynamic> json) {

    name = json['name'];
    content = json['content'];
    id = json['id'];
    linkUrl = json['linkUrl'];
    type = json['type'];
    imageUrl = json['imageUrl'];

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