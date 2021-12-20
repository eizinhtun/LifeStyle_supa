// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:left_style/models/intro_model.dart';
import 'package:left_style/providers/intro_provider.dart';

import 'package:provider/provider.dart';

class IntroScreenPage extends StatefulWidget {
  @override
  _IntroScreenPageState createState() => _IntroScreenPageState();
}

class _IntroScreenPageState extends State<IntroScreenPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  List<IntroModel> introList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    introList = await context.read<IntroProvider>().getIntros(context);
  }

  void _onIntroEnd(context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  Widget _buildFullscrenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    introList = context.watch<IntroProvider>().items;

    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return FutureBuilder<List<IntroModel>>(
        future: context.read<IntroProvider>().getIntros(context),
        builder: (context, AsyncSnapshot<List<IntroModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                  padding: EdgeInsets.only(top: 35),
                  color: Theme.of(context).primaryColor,
                  alignment: Alignment.center,
                  child: SpinKitFadingCircle(
                    color: Colors.white,
                  )),
            );
          } else if (snapshot.hasData) {
            return IntroductionScreen(
              key: introKey,
              globalBackgroundColor: Colors.white,
              // globalHeader: Align(
              //   alignment: Alignment.topRight,
              //   child: SafeArea(
              //     child: Padding(
              //       padding: const EdgeInsets.only(top: 16, right: 16),
              //       child: _buildImage('flutter.png', 100),
              //     ),
              //   ),
              // ),
              // globalFooter: SizedBox(
              //   width: double.infinity,
              //   height: 60,
              //   child: ElevatedButton(
              //     child: const Text(
              //       'Let\s go right away!',
              //       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              //     ),
              //     onPressed: () => _onIntroEnd(context),
              //   ),
              // ),
              pages: introList.map((ads) {
                return PageViewModel(
                  title: "Fractional shares",
                  body:
                      "Instead of having to buy an entire share, invest any amount you want.",
                  image: CachedNetworkImage(
                    httpHeaders: <String, String>{
                      "Access-Control-Allow-Origin": "*",
                    },
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    imageUrl: ads.imgUrl,
                    placeholder: (context, url) => SpinKitFadingCircle(
                      color: Colors.white,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  decoration: pageDecoration,
                );
              }).toList(),

              onDone: () => _onIntroEnd(context),
              //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
              showSkipButton: true,
              skipFlex: 0,
              nextFlex: 0,
              //rtl: true, // Display as right-to-left
              // skip: const Text('Skip'),
              // next: const Icon(Icons.arrow_forward),
              done: const Text('Done',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              curve: Curves.fastLinearToSlowEaseIn,
              controlsMargin: const EdgeInsets.all(16),
              controlsPadding: kIsWeb
                  ? const EdgeInsets.all(12.0)
                  : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
              dotsDecorator: const DotsDecorator(
                size: Size(10.0, 10.0),
                color: Color(0xFFBDBDBD),
                activeSize: Size(22.0, 10.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
              dotsContainerDecorator: const ShapeDecoration(
                color: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
