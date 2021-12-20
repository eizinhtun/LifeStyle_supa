// @dart=2.9
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:left_style/widgets/code_Invoicepainter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/meter_bill_model.dart';
import 'package:left_style/pages/pay_bill_page.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image/image.dart' as Img;

class MeterBillDetailPage extends StatefulWidget {
  final String docId;

  const MeterBillDetailPage({Key key, this.docId}) : super(key: key);

  @override
  MeterBillDetailPageState createState() => MeterBillDetailPageState();
}

class MeterBillDetailPageState extends State<MeterBillDetailPage> {
  final db = FirebaseFirestore.instance;
  MeterBill bill = MeterBill();
  double x, y = 0;
  String meterName = "";

  @override
  void initState() {
    super.initState();
  }

  Future<String> getMeterName(MeterBill bill) async {
    firstLaod = false;
    await FirebaseFirestore.instance
        .collection(meterCollection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(userMeterCollection)
        .doc(bill.customerId)
        .get(GetOptions(source: Source.server))
        .then((value) {
      if (value.data() != null) {
        setState(() {});
        meterName = value.data()["meterName"];
        return meterName;
      }
    });
    return meterName;
  }

  Future<bool> checkEnableBtn(MeterBill bill) async {
    firstLaod = false;
    if (bill != null && !bill.isPaid) {
      DateTime now = DateTime.now();
      DateTime currentDate = DateTime(now.year, now.month, now.day);
      Timestamp currentDateTimeStamp = Timestamp.fromDate(currentDate);
      bool overDue = bill.dueDate.toDate().isBefore(currentDate);
      if (!overDue) {
        enablePaid = true;

        return enablePaid;
      }

      await FirebaseFirestore.instance
          .collection(meterBillsCollection)
          .where(
            "customerId",
            isEqualTo: bill.customerId,
          )
          // .where("dueDate", isEqualTo: tempTimeStamp)
          .where("dueDate", isLessThan: currentDateTimeStamp)
          .orderBy("dueDate", descending: true)
          .limit(1)
          .get(GetOptions(source: Source.server))
          .then((value) {
        value.docs.forEach((result) {
          enablePaid = result.id == widget.docId;
          setState(() {});
          return enablePaid;
        });
      });
    }
    enablePaid = false;
    return enablePaid;
  }

  TextStyle getTextStyle() {
    //
    return TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: ScreenUtil().setSp(10),
        fontFamily: "myanmar3");
  }

