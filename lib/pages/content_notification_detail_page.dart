// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/noti_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentNotificationDetailPage extends StatefulWidget {
  ContentNotificationDetailPage(
      {Key key, @required this.noti, @required this.status})
      : super(key: key);
  final NotiModel noti;
  final String status;

  @override
  _ContentNotificationDetailPage createState() =>
      _ContentNotificationDetailPage();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class _ContentNotificationDetailPage
    extends State<ContentNotificationDetailPage> {
  bool loading = true;
  String htmlData = "";

  @override
  void initState() {
    super.initState();
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    htmlData = widget.noti.content;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Notification Detail"),
        flexibleSpace: Container(
          decoration: BoxDecoration(color: mainColor),
        ),
      ),
      //widget.notification==null?Center(child: SpinKitChasingDots(color: sysData.mainColor,),):
      body: SingleChildScrollView(
        child: Html(
          data: htmlData,
          onLinkTap: (String url, RenderContext context,
              Map<String, String> attributes, dom.Element element) {
            _launchURL(url);
            //open URL in webview, or launch URL in browser, or any other logic here
          },
          style: {
            "table": Style(
              backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
            ),
            "tr": Style(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            "th": Style(
              padding: const EdgeInsets.all(6),
              backgroundColor: Colors.grey,
            ),
            "td": Style(
              padding: const EdgeInsets.all(6),
              alignment: Alignment.topLeft,
            ),
            'h5': Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
          },
          customRender: {
            "table": (context, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: (context.tree as TableLayoutElement).toWidget(context),
              );
            },
            "bird": (RenderContext context, Widget child) {
              return TextSpan(text: "🐦");
            },
            "flutter": (RenderContext context, Widget child) {
              return FlutterLogo(
                style: (context.tree.element?.attributes['horizontal'] != null)
                    ? FlutterLogoStyle.horizontal
                    : FlutterLogoStyle.markOnly,
                textColor: context.style.color,
                size: context.style.fontSize.size * 5,
              );
            },
          },
          customImageRenders: {
            networkSourceMatcher(domains: ["flutter.dev"]):
                (context, attributes, element) {
              return FlutterLogo(size: 36);
            },
            networkSourceMatcher(domains: ["mydomain.com"]): networkImageRender(
              headers: {"Custom-Header": "some-value"},
              altWidget: (alt) => Text(alt ?? ""),
              loadingWidget: () => Text("Loading..."),
            ),
            // On relative paths starting with /wiki, prefix with a base url
            (attr, _) => attr["src"] != null && attr["src"].startsWith("/wiki"):
                networkImageRender(
                    mapUrl: (url) => "https://upload.wikimedia.org" + url),
            // Custom placeholder image for broken links
            networkSourceMatcher():
                networkImageRender(altWidget: (_) => FlutterLogo()),
          },
          // onLinkTap: (url, _, __, ___) {
          //
          // },
          onImageTap: (src, _, __, ___) {},
          onImageError: (exception, stackTrace) {},
          onCssParseError: (css, messages) {
            String str = "";
            messages.forEach((s) {
              str += " " + s.message;
            });
            return str;
          },
        ),
      ),
    );
  }

  getTime(DateTime date) {
    var dateFormat = DateFormat("h:mm a");
    var result = dateFormat.format(date);
    return result;
  }
}
