class Devicedata {
  int? farmerid;
  String? farmername;
  String? fieldmanager;
  String? fieldofficer;
  List<FarmDevices>? farmlandDevices;
  List<BlockDevices>? blockDevices;
  List<PlotDevices>? plotDevices;

  Devicedata(
      {this.farmerid,
        this.farmername,
        this.fieldmanager,
        this.fieldofficer,
        this.farmlandDevices,
        this.blockDevices,
        this.plotDevices});

  Devicedata.fromJson(Map<String, dynamic> json) {
    farmerid = json['farmerid'];
    farmername = json['farmername'];
    fieldmanager = json[' fieldmanager'];
    fieldofficer = json[' fieldofficer'];
    if (json['farmland_devices'] != null) {
      farmlandDevices = <FarmDevices>[];
      json['farmland_devices'].forEach((v) {
        farmlandDevices!.add(new FarmDevices.fromJson(v));
      });
    }
    if (json['block_devices'] != null) {
      blockDevices = <BlockDevices>[];
      json['block_devices'].forEach((v) {
        blockDevices!.add(new BlockDevices.fromJson(v));
      });
    }
    if (json['plot_devices'] != null) {
      plotDevices = <PlotDevices>[];
      json['plot_devices'].forEach((v) {
        plotDevices!.add(new PlotDevices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['farmerid'] = this.farmerid;
    data['farmername'] = this.farmername;
    data[' fieldmanager'] = this.fieldmanager;
    data[' fieldofficer'] = this.fieldofficer;
    if (this.farmlandDevices != null) {
      data['farmland_devices'] =
          this.farmlandDevices!.map((v) => v.toJson()).toList();
    }
    if (this.blockDevices != null) {
      data['block_devices'] = this.blockDevices!.map((v) => v.toJson()).toList();
    }
    if (this.plotDevices != null) {
      data['plot_devices'] = this.plotDevices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlotDevices {
  String? devicename;
  String? deviceid;
  double? latitude;
  double? longtitude;
  String? devicetype;
  String? farmersectiontype;

  PlotDevices(
      {this.devicename,
        this.deviceid,
        this.latitude,
        this.longtitude,
        this.devicetype,
        this.farmersectiontype});

  PlotDevices.fromJson(Map<String, dynamic> json) {
    devicename = json['devicename'];
    deviceid = json['deviceid'];
    latitude = json['latitude']??0.0;
    longtitude = json['longtitude']??0.0;
    devicetype = json['devicetype'];
    farmersectiontype = json['farmersectiontype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['devicename'] = this.devicename;
    data['deviceid'] = this.deviceid;
    data['latitude'] = this.latitude;
    data['longtitude'] = this.longtitude;
    data['devicetype'] = this.devicetype;
    data['farmersectiontype'] = this.farmersectiontype;
    return data;
  }

}
class FarmDevices {
  String? devicename;
  String? deviceid;
  double? latitude;
  double? longtitude;
  String? devicetype;
  String? farmersectiontype;

  FarmDevices(
      {this.devicename,
        this.deviceid,
        this.latitude,
        this.longtitude,
        this.devicetype,
        this.farmersectiontype});

  FarmDevices.fromJson(Map<String, dynamic> json) {
    devicename = json['devicename'];
    deviceid = json['deviceid'];
    latitude = json['latitude']?? 0.0;
    longtitude = json['longtitude']?? 0.0;
    devicetype = json['devicetype'];
    farmersectiontype = json['farmersectiontype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['devicename'] = this.devicename;
    data['deviceid'] = this.deviceid;
    data['latitude'] = this.latitude;
    data['longtitude'] = this.longtitude;
    data['devicetype'] = this.devicetype;
    data['farmersectiontype'] = this.farmersectiontype;
    return data;
  }

}
class BlockDevices {
  String? devicename;
  String? deviceid;
  double? latitude;
  double? longtitude;
  String? devicetype;
  String? farmersectiontype;

  BlockDevices(
      {this.devicename,
        this.deviceid,
        this.latitude,
        this.longtitude,
        this.devicetype,
        this.farmersectiontype});

  BlockDevices.fromJson(Map<String, dynamic> json) {
    devicename = json['devicename'];
    deviceid = json['deviceid'];
    latitude = json['latitude']??0.0;
    longtitude = json['longtitude']??0.0;
    devicetype = json['devicetype'];
    farmersectiontype = json['farmersectiontype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['devicename'] = this.devicename;
    data['deviceid'] = this.deviceid;
    data['latitude'] = this.latitude;
    data['longtitude'] = this.longtitude;
    data['devicetype'] = this.devicetype;
    data['farmersectiontype'] = this.farmersectiontype;
    return data;
  }

}