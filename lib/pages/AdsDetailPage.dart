// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/Ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_html/flutter_html.dart';

class AdsDetailPage extends StatefulWidget {
  AdsDetailPage({Key key, @required this.id}) : super(key: key);
  final String id;

  @override
  _AdsDetailPage createState() => new _AdsDetailPage();
}

class _AdsDetailPage extends State<AdsDetailPage> {
  Ads model;

  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Container(
              margin: EdgeInsets.only(right: 40),
              child: Text(Tran.of(context).text("helloword").toString())),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF001950),
              Color(0xFF04205a),
              Color(0xFF0b2b6a),
              Color(0xFF0b2b6a),
              Color(0xFF2253a2),
              Color(0xFF2253a2)
            ],
          )),
        ),
      ),
      body: loading
          ? Center(
              child: SpinKitChasingDots(
                color: Theme.of(context).primaryColor,
              ),
            )
          : new Container(
              margin: EdgeInsets.only(top: 0.0, right: 0, left: 0),
              padding:
                  EdgeInsets.only(bottom: 20.0, left: 10, right: 10, top: 20),
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Html(
                  data: "<strong>" +
                      model.name +
                      "</br></br></strong>" +
                      model.content,
                  /* style: {
        "table": Style(
          backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
        ),
        "tr": Style(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        "th": Style(
          padding: EdgeInsets.all(6),
          backgroundColor: Colors.grey,
        ),
        "td": Style(
          padding: EdgeInsets.all(6),
          alignment: Alignment.topLeft,
        ),
        'h5': Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
      },
      customRender: {
        "table": (context, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:
            (context.tree as TableLayoutElement).toWidget(context),
          );
        },
        "bird": (RenderContext context, Widget child) {
          return TextSpan(text: "🐦");
        },
        "flutter": (RenderContext context, Widget child) {
          return FlutterLogo(
            style: (context.tree.element.attributes['horizontal'] != null)
                ? FlutterLogoStyle.horizontal
                : FlutterLogoStyle.markOnly,
            textColor: context.style.color!,
            size: context.style.fontSize.size! * 5,
          );
        },
      },
      customImageRenders: {
        networkSourceMatcher(domains: ["flutter.dev"]):
            (context, attributes, element) {
          return FlutterLogo(size: 36);
        },
        networkSourceMatcher(domains: ["mydomain.com"]):
        networkImageRender(
          headers: {"Custom-Header": "some-value"},
          altWidget: (alt) => Text(alt ?? ""),
          loadingWidget: () => Text("Loading..."),
        ),
        // On relative paths starting with /wiki, prefix with a base url
            (attr, _) =>
        attr["src"] != null && attr["src"].startsWith("/wiki"):
        networkImageRender(
            mapUrl: (url) => "https://upload.wikimedia.org" + url!),
        // Custom placeholder image for broken links
        networkSourceMatcher():
        networkImageRender(altWidget: (_) => FlutterLogo()),
      },
      onLinkTap: (url, _, __, ___) {
        //print("Opening $url...");
      },
      onImageTap: (src, _, __, ___) {
        //print(src);
      },
      onImageError: (exception, stackTrace) {
        //print(exception);
      },
      onCssParseError: (css, messages) {
        //print("css that errored: $css");
        //print("error messages:");
        messages.forEach((element) {
          //print(element);
        });
      },*/
                ),
              ),
            ),
    );
  }
}
