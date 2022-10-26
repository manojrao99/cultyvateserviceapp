class FarmerDeviceDetails {
  int? farmerID;
  String? name;
  double? lat;
  double? long;
  String? villageName;
  List<Farmlands>? farmlands;

  FarmerDeviceDetails(
      {this.farmerID,
        this.name,
        this.lat,
        this.long,
        this.villageName,
        this.farmlands});

  FarmerDeviceDetails.fromJson(Map<String, dynamic> json) {
    farmerID = json['farmerID'];
    name = json['name'];
    lat = json['lat'];
    long = json['long'];
    villageName = json['villageName'];
    if (json['farmlands'] != null) {
      farmlands = <Farmlands>[];
      json['farmlands'].forEach((v) {
        farmlands!.add(new Farmlands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['farmerID'] = this.farmerID;
    data['name'] = this.name;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['villageName'] = this.villageName;
    if (this.farmlands != null) {
      data['farmlands'] = this.farmlands!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Farmlands {
  int? farmlandId;
  String? farmlandName;
  double? lat;
  double? long;
  List<Blocks>? blocks;
  List<Devices>? devices;

  Farmlands(
      {this.farmlandId,
        this.farmlandName,
        this.lat,
        this.long,
        this.blocks,
        this.devices});

  Farmlands.fromJson(Map<String, dynamic> json) {
    farmlandId = json['farmland_id'];
    farmlandName = json['farmland_name'];
    lat = json['lat'];
    long = json['long'];
    if (json['blocks'] != null) {
      blocks = <Blocks>[];
      json['blocks'].forEach((v) {
        blocks!.add(new Blocks.fromJson(v));
      });
    }
    if (json['devices'] != null) {
      devices = <Devices>[];
      json['devices'].forEach((v) {
        devices!.add(new Devices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['farmland_id'] = this.farmlandId;
    data['farmland_name'] = this.farmlandName;
    data['lat'] = this.lat;
    data['long'] = this.long;
    if (this.blocks != null) {
      data['blocks'] = this.blocks!.map((v) => v.toJson()).toList();
    }
    if (this.devices != null) {
      data['devices'] = this.devices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Blocks {
  int? id;
  String? name;
  List<Plots>? plots;
  List<Devices>? devices;

  Blocks({this.id, this.name, this.plots, this.devices});

  Blocks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['plots'] != null) {
      plots = <Plots>[];
      json['plots'].forEach((v) {
        plots!.add(new Plots.fromJson(v));
      });
    }
    if (json['devices'] != null) {
      devices = <Devices>[];
      json['devices'].forEach((v) {
        devices!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.plots != null) {
      data['plots'] = this.plots!.map((v) => v.toJson()).toList();
    }
    if (this.devices != null) {
      data['devices'] = this.devices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plots {
  int? id;
  String? name;
  List<Devices>? devices;

  Plots({this.id, this.name, this.devices});

  Plots.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['devices'] != null) {
      devices = <Devices>[];
      json['devices'].forEach((v) {
        devices!.add(new Devices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.devices != null) {
      data['devices'] = this.devices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Devices {
  int? deviceID;
  String? name;
  String? modelNumber;
  String? type;
  String? farmerSectionType;
  String? hardwareSerialNumber;
  String? deviceEUIID;
  double? latitude;
  double? longitude;

  Devices(
      {this.deviceID,
        this.name,
        this.modelNumber,
        this.type,
        this.farmerSectionType,
        this.hardwareSerialNumber,
        this.deviceEUIID,
        this.latitude,
        this.longitude});

  Devices.fromJson(Map<String, dynamic> json) {
    deviceID = json['deviceID'];
    name = json['name'];
    modelNumber = json['modelNumber'];
    type = json['type'];
    farmerSectionType = json['farmerSectionType'];
    hardwareSerialNumber = json['hardwareSerialNumber'];
    deviceEUIID = json['deviceEUIID'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceID'] = this.deviceID;
    data['name'] = this.name;
    data['modelNumber'] = this.modelNumber;
    data['type'] = this.type;
    data['farmerSectionType'] = this.farmerSectionType;
    data['hardwareSerialNumber'] = this.hardwareSerialNumber;
    data['deviceEUIID'] = this.deviceEUIID;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}