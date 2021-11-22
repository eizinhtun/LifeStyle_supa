// @dart=2.9
class Meter {
  String meterName;
  bool autoPay;
  bool selfScan;
  bool requiredMatchGPS;
  String latitude;
  String longitude;
  String joinDate;
  String insertDate;
  String lastDate;
  String dueDate;
  String readDate;
  String applyDate;
  String issueDate;
  String creditReason;
  int creditUnit;
  int creditAmount;
  String mainLedgerTitle;
  int id;
  String meterNo;
  String consumerName;
  bool billNeedModity;
  String mobile;
  String houseNo;
  String street;
  int transformerID;
  int categoryId;
  int mainLedgerId;
  String ledgerId;
  String ledgerPostFix;
  int feederID;
  int binderId;
  int groupId;
  String consumerType;
  String voltage;
  String ampere;
  String wattLoad;
  String manufacturerNo;
  String businessNo;
  String meterSerial;
  double horsePower;
  String multiplier;
  double percentage;
  double maintainenceCost;
  int chargePerUnit;
  double horsePowerCost;
  double allowedUnit;
  String rate;
  String currencyType;
  String excelFileName;
  bool isShowDebt;
  bool noLayer;
  int noOfRoom;
  String layerDescription;
  String layerRate;
  String layerAmount;
  int streetLightCost;
  String oldAccount;
  String poleNo;
  String tspEng;
  String tspMM;
  String customerId;
  int avageUseUnit;
  int lastReadUnit;
  String lastMonthRedUnit;

  String installPerson;
  double meterBill;
  String branchId;
  String categoryName;
  String block;
  bool outDemand;
  String terminalSeal;
  String coverSeal;
  String twinRightSeal;
  String twinLeftSeal;

  Meter(
      {this.meterName,
      this.autoPay,
      this.selfScan,
      this.requiredMatchGPS,
      this.latitude,
      this.longitude,
      this.creditReason,
      this.creditUnit,
      this.creditAmount,
      this.mainLedgerTitle,
      this.id,
      this.meterNo,
      this.consumerName,
      this.billNeedModity,
      this.mobile,
      this.houseNo,
      this.street,
      this.transformerID,
      this.categoryId,
      this.mainLedgerId,
      this.ledgerId,
      this.ledgerPostFix,
      this.feederID,
      this.binderId,
      this.groupId,
      this.consumerType,
      this.voltage,
      this.ampere,
      this.wattLoad,
      this.manufacturerNo,
      this.businessNo,
      this.meterSerial,
      this.joinDate,
      this.horsePower,
      this.multiplier,
      this.percentage,
      this.maintainenceCost,
      this.chargePerUnit,
      this.horsePowerCost,
      this.allowedUnit,
      this.rate,
      this.currencyType,
      this.excelFileName,
      this.insertDate,
      this.isShowDebt,
      this.noLayer,
      this.noOfRoom,
      this.layerDescription,
      this.layerRate,
      this.layerAmount,
      this.lastDate,
      this.dueDate,
      this.readDate,
      this.streetLightCost,
      this.oldAccount,
      this.poleNo,
      this.tspEng,
      this.tspMM,
      this.customerId,
      this.avageUseUnit,
      this.lastReadUnit,
      this.lastMonthRedUnit,
      this.applyDate,
      this.issueDate,
      this.installPerson,
      //  this.meterBill,
      this.branchId,
      this.categoryName,
      this.block,
      this.outDemand,
      this.terminalSeal,
      this.coverSeal,
      this.twinRightSeal,
      this.twinLeftSeal});

