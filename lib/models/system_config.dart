// @dart=2.9
class SystemConfig {
  bool introAutoSkip = true;
  int introDisplaySec = 10;
  bool onMeterUploadFunc = true;
  String payMeterBillVideoLink;
  String topupVideoLink;
  String uploadMeterVideoLink;
  String withdrawVideoLink;

  SystemConfig(
      {this.introAutoSkip,
      this.introDisplaySec,
      this.onMeterUploadFunc,
      this.payMeterBillVideoLink,
      this.topupVideoLink,
      this.uploadMeterVideoLink,
      this.withdrawVideoLink});

  SystemConfig.fromJson(Map<String, dynamic> json) {
    introAutoSkip = json['intro_auto_skip'];
    introDisplaySec = json['intro_display_sec'];
    onMeterUploadFunc = json['on_meter_upload_func'];
    payMeterBillVideoLink = json['pay_meter_bill_video_link'];
    topupVideoLink = json['topup_video_link'];
    uploadMeterVideoLink = json['upload_meter_video_link'];
    withdrawVideoLink = json['withdraw_video_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intro_auto_skip'] = this.introAutoSkip;
    data['intro_display_sec'] = this.introDisplaySec;
    data['on_meter_upload_func'] = this.onMeterUploadFunc;
    data['pay_meter_bill_video_link'] = this.payMeterBillVideoLink;
    data['topup_video_link'] = this.topupVideoLink;
    data['upload_meter_video_link'] = this.uploadMeterVideoLink;
    data['withdraw_video_link'] = this.withdrawVideoLink;
    return data;
  }
}
