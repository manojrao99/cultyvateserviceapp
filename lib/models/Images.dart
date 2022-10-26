class Farmerprofile {
  List<FarmerDetails>? farmerDetails;
  List<Plotdevices>? plotdevices;
  List<Plotdevices>? farmlanddevices;
  List<Images>? images;

  Farmerprofile(
      {this.farmerDetails,
        this.plotdevices,
        this.farmlanddevices,
        this.images});

  Farmerprofile.fromJson(Map<String, dynamic> json) {
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
      farmlanddevices = <Plotdevices>[];
      json['Farmlanddevices'].forEach((v) {
        farmlanddevices!.add(new Plotdevices.fromJson(v));
      });
    }
    if (json['Images'] != null) {
      images = <Images>[];
      json['Images'].forEach((v) {
        images!.add(new Images.fromJson(v));
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
    if (this.images != null) {
      data['Images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FarmerDetails {
  int? iD;
  String? name;
  String? alias;
  String? fatherName;
  String? address1;
  String? address2;
  String ? address3;
  String? fPinCode;
  int? mobileNumberPrimary;
  String? fEmail;
  int? villageID;
  int? clientID;
  int? filedOfficeID;
  String? foName;
  String? foalias;
  String? filedOfficerAddress1;
  int? fomobile;
  String? foemail;
  int? fmId;
  String? fmname;
  String? fmalias;
  String? fmaddress;
  int? filedManagerMobile;
  String? fmemail;
  String? villageName;

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
        this.villageName});

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
    fmId = json['fmId'];
    fmname = json['fmname'];
    fmalias = json['fmalias'];
    fmaddress = json['fmaddress'];
    filedManagerMobile = json['FiledManagerMobile'];
    fmemail = json['fmemail'];
    villageName = json['VillageName'];
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
    data['fmname'] = this.fmname;
    data['fmalias'] = this.fmalias;
    data['fmaddress'] = this.fmaddress;
    data['FiledManagerMobile'] = this.filedManagerMobile;
    data['fmemail'] = this.fmemail;
    data['VillageName'] = this.villageName;
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
  String? fType;
  String ?DeviceName;

  Plotdevices(
      {this.iD,
        this.name,
        this.DeviceName,
        this.deviceTypeID,
        this.farmerSectionType,
        this.deviceEUIID,
        this.farmerSectionDetailsID,
        this.latitude,
        this.longitude,
        this.hardwareSerialNumber,
        this.fType});

  Plotdevices.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    deviceTypeID = json['DeviceTypeID'];
    farmerSectionType = json['FarmerSectionType'];
    deviceEUIID = json['DeviceEUIID'];
    farmerSectionDetailsID = json['FarmerSectionDetailsID'];
    latitude = json['Latitude']==null?0.00:json['Latitude'].toDouble();
    longitude =json['Longitude']==null?0.00: json['Longitude'].toDouble();
    hardwareSerialNumber = json['HardwareSerialNumber'];
    fType = json['fType'];
    DeviceName=json['DeviceName'];
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
    data['fType'] = this.fType;
    return data;
  }
}

class Images {
  String? name;
  String? imageNV;
  int? iD;
  int? farmerID;
  int? gPSCamFieldOfficerID;
  int? gPSCamFieldManagerID;
  double? latitude;
  double? longitude;
  String? createDate;
  Null? alterDate;
  Null? deleteDate;
  Null? deleteYN;
  int? filedOfficerID;
  String? filedOfficerName;
  int? filedManagerID;
  String? filedManagerName;

  Images(
      {this.name,
        this.imageNV,
        this.iD,
        this.farmerID,
        this.gPSCamFieldOfficerID,
        this.gPSCamFieldManagerID,
        this.latitude,
        this.longitude,
        this.createDate,
        this.alterDate,
        this.deleteDate,
        this.deleteYN,
        this.filedOfficerID,
        this.filedOfficerName,
        this.filedManagerID,
        this.filedManagerName});

  Images.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    imageNV = json['ImageNV'];
    iD = json['ID'];
    farmerID = json['FarmerID'];
    gPSCamFieldOfficerID = json['GPSCamFieldOfficerID'];
    gPSCamFieldManagerID = json['GPSCamFieldManagerID'];
    latitude = json['Latitude']==null?0.00:json['Latitude'].toDouble();
    longitude =json['Longitude']==null?0.00: json['Longitude'].toDouble();
    createDate = json['CreateDate'];
    alterDate = json['AlterDate'];
    deleteDate = json['DeleteDate'];
    deleteYN = json['DeleteYN'];
    filedOfficerID = json['FiledOfficerID'];
    filedOfficerName = json['FiledOfficerName'];
    filedManagerID = json['FiledManagerID'];
    filedManagerName = json['FiledManagerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['ImageNV'] = this.imageNV;
    data['ID'] = this.iD;
    data['FarmerID'] = this.farmerID;
    data['GPSCamFieldOfficerID'] = this.gPSCamFieldOfficerID;
    data['GPSCamFieldManagerID'] = this.gPSCamFieldManagerID;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['CreateDate'] = this.createDate;
    data['AlterDate'] = this.alterDate;
    data['DeleteDate'] = this.deleteDate;
    data['DeleteYN'] = this.deleteYN;
    data['FiledOfficerID'] = this.filedOfficerID;
    data['FiledOfficerName'] = this.filedOfficerName;
    data['FiledManagerID'] = this.filedManagerID;
    data['FiledManagerName'] = this.filedManagerName;
    return data;
  }
}