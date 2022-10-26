class FieldMangerInformation {
  String? imageNV;
  double? latitude;
  double? longitude;
  int? iD;
  String? name;
  String? alias;
  int? mobileNumber1;
  String? fEmail;

  FieldMangerInformation(
      {this.imageNV,
        this.latitude,
        this.longitude,
        this.iD,
        this.name,
        this.alias,
        this.mobileNumber1,
        this.fEmail});

  FieldMangerInformation.fromJson(Map<String, dynamic> json) {
    imageNV = json['ImageNV'];
    latitude = json['Latitude']==null?0.00:json['Latitude'].toDouble();
    longitude =json['Longitude']==null?0.00: json['Longitude'].toDouble();
    iD = json['ID'];
    name = json['Name'];
    alias = json['Alias'];
    mobileNumber1 = json['MobileNumber1'];
    fEmail = json['fEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ImageNV'] = this.imageNV;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Alias'] = this.alias;
    data['MobileNumber1'] = this.mobileNumber1;
    data['fEmail'] = this.fEmail;
    return data;
  }
}