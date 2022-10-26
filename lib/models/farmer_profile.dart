class Farmer_profile {
  List<FarmerDetails>? farmerDetails;
  List<Plotdevices>? plotdevices;
  List<Farmlanddevices>? farmlanddevices;

  Farmer_profile({this.farmerDetails, this.plotdevices, this.farmlanddevices});

  Farmer_profile.fromJson(Map<String, dynamic> json) {
    if (json['FarmerDetails'] != null) {
      farmerDetails = <FarmerDetails>[];
      json['FarmerDetails'].forEach((v) {
        farmerDetails!.add(new FarmerDetails.fromJson(v));
      });
    }
    if (json['Plotdevices'] != null) {
      plotdevices = <Plotdevices>[];
      json['Plotdevices'].forEach((v) {
        plotdevices!.add(new Plotdevices.fromJson(v));
      });
    }
    if (json['Farmlanddevices'] != null) {
      farmlanddevices = <Farmlanddevices>[];
      json['Farmlanddevices'].forEach((v) {
        farmlanddevices!.add(new Farmlanddevices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.farmerDetails != null) {
      data['FarmerDetails'] =
          this.farmerDetails!.map((v) => v.toJson()).toList();
    }
    if (this.plotdevices != null) {
      data['Plotdevices'] = this.plotdevices!.map((v) => v.toJson()).toList();
    }
    if (this.farmlanddevices != null) {
      data['Farmlanddevices'] =
          this.farmlanddevices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FarmerDetails {
  int? iD;
  String? name;
  String? alias;
  Null? fatherName;
  String? address1;
  Null? address2;
  Null? address3;
  Null? fPinCode;
  int? mobileNumberPrimary;
  Null? fEmail;
  int? villageID;
  int? clientID;
  int? filedOfficeID;
  String? foName;
  Null? foalias;
  Null? filedOfficerAddress1;
  int? fomobile;
  String? foemail;
  int? fmId;
  String?VillageName;
  String? fmname;
  Null? fmalias;
  Null? fmaddress;
  Null? filedManagerMobile;
  Null? fmemail;

  FarmerDetails(
      {this.iD,
        this.name,
        this.alias,
        this.fatherName,
        this.address1,
        this.address2,
        this.address3,
        this.fPinCode,
        this.mobileNumberPrimary,
        this.fEmail,
        this.villageID,
        this.clientID,
        this.filedOfficeID,
        this.foName,
        this.foalias,
        this.filedOfficerAddress1,
        this.fomobile,
        this.foemail,
        this.fmId,
        this.fmname,
        this.fmalias,
        this.fmaddress,
        this.filedManagerMobile,
        this.fmemail,
       this.VillageName
      });

  FarmerDetails.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    alias = json['Alias'];
    fatherName = json['FatherName'];
    address1 = json['Address1'];
    address2 = json['Address2'];
    address3 = json['Address3'];
    fPinCode = json['fPinCode'];
    mobileNumberPrimary = json['MobileNumberPrimary'];
    fEmail = json['fEmail'];
    villageID = json['VillageID'];
    clientID = json['ClientID'];
    filedOfficeID = json['FiledOfficeID'];
    foName = json['foName'];
    foalias = json['foalias'];
    filedOfficerAddress1 = json['FiledOfficerAddress1'];
    fomobile = json['fomobile'];
    foemail = json['foemail'];
    VillageName=json['VillageName'];
    fmId = json['fmId'];
    fmname = json['fmname'];
    fmalias = json['fmalias'];
    fmaddress = json['fmaddress'];
    filedManagerMobile = json['FiledManagerMobile'];
    fmemail = json['fmemail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Alias'] = this.alias;
    data['FatherName'] = this.fatherName;
    data['Address1'] = this.address1;
    data['Address2'] = this.address2;
    data['Address3'] = this.address3;
    data['fPinCode'] = this.fPinCode;
    data['MobileNumberPrimary'] = this.mobileNumberPrimary;
    data['fEmail'] = this.fEmail;
    data['VillageID'] = this.villageID;
    data['ClientID'] = this.clientID;
    data['FiledOfficeID'] = this.filedOfficeID;
    data['foName'] = this.foName;
    data['foalias'] = this.foalias;
    data['FiledOfficerAddress1'] = this.filedOfficerAddress1;
    data['fomobile'] = this.fomobile;
    data['foemail'] = this.foemail;
    data['fmId'] = this.fmId;
    data['VillageName']=this.VillageName;
    data['fmname'] = this.fmname;
    data['fmalias'] = this.fmalias;
    data['fmaddress'] = this.fmaddress;
    data['FiledManagerMobile'] = this.filedManagerMobile;
    data['fmemail'] = this.fmemail;
    return data;
  }
}

class Plotdevices {
  int? iD;
  String? name;
  int? deviceTypeID;
  String? farmerSectionType;
  String? deviceEUIID;
  int? farmerSectionDetailsID;
  double? latitude;
  double? longitude;
  String? hardwareSerialNumber;

  Plotdevices(
      {this.iD,
        this.name,
        this.deviceTypeID,
        this.farmerSectionType,
        this.deviceEUIID,
        this.farmerSectionDetailsID,
        this.latitude,
        this.longitude,
        this.hardwareSerialNumber});

  Plotdevices.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    deviceTypeID = json['DeviceTypeID'];
    farmerSectionType = json['FarmerSectionType'];
    deviceEUIID = json['DeviceEUIID'];
    farmerSectionDetailsID = json['FarmerSectionDetailsID'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    hardwareSerialNumber = json['HardwareSerialNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['DeviceTypeID'] = this.deviceTypeID;
    data['FarmerSectionType'] = this.farmerSectionType;
    data['DeviceEUIID'] = this.deviceEUIID;
    data['FarmerSectionDetailsID'] = this.farmerSectionDetailsID;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['HardwareSerialNumber'] = this.hardwareSerialNumber;
    return data;
  }
}
class Farmlanddevices {
  int? iD;
  String? name;
  int? deviceTypeID;
  String? farmerSectionType;
  String? deviceEUIID;
  int? farmerSectionDetailsID;
  double? latitude;
  double? longitude;
  String? hardwareSerialNumber;

  Farmlanddevices(
      {this.iD,
        this.name,
        this.deviceTypeID,
        this.farmerSectionType,
        this.deviceEUIID,
        this.farmerSectionDetailsID,
        this.latitude,
        this.longitude,
        this.hardwareSerialNumber});

  Farmlanddevices.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    deviceTypeID = json['DeviceTypeID'];
    farmerSectionType = json['FarmerSectionType'];
    deviceEUIID = json['DeviceEUIID'];
    farmerSectionDetailsID = json['FarmerSectionDetailsID'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    hardwareSerialNumber = json['HardwareSerialNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['DeviceTypeID'] = this.deviceTypeID;
    data['FarmerSectionType'] = this.farmerSectionType;
    data['DeviceEUIID'] = this.deviceEUIID;
    data['FarmerSectionDetailsID'] = this.farmerSectionDetailsID;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['HardwareSerialNumber'] = this.hardwareSerialNumber;
    return data;
  }
}