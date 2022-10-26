class Devicequerry {
  String? iD;
  String? deviceID;
  String? applicationID;
  String? hardwareSerialNumber;
  String? batteryMV;
  String? firmwareVersion;
  String? soilMoistureLevelAGL4;
  String? soilMoistureLevelAGL3;
  String? soilMoistureLevelAGL2;
  String? soilMoistureLevelAGL1;
  String? soilMoistureLevelBGL1;
  String? soilMoistureLevelBGL2;
  String? soilMoistureLevelBGL3;
  String? soilMoistureLevelBGL4;
  String? soilMoistureLevelBGL5;
  String? soilMoistureLevelBGL6;
  String? soilMoistureLevelBGL7;
  String? soilMoistureLevelBGL8;
  String? sensorDataPacketDateTime;
  String? sensorFrequency;
  String? sensorBandWidth;
  String? spreadingFactor;
  String? gateWayID;
  String? gateWayRSSI;
  String? gateWaySNR;
  String? gateWayDateTime;
  String? packetReceivedAtDateTime;
  String? consumedAirTime;
  String? aVI1Voltage;
  String? aVI2Voltage;
  String? operatingMode;
  String? waterPressureKPA;
  String? waterPressureMPA;
  String? aCI1MilliAmps;
  String? aCI2MilliAmps;
  String? dI1Status;
  String? dI2Status;
  String? dO1Status;
  String? dO2Status;
  String ?CH4_PPM;
  String? hardwareMode;
  String? rO1Status;
  String? rO2Status;
  String? workingMode;
  String? fTemperature;
  String? fHumidity;
  String? fDistance;
  String? sensorFlag;
  String? tempCDS18B20;
  String? waterFlowTickLiters;
  String? waterFlowCount;
  String? soilMoisterPercentage;
  String? createDate;
  String ?InterruptFlag;
  String? soilMoistureSinglePoStringSensor;
  String ? devicetype;
  String? radiationWM2;
  String? rainMM;
  String? windDirectionDegree;
  String? windSpeedKmHr;
  String? latitude;
  String? longitude;
  String? currentB;
  String? currentR;
  String? currentY;
  String? kvah;
  String? powerFactor;
  String? voltageB;
  String? voltageR;
  String? voltageY;
  String? EMFREQUENCY;
  String? altitude;
  String? xTTSDomain;
  String? xWAWSUnencodedUrl;
  String? disguisedHost;
  String ?CO2_PPM;
  String? deploymentID;
  String? hostname;
  String? dO3Status;

  String? dI3Status;

  Devicequerry(
      {this.iD,
        this.deviceID,
        this.applicationID,
        this.hardwareSerialNumber,
        this.batteryMV,
        this.currentB,
        this.currentR,
        this.currentY,
        this.kvah,
        this.CH4_PPM,
        this.powerFactor,
        this.voltageB,
        this.CO2_PPM,
        this.voltageR,
        this.voltageY,
        this.firmwareVersion,
        this.soilMoistureLevelAGL4,
        this.soilMoistureLevelAGL3,
        this.soilMoistureLevelAGL2,
        this.soilMoistureLevelAGL1,
        this.soilMoistureLevelBGL1,
        this.soilMoistureLevelBGL2,
        this.soilMoistureLevelBGL3,
        this.EMFREQUENCY,
        this.soilMoistureLevelBGL4,
        this.soilMoistureLevelBGL5,
        this.soilMoistureLevelBGL6,
        this.soilMoistureLevelBGL7,
        this.soilMoistureLevelBGL8,
        this.sensorDataPacketDateTime,
        this.sensorFrequency,
        this.sensorBandWidth,
        this.spreadingFactor,
        this.gateWayID,
        this.gateWayRSSI,
        this.gateWaySNR,
        this.gateWayDateTime,
        this.packetReceivedAtDateTime,
        this.consumedAirTime,
        this.aVI1Voltage,
        this.aVI2Voltage,
        this.operatingMode,
        this.waterPressureKPA,
        this.waterPressureMPA,
        this.aCI1MilliAmps,
        this.aCI2MilliAmps,
        this.dI1Status,
        this.dI2Status,
        this.dO1Status,
        this.dO2Status,
        this.hardwareMode,
        this.rO1Status,
        this.rO2Status,
        this.workingMode,
        this.fTemperature,
        this.fHumidity,
        this.fDistance,
        this.sensorFlag,
        this.tempCDS18B20,
        this.waterFlowTickLiters,
        this.waterFlowCount,
        this.soilMoisterPercentage,
        this.createDate,
        this.InterruptFlag,
        this.soilMoistureSinglePoStringSensor,
        this.radiationWM2,
        this.rainMM,
        this.windDirectionDegree,
        this.windSpeedKmHr,
        this.latitude,
        this.longitude,
        this.altitude,
        this.xTTSDomain,
        this.xWAWSUnencodedUrl,
        this.disguisedHost,
        this.deploymentID,
        this.hostname,
        this.dO3Status,
        this.devicetype,
        this.dI3Status});

  Devicequerry.fromJson(Map<String, dynamic> json) {
    iD = json['ID'].toString();
    deviceID = json['deviceID'].toString();
    applicationID = json['ApplicationID'].toString();
    hardwareSerialNumber = json['HardwareSerialNumber'].toString();
    batteryMV = json['BatteryMV'].toString();
    devicetype     =json["Devicetype"].toString();
    firmwareVersion = json['FirmwareVersion'].toString();
    soilMoistureLevelAGL4 = json['SoilMoistureLevelAGL4'].toString();
    CH4_PPM=json['CH4_PPM'].toString();
    CO2_PPM=json['CO2_PPM'].toString();
    soilMoistureLevelAGL3 = json['SoilMoistureLevelAGL3'].toString();
    soilMoistureLevelAGL2 = json['SoilMoistureLevelAGL2'].toString();
    soilMoistureLevelAGL1 = json['SoilMoistureLevelAGL1'].toString();
    soilMoistureLevelBGL1 = json['SoilMoistureLevelBGL1'].toString();
    soilMoistureLevelBGL2 = json['SoilMoistureLevelBGL2'].toString();
    soilMoistureLevelBGL3 = json['SoilMoistureLevelBGL3'].toString();
    soilMoistureLevelBGL4 = json['SoilMoistureLevelBGL4'].toString();
    soilMoistureLevelBGL5 = json['SoilMoistureLevelBGL5'].toString();
    soilMoistureLevelBGL6 = json['SoilMoistureLevelBGL6'].toString();
    soilMoistureLevelBGL7 = json['SoilMoistureLevelBGL7'].toString();
    soilMoistureLevelBGL8 = json['SoilMoistureLevelBGL8'].toString();
    sensorDataPacketDateTime = json['SensorDataPacketDateTime'].toString();
    InterruptFlag=json['InterruptFlag'].toString();
    currentB = json['currentB'].toString();
    currentR =json['currentR'].toString();
    currentY = json['currentY'].toString();
    EMFREQUENCY=json['EMFREQUENCY'].toString();
    kvah = json['kvah'].toString();
    powerFactor = json['powerFactor'].toString();
    voltageB = json['VoltageB'].toString();
    voltageR = json['VoltageR'].toString();
    voltageY = json['VoltageY'].toString();
    sensorFrequency = json['SensorFrequency'].toString();
    sensorBandWidth = json['SensorBandWidth'].toString();
    spreadingFactor = json['SpreadingFactor'].toString();
    gateWayID = json['GateWayID'].toString();
    gateWayRSSI = json['GateWayRSSI'].toString();
    gateWaySNR = json['GateWaySNR'].toString();
    gateWayDateTime = json['GateWayDateTime'].toString();
    packetReceivedAtDateTime = json['PacketReceivedAtDateTime'].toString();
    consumedAirTime = json['ConsumedAirTime'].toString();
    aVI1Voltage = json['AVI1Voltage'].toString();
    aVI2Voltage = json['AVI2Voltage'].toString();
    operatingMode = json['OperatingMode'].toString();
    waterPressureKPA = json['WaterPressureKPA'].toString();
    waterPressureMPA = json['WaterPressureMPA'].toString();
    aCI1MilliAmps = json['ACI1_MilliAmps'].toString();
    aCI2MilliAmps = json['ACI2_MilliAmps'].toString();
    dI1Status = json['DI1Status'].toString();
    dI2Status = json['DI2Status'].toString();
    dO1Status = json['DO1Status'].toString();
    dO2Status = json['DO2Status'].toString();
    hardwareMode = json['HardwareMode'].toString();
    rO1Status = json['RO1Status'].toString();
    rO2Status = json['RO2Status'].toString();
    workingMode = json['WorkingMode'].toString();
    fTemperature = json['fTemperature'].toString();
    fHumidity = json['fHumidity'].toString();
    fDistance = json['fDistance'].toString();
    sensorFlag = json['SensorFlag'].toString();
    tempCDS18B20 = json['TempC_DS18B20'].toString();
    waterFlowTickLiters = json['WaterFlowTickLiters'].toString();
    waterFlowCount = json['WaterFlowCount'].toString();
    soilMoisterPercentage = json['SoilMoisterPercentage'].toString();
    createDate = json['CreateDate'].toString();
    soilMoistureSinglePoStringSensor = json['SoilMoistureSinglePointSensor'].toString();
    radiationWM2 = json['RadiationWM2'].toString();
    rainMM = json['RainMM'].toString();
    windDirectionDegree = json['WindDirectionDegree'].toString();
    windSpeedKmHr = json['WindSpeedKmHr'].toString();
    latitude = json['Latitude'].toString();
    longitude = json['Longitude'].toString();
    altitude = json['Altitude'].toString();
    xTTSDomain = json['XTTSDomain'].toString();
    xWAWSUnencodedUrl = json['X_WAWSUnencodedUrl'].toString();
    disguisedHost = json['DisguisedHost'].toString();
    deploymentID = json['DeploymentID'].toString();
    hostname = json['Hostname'].toString();
    dO3Status = json['DO3Status'].toString();
    dI3Status = json['DI3Status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['deviceID'] = this.deviceID;
    data['ApplicationID'] = this.applicationID;
    data['HardwareSerialNumber'] = this.hardwareSerialNumber;
    data['BatteryMV'] = this.batteryMV;
    data['FirmwareVersion'] = this.firmwareVersion;
    data['SoilMoistureLevelAGL4'] = this.soilMoistureLevelAGL4;
    data['SoilMoistureLevelAGL3'] = this.soilMoistureLevelAGL3;
    data['SoilMoistureLevelAGL2'] = this.soilMoistureLevelAGL2;
    data['SoilMoistureLevelAGL1'] = this.soilMoistureLevelAGL1;
    data['SoilMoistureLevelBGL1'] = this.soilMoistureLevelBGL1;
    data['SoilMoistureLevelBGL2'] = this.soilMoistureLevelBGL2;
    data['SoilMoistureLevelBGL3'] = this.soilMoistureLevelBGL3;
    data['SoilMoistureLevelBGL4'] = this.soilMoistureLevelBGL4;
    data['SoilMoistureLevelBGL5'] = this.soilMoistureLevelBGL5;
    data['SoilMoistureLevelBGL6'] = this.soilMoistureLevelBGL6;
    data['SoilMoistureLevelBGL7'] = this.soilMoistureLevelBGL7;
    data['SoilMoistureLevelBGL8'] = this.soilMoistureLevelBGL8;
    data['SensorDataPacketDateTime'] = this.sensorDataPacketDateTime;
    data['SensorFrequency'] = this.sensorFrequency;
    data['SensorBandWidth'] = this.sensorBandWidth;
    data['SpreadingFactor'] = this.spreadingFactor;
    data['GateWayID'] = this.gateWayID;
    data['GateWayRSSI'] = this.gateWayRSSI;
    data['GateWaySNR'] = this.gateWaySNR;
    data['GateWayDateTime'] = this.gateWayDateTime;
    data['PacketReceivedAtDateTime'] = this.packetReceivedAtDateTime;
    data['ConsumedAirTime'] = this.consumedAirTime;
    data['AVI1Voltage'] = this.aVI1Voltage;
    data['AVI2Voltage'] = this.aVI2Voltage;
    data['OperatingMode'] = this.operatingMode;
    data['WaterPressureKPA'] = this.waterPressureKPA;
    data['WaterPressureMPA'] = this.waterPressureMPA;
    data['ACI1_MilliAmps'] = this.aCI1MilliAmps;
    data['ACI2_MilliAmps'] = this.aCI2MilliAmps;
    data['DI1Status'] = this.dI1Status;
    data['DI2Status'] = this.dI2Status;
    data['DO1Status'] = this.dO1Status;
    data['DO2Status'] = this.dO2Status;
    data['HardwareMode'] = this.hardwareMode;
    data['RO1Status'] = this.rO1Status;
    data['RO2Status'] = this.rO2Status;
    data['WorkingMode'] = this.workingMode;
    data['fTemperature'] = this.fTemperature;
    data['fHumidity'] = this.fHumidity;
    data['fDistance'] = this.fDistance;
    data['SensorFlag'] = this.sensorFlag;
    data['TempC_DS18B20'] = this.tempCDS18B20;
    data['WaterFlowTickLiters'] = this.waterFlowTickLiters;
    data['WaterFlowCount'] = this.waterFlowCount;
    data['SoilMoisterPercentage'] = this.soilMoisterPercentage;
    data['CreateDate'] = this.createDate;
    data['SoilMoistureSinglePoStringSensor'] = this.soilMoistureSinglePoStringSensor;
    data['RadiationWM2'] = this.radiationWM2;
    data['RainMM'] = this.rainMM;
    data['WindDirectionDegree'] = this.windDirectionDegree;
    data['WindSpeedKmHr'] = this.windSpeedKmHr;
    data['Latitude'] = this.latitude??0.0;
    data['Longitude'] = this.longitude??0.0;
    data['Altitude'] = this.altitude??0.0;
    data['XTTSDomain'] = this.xTTSDomain;
    data['X_WAWSUnencodedUrl'] = this.xWAWSUnencodedUrl;
    data['DisguisedHost'] = this.disguisedHost;
    data['DeploymentID'] = this.deploymentID;
    data['Hostname'] = this.hostname;
    data['DO3Status'] = this.dO3Status;
    data['DI3Status'] = this.dI3Status;
    return data;
  }
}