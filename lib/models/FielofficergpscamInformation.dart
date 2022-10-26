class Fieldofficer {
  String? filedOfficerAddress;
  int? filedOfficerMobileNumber;
  String? filedOfficerfEmail;
  String? filedOfficerName;
  String? filedOfficerAlias;
  String? filedManagerName;
  int? filedManagerMobileNumber;
  double? latitude;
  double? longitude;
  String? imageNV;
  String? filedManagerfEmail;
  int? fieldOfficerID;
  int? fieldManagerID;

  Fieldofficer(
      {this.filedOfficerAddress,
        this.filedOfficerMobileNumber,
        this.filedOfficerfEmail,
        this.filedOfficerName,
        this.filedOfficerAlias,
        this.filedManagerName,
        this.filedManagerMobileNumber,
        this.latitude,
        this.longitude,
        this.imageNV,
        this.filedManagerfEmail,
        this.fieldOfficerID,
        this.fieldManagerID});

  Fieldofficer.fromJson(Map<String, dynamic> json) {
    filedOfficerAddress = json['Address1']??"";
    filedOfficerMobileNumber = json['MobileNumber1']??"";
    filedOfficerfEmail = json['fEmail']??"";
    filedOfficerName = json['Name']??"";
    filedOfficerAlias = json['Alias']??"";
    latitude = json['Latitude']==null?0.0: json['Latitude'].toDouble();
    longitude = json['Longitude']==null?0.0:json['Longitude'].toDouble();
    imageNV = json['ImageNV'];
    filedManagerfEmail = json['FiledManagerfEmail'];
    fieldOfficerID = json['ID'];
    fieldManagerID = json['FieldManagerID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Address1'] = this.filedOfficerAddress;
    data['MobileNumber1'] = this.filedOfficerMobileNumber;
    data['fEmail'] = this.filedOfficerfEmail;
    data['Name'] = this.filedOfficerName;
    data['Alias'] = this.filedOfficerAlias;
    data['FiledManagerName'] = this.filedManagerName;
    data['FiledManagerMobileNumber'] = this.filedManagerMobileNumber;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['ImageNV'] = this.imageNV;
    data['FiledManagerfEmail'] = this.filedManagerfEmail;
    data['ID'] = this.fieldOfficerID;
    data['FieldManagerID'] = this.fieldManagerID;
    return data;
  }
}