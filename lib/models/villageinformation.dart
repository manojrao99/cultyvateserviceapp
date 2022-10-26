class VillageInformation {
  String? villagename;
  int? iD;
  int? talukaID;
  String? talukaName;
  String? districtName;

  VillageInformation(
      {this.villagename, this.iD, this.talukaID, this.talukaName, this.districtName});

  VillageInformation.fromJson(Map<String, dynamic> json) {
    villagename = json['Name'];
    iD = json['ID'];
    talukaID = json['TalukaID'];
    talukaName = json['TalukaName'];
    districtName = json['DistrictName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.villagename;
    data['ID'] = this.iD;
    data['TalukaID'] = this.talukaID;
    data['TalukaName'] = this.talukaName;
    data['DistrictName'] = this.districtName;
    return data;
  }
}