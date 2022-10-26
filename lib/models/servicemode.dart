class Servicemode {
  String? farmername;
  String? client;
  String? filedManager;
  String? fieldOffice;
  String? name;
  String? deviceEUIID;
  String? hardwareSerialNumber;
  String? sectionType;
  double? latitude;
  double? longitude;
  String? fType;
  bool ?isswitched;
  String? farmerSectionType;
  int? clientID;
  int? farmerID;
  int? fieldOfficeMobileNumber;
  int? fieldManagerMobileNumber;

  Servicemode(
      {this.farmername,
        this.client,
        this.filedManager,
        this.fieldOffice,
        this.name,
        this.deviceEUIID,
        this.hardwareSerialNumber,
        this.sectionType,
        this.isswitched,
        this.latitude,
        this.longitude,
        this.fType,
        this.farmerSectionType,
        this.clientID,
        this.farmerID,
        this.fieldOfficeMobileNumber,
        this.fieldManagerMobileNumber});

  Servicemode.fromJson(Map<String, dynamic> json) {
    farmername = json['farmername'];
    client = json['client'];
    filedManager = json['FiledManager'];
    fieldOffice = json['FieldOffice'];
    name = json['Name'];
    deviceEUIID = json['DeviceEUIID'];
    hardwareSerialNumber = json['HardwareSerialNumber'];
    sectionType = json['SectionName'];
    latitude = json['Latitude']??0.0;
    longitude = json['Longitude']??0.0;
    fType = json['fType'];
    isswitched=false;
    farmerSectionType = json['FarmerSectionType'];
    clientID = json['ClientID'];
    farmerID = json['FarmerID'];
    fieldOfficeMobileNumber = json['FieldOfficeMobileNumber'];
    fieldManagerMobileNumber = json['FieldManagerMobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['farmername'] = this.farmername;
    data['client'] = this.client;
    data['FiledManager'] = this.filedManager;
    data['FieldOffice'] = this.fieldOffice;
    data['Name'] = this.name;
    data['DeviceEUIID'] = this.deviceEUIID;
    data['HardwareSerialNumber'] = this.hardwareSerialNumber;
    data['SectionName'] = this.sectionType;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['fType'] = this.fType;
    data['FarmerSectionType'] = this.farmerSectionType;
    data['ClientID'] = this.clientID;
    data['FarmerID'] = this.farmerID;
    data['FieldOfficeMobileNumber'] = this.fieldOfficeMobileNumber;
    data['FieldManagerMobileNumber'] = this.fieldManagerMobileNumber;
    return data;
  }
}