  BuildContext _context;
  Widget _buildItem(
    rowIndex,
    colIndex,
    columSpan,
    text,
  ) {
    return GridPlacement(
      rowStart: rowIndex,
      columnStart: colIndex,
      columnSpan: columSpan,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(_context).size.width,
        // height: ScreenUtil().setSp(100),
        margin: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Text(text, textAlign: TextAlign.center, style: getTextStyle()),
        padding: const EdgeInsets.all(0),
      ),
    );
  }

  //Widget getInvoice(Consumer consumer,bool loadingConsumer){

  bool enablePaid = false;
  bool firstLaod = true;

  @override
  Widget build(BuildContext context) {
    _context = context;

    // isPaid = widget.isPaid;
    return StreamBuilder<DocumentSnapshot>(
        stream:
            db.collection(meterBillsCollection).doc(widget.docId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.exists) {
            bill =
                MeterBill.fromJson(snapshot.data.data(), meterName: meterName);

            meterNo = bill.meterNo;
            if (firstLaod) {
              checkEnableBtn(bill);
              getMeterName(bill);
            }

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0.0,
                centerTitle: true,
                title: Text(Tran.of(context).text("my_meter_bill").toString()),
                actions: [
                  IconButton(
                    onPressed: () async {
                      await shareImage(context);
                    },
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              body: InteractiveViewer(
                constrained: false,
                scaleEnabled: true,
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.all(0),
                    // width: double.infinity,
                    // width: ScreenUtil().setSp(900),
                    // height: ScreenUtil().setSp(900),
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,

                    //height:ScreenUtil().setSp(2100),//
                    // padding: const EdgeInsets.only(
                    //     top: 10.0, left: 8.0, right: 10.0, bottom: 0.0),
                    child: Stack(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 0.0),
                          child: Column(
                            children: [
                              RepaintBoundary(
                                key: _globalKey,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'လျှပ်စစ်နှင့်စွမ်းအင်ဝန်ကြီးဌာန',
                                        style: getTextStyle(),
                                      ),
                                      Text(
                                        'လျှပ်စစ်ဓာတ်အားဖြန့်ဖြူးရေးလုပ်ငန်း',
                                        style: getTextStyle(),
                                      ),
                                      Text('ဓာတ်အားခတောင်းခံလွှာ',
                                          style: getTextStyle()),
                                      Text(
                                          Tran.of(context).text("used") +
                                              ": " +
                                              bill.monthName +
                                              " " +
                                              Tran.of(context)
                                                  .text("last_date") +
                                              ": " +
                                              Formatter.getDate(
                                                  bill.dueDate.toDate()) +
                                              "",
                                          style: getTextStyle()),
                                      Text(
                                          bill.companyName +
                                              '   လျှပ်စစ်ပုံစံ(၂၄၃)',
                                          style: getTextStyle()),
                                      // Text('',style: TextStyle(fontWeight: FontWeight.w900),),
                                      //  Text(' '),

                                      SizedBox(
                                        width: ScreenUtil().setSp(900),
                                        //// 360.0,//double.infinity,jake
                                        // height: ScreenUtil().setSp(960,allowFontScalingSelf:false),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(bill.state,
                                                    style: getTextStyle()),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  "အမည်- " +
                                                      bill.consumerName +
                                                      " ( " +
                                                      meterName +
                                                      " )",
                                                  style: getTextStyle(),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5, bottom: 8),
                                                child: Text(
                                                  "လိပ်စာ- " +
                                                      (bill.block == null
                                                          ? ""
                                                          : bill.block) +
                                                      " " +
                                                      (bill.street == null
                                                          ? ""
                                                          : bill.street),
                                                  style: getTextStyle(),
                                                ),
                                              ),
                                            ),
                                            LayoutGrid(
                                              columnGap: 0,
                                              rowGap: 0,
                                              columnSizes: [
                                                FlexibleTrackSize(1),
                                                FlexibleTrackSize(0.9),
                                                FlexibleTrackSize(1.1),
                                                FlexibleTrackSize(0.65),
                                              ],
                                              rowSizes: [
                                                FixedTrackSize(32),
                                                FixedTrackSize(32),
                                                FixedTrackSize(32),
                                                FixedTrackSize(32),
                                                FixedTrackSize(32),
                                                FixedTrackSize(32),
                                                FixedTrackSize(32),
                                                FixedTrackSize(32),
                                                FixedTrackSize(32),
                                                FixedTrackSize(32),
                                                FixedTrackSize(32),
                                                //                      FixedTrackSize(32),
                                                //                      FixedTrackSize(32),
                                                //                      FixedTrackSize(32),
                                                //                      FixedTrackSize(32),
                                                //                      FixedTrackSize(32),
                                                //                      FixedTrackSize(32),
                                                //                      FixedTrackSize(32),
                                                //                      FixedTrackSize(32),
                                                //                      FixedTrackSize(32),
                                                //                      FixedTrackSize(32),
                                                //                      FixedTrackSize(32),
                                              ],
                                              children: [
                                                _buildItem(
                                                    0, 0, 1, "ငွေစာရင်းအမှတ်"),
                                                _buildItem(
                                                    0,
                                                    1,
                                                    1,
                                                    bill.ledgerNo +
                                                        "/" +
                                                        bill.ledgerPostFix),
                                                _buildItem(
                                                    0, 2, 1, "နှုန်းထား"),
                                                _buildItem(0, 3, 1, "သင့်ငွေ"),
                                                _buildItem(1, 0, 1, "နှုန်း"),
                                                _buildItem(
                                                    1,
                                                    1,
                                                    1,
                                                    bill.mainLedgerTitle
                                                        .toString()),
                                                _buildItem(
                                                    1,
                                                    2,
                                                    1,
                                                    "(" +
                                                        bill.layerDes1
                                                            .toString() +
                                                        ")" +
                                                        bill.layerRate1
                                                            .toString()
                                                            .replaceAll(
                                                                ".0", "")),
                                                _buildItem(
                                                    1,
                                                    3,
                                                    1,
                                                    bill.layerAmount1
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(
                                                    2, 0, 1, "မီတာအမှတ်"),
                                                _buildItem(
                                                    2, 1, 1, bill.meterNo),
                                                _buildItem(
                                                    2,
                                                    2,
                                                    1,
                                                    "(" +
                                                        bill.layerDes2
                                                            .toString() +
                                                        ")" +
                                                        bill.layerRate2
                                                            .toString()
                                                            .replaceAll(
                                                                ".0", "")),
                                                _buildItem(
                                                    2,
                                                    3,
                                                    1,
                                                    bill.layerAmount2
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(
                                                    3, 0, 1, "ယခင်လဖတ်ချက်"),
                                                _buildItem(
                                                    3,
                                                    1,
                                                    1,
                                                    bill.oldUnit
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(
                                                    3,
                                                    2,
                                                    1,
                                                    "(" +
                                                        bill.layerDes3
                                                            .toString() +
                                                        ")" +
                                                        bill.layerRate3
                                                            .toString()
                                                            .replaceAll(
                                                                ".0", "")),
                                                _buildItem(
                                                    3,
                                                    3,
                                                    1,
                                                    bill.layerAmount3
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(
                                                    4, 0, 1, "ယခုလဖတ်ချက်"),
                                                _buildItem(
                                                    4,
                                                    1,
                                                    1,
                                                    bill.readUnit
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(
                                                    4,
                                                    2,
                                                    1,
                                                    "(" +
                                                        bill.layerDes4
                                                            .toString() +
                                                        ")" +
                                                        bill.layerRate4
                                                            .toString()
                                                            .replaceAll(
                                                                ".0", "")),
                                                _buildItem(
                                                    4,
                                                    3,
                                                    1,
                                                    bill.layerAmount4
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(
                                                    5, 0, 1, "ကွာခြားယူနစ်"),
                                                _buildItem(
                                                    5,
                                                    1,
                                                    1,
                                                    bill.totalUnitUsed
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(
                                                    5,
                                                    2,
                                                    1,
                                                    "(" +
                                                        bill.layerDes5
                                                            .toString() +
                                                        ")" +
                                                        bill.layerRate5
                                                            .toString()
                                                            .replaceAll(
                                                                ".0", "")),
                                                _buildItem(
                                                    5,
                                                    3,
                                                    1,
                                                    bill.layerAmount5
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(
                                                    6, 0, 1, "မြှောက်ကိန်း"),
                                                _buildItem(
                                                    6,
                                                    1,
                                                    1,
                                                    (bill.multiplier == null ||
                                                            // ignore: unrelated_type_equality_checks
                                                            bill.multiplier ==
                                                                "")
                                                        ? ""
                                                        : bill.multiplier
                                                            .toString()
                                                            .replaceAll(
                                                                ".0", "")),
                                                _buildItem(
                                                    6,
                                                    2,
                                                    1,
                                                    "(" +
                                                        bill.layerDes6
                                                            .toString() +
                                                        ")" +
                                                        bill.layerRate6
                                                            .toString()
                                                            .replaceAll(
                                                                ".0", "")),
                                                _buildItem(
                                                    6,
                                                    3,
                                                    1,
                                                    bill.layerAmount6
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(
                                                    7, 0, 1, "ပေါင်းခြင်း"),
                                                _buildItem(
                                                    7,
                                                    1,
                                                    1,
                                                    bill.percentage
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(
                                                    7,
                                                    2,
                                                    1,
                                                    "(" +
                                                        bill.layerDes7
                                                            .toString() +
                                                        ")" +
                                                        bill.layerRate7
                                                            .toString()
                                                            .replaceAll(
                                                                ".0", "")),
                                                _buildItem(
                                                    7,
                                                    3,
                                                    1,
                                                    bill.layerAmount7
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(
                                                    8, 0, 1, "သုံးစွဲယူနစ်"),
                                                _buildItem(
                                                    8,
                                                    1,
                                                    1,
                                                    bill.unitsToPay
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(
                                                    8, 2, 1, "မြင်းကောင်ရေ"),
                                                _buildItem(
                                                    8,
                                                    3,
                                                    1,
                                                    bill.mHorsePower
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(9, 0, 1,
                                                    "ဓာတ်အားခစုစုပေါင်း"),
                                                _buildItem(
                                                    9,
                                                    1,
                                                    1,
                                                    bill.cost
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(
                                                    9, 2, 1, "မီတာဝန်ဆောင်ခ"),
                                                _buildItem(
                                                    9,
                                                    3,
                                                    1,
                                                    bill.mMaintenanceCost
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(10, 0, 1,
                                                    "မြင်းကောင်ရေကြေး"),
                                                _buildItem(
                                                    10,
                                                    1,
                                                    1,
                                                    bill.mHorsePowerCost
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                                _buildItem(10, 2, 1,
                                                    "ကျသင့်ငွေစုစုပေါင်း"),
                                                _buildItem(
                                                    10,
                                                    3,
                                                    1,
                                                    bill.totalCostOrg
                                                        .toString()
                                                        .replaceAll(".0", "")),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          bill.creditAmount == null ||
                                                  bill.creditAmount == 0
                                              ? Container()
                                              : Container(
                                                  alignment:
                                                      Alignment(1.0, 1.0),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0),
                                                  child: Text(
                                                    "ယခင်ကြွေးကျန်" +
                                                        bill.creditAmount
                                                            .toString(),
                                                    style: getTextStyle(),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                          bill.disscountAmt == null ||
                                                  bill.disscountAmt == 0
                                              ? Container()
                                              : Container(
                                                  alignment:
                                                      Alignment(1.0, 1.0),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0),
                                                  child: Text(
                                                    "ကင်းလွတ်ခွင့် " +
                                                        bill.disscountAmt
                                                            .toString()
                                                            .replaceAll(
                                                                ".0", ""),
                                                    style: getTextStyle(),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                          Container(
                                            alignment: Alignment(1.0, 1.0),
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text(
                                              "Total   " +
                                                  (((bill.creditAmount == null)
                                                              ? 0
                                                              : bill
                                                                  .creditAmount
                                                                  .toDouble()) +
                                                          bill.totalCost)
                                                      .toString()
                                                      .replaceAll(".0", ""),
                                              style: getTextStyle(),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Container(
                                        // height: 55.0,
                                        // width: 75.0,
                                        // color: Colors.red,
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        margin: const EdgeInsets.all(0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            bill.signUrl == null ||
                                                    bill.signUrl == ""
                                                ? Container()
                                                : Container(
                                                    height: 55.0,
                                                    width: 75.0,
                                                    child: CachedNetworkImage(
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      imageUrl: bill.signUrl,
                                                    ),
                                                  ),
                                            //Container( height:60.0,width:90.0, child: Image.network(StaticCompanyInfo.signUrl),),

                                            /// Text('လျှပ်စစ်ပုံစံ(၂၄၃)',style: getTextStyle()),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: BarCodeImage(
                                                params: Code39BarCodeParams(
                                                  bill.customerId,
                                                  lineWidth:
                                                      1.2, // width for a single black/white bar (default: 2.0)
                                                  barHeight:
                                                      50.0, // height for the entire widget (default: 100.0)
                                                  withText:
                                                      true, // Render with text label or not (default: false)
                                                ),
                                                onError: (error) {
                                                  // Error handler
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 16.0,
                                        ),
                                        child: Text(
                                            (bill.refundAmount != null &&
                                                        bill.refundAmount > 0
                                                    ? "စားရင်းညှိ  " +
                                                        bill.refundAmount
                                                            .toString() +
                                                        "   "
                                                    : " ") +
                                                "hotline: " +
                                                bill.hotline.toString(),
                                            style: getTextStyle()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              (bill.isPaid != null &&
                                      !bill.isPaid &&
                                      (bill.status != null) &&
                                      (bill.status == MeterBillStatus.paid))
                                  ? Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 8, 0, 0),
                                            child: Text(
                                              "Your meter bill payment is rejected. Please contact office.",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              //TODO
                                            },
                                            child: Text(
                                              Tran.of(context)
                                                  .text("contact_office"),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 70,
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: 70,
                                    ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 50,
                          child: getBillStatusWidget(bill),
                        ),
                        // Positioned(
                        //   top: 0,
                        //   right: 0,
                        //   child: IconButton(
                        //     onPressed: () async {
                        //      await shareImage(context);
                        //     },
                        //     icon: Icon(
                        //       Icons.share,
                        //       color: Theme.of(context).primaryColor,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton:

                  // (bill.isPaid != null &&
                  //         !bill.isPaid &&
                  //         (bill.status != null) &&
                  //         (bill.status == MeterBillStatus.unpaid))
                  //     ?
                  // (!bill.isPaid && (dueDate.isBefore(currentDate))) ||
                  //         bill.isPaid && bill.status == MeterBillStatus.paid
                  !enablePaid
                      ? Text("")
                      : OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            side: BorderSide(
                              width: 3.0,
                              color: Theme.of(context).primaryColor,
                              style: BorderStyle.solid,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PayBillPage(
                                    bill: bill, docId: widget.docId),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: Text(
                              Tran.of(context).text("pay_bill"),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0.0,
                centerTitle: true,
                title: Text(Tran.of(context).text("my_meter_bill").toString()),
              ),
              body: Center(
                child: SpinKitDoubleBounce(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0.0,
                centerTitle: true,
                title: Text(Tran.of(context).text("my_meter_bill").toString()),
              ),
              body: Center(
                child: Text(Tran.of(context).text("no_data")),
              ),
            );
          }
        });
  }

  final GlobalKey _globalKey = GlobalKey();
  String meterNo = "";

  Future<Uint8List> removeWhiteBackground(Uint8List bytes) async {
    Img.Image image = Img.decodeImage(bytes);
    Img.Image transparentImage = await colorTransparent(image, 255, 255, 255);
    var newPng = Img.encodePng(transparentImage);
    return newPng;
  }

  Future<Img.Image> colorTransparent(
      Img.Image src, int red, int green, int blue) async {
    var pixels = src.getBytes();
    for (int i = 0, len = pixels.length; i < len; i += 4) {
      if (pixels[i] == red && pixels[i + 1] == green && pixels[i + 2] == blue) {
        pixels[i + 3] = 0;
      }
    }

    return src;
  }

  Future<void> shareImage(BuildContext context) async {
    String fileName = "MeterBill-$meterNo.png";
    final RenderBox box = context.findRenderObject() as RenderBox;

    try {
      //extract bytes
      final RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      final ui.Image image = await boundary.toImage();
      Size size = Size(image.width.toDouble(), image.height.toDouble());
      final byteData = await CodeInvoicePainter(qrImage: image, margin: 2)
          .toImageData(size, format: ui.ImageByteFormat.png);

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final dir = (await getExternalStorageDirectory()).path;
      final String fullPath = '$dir/$fileName';
      File capturedFile = File(fullPath);
      await capturedFile.writeAsBytes(pngBytes);

      await Share.shareFiles([fullPath],
          text: Tran.of(context).text("my_meter_list"),
          sharePositionOrigin: box.localToGlobal(Offset.infinite) & box.size);
      //FlutterShareFile.share(fullPath, fileName, ShareFileType.image);
      // FlutterShareFile.share(dir.path, fileName, ShareFileType.image);

      // await FlutterShare.shareFile(
      //   title: 'Share',
      //   text: 'Choose file',
      //   filePath: fullPath,
      // );

      // final String dir = (await getApplicationDocumentsDirectory()).path;
      // final String fullPath = '$dir/${DateTime.now().millisecond}.png';
      // File capturedFile = File(fullPath);
      // await capturedFile.writeAsBytes(pngBytes);
      //

      // Share.shareFiles([fullPath],
      //       subject: "subject",
      //       sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);

    } catch (e) {}
  }

  Widget getBillStatusWidget(MeterBill bill) {
    if (bill.isPaid) {
      return Image.asset(
        "assets/image/paid_stamp.png",
        height: 40,
      );
    } else {
      if (bill.status == MeterBillStatus.paid) {
        return Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Icon(
            Icons.warning,
            color: Colors.red,
            size: 40,
          ),
        );
      } else {
        return Text("");
      }
    }
  }
}

///sharing platform
// enum Share {
//   facebook,
//   twitter,
//   whatsapp,
//   whatsapp_personal,
//   whatsapp_business,
//   share_system,
//   share_instagram,
//   share_telegram
// }
// void shareMe(){
//     final FlutterShareMe flutterShareMe = FlutterShareMe();
//     Share share = Share.facebook;
//     String response;
//     String msg =
//         'Flutter share is great!!\n Check out full example at https://pub.dev/packages/flutter_share_me';
//     String url = 'https://pub.dev/packages/flutter_share_me';
//     switch (share) {
//       case Share.facebook:
//         response = await flutterShareMe.shareToFacebook(url: url, msg: msg);
//         break;
//       case Share.twitter:
//         response = await flutterShareMe.shareToTwitter(url: url, msg: msg);
//         break;
//       // case Share.whatsapp:
//       //   if (file != null) {
//       //     response = await flutterShareMe.shareToWhatsApp(
//       //         imagePath: file!.path,
//       //         fileType: videoEnable ? FileType.video : FileType.image);
//       //   } else {
//       //     response = await flutterShareMe.shareToWhatsApp(msg: msg);
//       //   }
//       //   break;
//       case Share.whatsapp_business:
//         response = await flutterShareMe.shareToWhatsApp(msg: msg);
//         break;
//       case Share.share_system:
//         response = await flutterShareMe.shareToSystem(msg: msg);
//         break;
//       // case Share.whatsapp_personal:
//       //   response = await flutterShareMe.shareWhatsAppPersonalMessage(
//       //       message: msg, phoneNumber: 'phone-number-with-country-code');
//       //   break;
//       // case Share.share_instagram:
//       //   response = await flutterShareMe.shareToInstagram(imagePath: file!.path);
//       //   break;
//       // case Share.share_telegram:
//       //   response = await flutterShareMe.shareToTelegram(msg: msg);
//       //   break;
//     }
//     debugPrint(response);
// }
