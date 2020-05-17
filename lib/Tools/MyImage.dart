class MyImage {
  int createdAt;
  String url;

  MyImage({this.createdAt, this.url});

  MyImage.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['url'] = this.url;
    return data;
  }
}
