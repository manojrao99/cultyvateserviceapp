class ClintsList {
  int? clintId;
  String? clintName;

  ClintsList({this.clintId, this.clintName});

  ClintsList.fromJson(Map<String, dynamic> json) {
    clintId = json['ClintId'];
    clintName = json['clintName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClintId'] = this.clintId;
    data['clintName'] = this.clintName;
    return data;
  }
}