  Meter.fromJson(Map<String, dynamic> json) {
    meterName = json['meterName'] ?? "";
    autoPay = json['AutoPay'];
    selfScan = json['SelfScan'];
    requiredMatchGPS = json['RequiredMatchGPS'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    creditReason = json['CreditReason'];
    creditUnit = json['CreditUnit'];
    creditAmount = json['CreditAmount'];
    mainLedgerTitle = json['MainLedgerTitle'];
    id = json['Id'];
    meterNo = json['MeterNo'];
    consumerName = json['ConsumerName'];
    billNeedModity = json['BillNeedModity'];
    mobile = json['Mobile'];
    houseNo = json['HouseNo'];
    street = json['Street'];
    transformerID = json['TransformerID'];
    categoryId = json['CategoryId'];
    mainLedgerId = json['MainLedgerId'];
    ledgerId = json['LedgerId'];
    ledgerPostFix = json['LedgerPostFix'];
    feederID = json['FeederID'];
    binderId = json['BinderId'];
    groupId = json['GroupId'];
    consumerType = json['ConsumerType'];
    voltage = json['Voltage'];
    ampere = json['Ampere'];
    wattLoad = json['WattLoad'];
    manufacturerNo = json['ManufacturerNo'];
    businessNo = json['BusinessNo'];
    meterSerial = json['MeterSerial'];
    joinDate = json['JoinDate'];
    multiplier = json['Multiplier'];
    horsePower = double.parse(json['HorsePower'].toString());
    percentage = double.parse(json['Percentage'].toString());
    maintainenceCost = double.parse(json['MaintainenceCost'].toString());
    horsePowerCost = double.parse(json['HorsePowerCost'].toString());
    allowedUnit = double.parse(json['AllowedUnit'].toString());
    meterBill = double.parse(json['meterBill'].toString());
    chargePerUnit = json['ChargePerUnit'];

    rate = json['Rate'];
    currencyType = json['CurrencyType'];
    excelFileName = json['ExcelFileName'];
    insertDate = json['InsertDate'];
    isShowDebt = json['IsShowDebt'];
    noLayer = json['NoLayer'];
    noOfRoom = json['NoOfRoom'];
    layerDescription = json['LayerDescription'];
    layerRate = json['LayerRate'];
    layerAmount = json['LayerAmount'];
    lastDate = json['LastDate'];
    dueDate = json['DueDate'];
    readDate = json['ReadDate'];
    streetLightCost = json['StreetLightCost'];
    oldAccount = json['OldAccount'];
    poleNo = json['PoleNo'];
    tspEng = json['TspEng'];
    tspMM = json['TspMM'];
    customerId = json['CustomerId'];
    avageUseUnit = json['AvageUseUnit'];
    lastReadUnit = json['LastReadUnit'];
    lastMonthRedUnit = json['LastMonthRedUnit'];
    applyDate = json['ApplyDate'];
    issueDate = json['IssueDate'];
    installPerson = json['InstallPerson'];
    branchId = json['BranchId'];
    categoryName = json['CategoryName'];
    block = json['Block'];
    outDemand = json['OutDemand'];
    terminalSeal = json['TerminalSeal'];
    coverSeal = json['CoverSeal'];
    twinRightSeal = json['TwinRightSeal'];
    twinLeftSeal = json['TwinLeftSeal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['meterName'] = this.meterName;
    data['AutoPay'] = this.autoPay;
    data['SelfScan'] = this.selfScan;
    data['RequiredMatchGPS'] = this.requiredMatchGPS;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['CreditReason'] = this.creditReason;
    data['CreditUnit'] = this.creditUnit;
    data['CreditAmount'] = this.creditAmount;
    data['MainLedgerTitle'] = this.mainLedgerTitle;
    data['Id'] = this.id;
    data['MeterNo'] = this.meterNo;
    data['ConsumerName'] = this.consumerName;
    data['BillNeedModity'] = this.billNeedModity;
    data['Mobile'] = this.mobile;
    data['HouseNo'] = this.houseNo;
    data['Street'] = this.street;
    data['TransformerID'] = this.transformerID;
    data['CategoryId'] = this.categoryId;
    data['MainLedgerId'] = this.mainLedgerId;
    data['LedgerId'] = this.ledgerId;
    data['LedgerPostFix'] = this.ledgerPostFix;
    data['FeederID'] = this.feederID;
    data['BinderId'] = this.binderId;
    data['GroupId'] = this.groupId;
    data['ConsumerType'] = this.consumerType;
    data['Voltage'] = this.voltage;
    data['Ampere'] = this.ampere;
    data['WattLoad'] = this.wattLoad;
    data['ManufacturerNo'] = this.manufacturerNo;
    data['BusinessNo'] = this.businessNo;
    data['MeterSerial'] = this.meterSerial;
    data['JoinDate'] = this.joinDate;
    data['HorsePower'] = this.horsePower;
    data['Multiplier'] = this.multiplier;
    data['Percentage'] = this.percentage;
    data['MaintainenceCost'] = this.maintainenceCost;
    data['ChargePerUnit'] = this.chargePerUnit;
    data['HorsePowerCost'] = this.horsePowerCost;
    data['AllowedUnit'] = this.allowedUnit;
    data['Rate'] = this.rate;
    data['CurrencyType'] = this.currencyType;
    data['ExcelFileName'] = this.excelFileName;
    data['InsertDate'] = this.insertDate;
    data['IsShowDebt'] = this.isShowDebt;
    data['NoLayer'] = this.noLayer;
    data['NoOfRoom'] = this.noOfRoom;
    data['LayerDescription'] = this.layerDescription;
    data['LayerRate'] = this.layerRate;
    data['LayerAmount'] = this.layerAmount;
    data['LastDate'] = this.lastDate;
    data['DueDate'] = this.dueDate;
    data['ReadDate'] = this.readDate;
    data['StreetLightCost'] = this.streetLightCost;
    data['OldAccount'] = this.oldAccount;
    data['PoleNo'] = this.poleNo;
    data['TspEng'] = this.tspEng;
    data['TspMM'] = this.tspMM;
    data['CustomerId'] = this.customerId;
    data['AvageUseUnit'] = this.avageUseUnit;
    data['LastReadUnit'] = this.lastReadUnit;
    data['LastMonthRedUnit'] = this.lastMonthRedUnit;
    data['ApplyDate'] = this.applyDate;
    data['IssueDate'] = this.issueDate;
    data['InstallPerson'] = this.installPerson;

    // data['meterBill'] = this.meterBill;
    data['BranchId'] = this.branchId;
    data['CategoryName'] = this.categoryName;
    data['Block'] = this.block;
    data['OutDemand'] = this.outDemand;
    data['TerminalSeal'] = this.terminalSeal;
    data['CoverSeal'] = this.coverSeal;
    data['TwinRightSeal'] = this.twinRightSeal;
    data['TwinLeftSeal'] = this.twinLeftSeal;
    return data;
  }
}
