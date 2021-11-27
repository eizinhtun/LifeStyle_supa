// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:left_style/localization/translate.dart';

class IntroScreenPage extends StatelessWidget {
  IntroScreenPage({Key key, this.urlList}) : super(key: key);
  final List<String> urlList;
  final introKey = GlobalKey<IntroductionScreenState>();
  void _onIntroEnd(context) {
    Navigator.pop(context);
  }

  // Widget _buildFullscrenImage() {
  //   return Image.asset(
  //     'assets/fullscreen.jpg',
  //     fit: BoxFit.cover,
  //     height: double.infinity,
  //     width: double.infinity,
  //     alignment: Alignment.center,
  //   );
  // }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.network(assetName, width: width);
  }

  List<PageViewModel> pageList() {
    List<PageViewModel> list = [];
    if (urlList != null && urlList.length > 0) {
      for (var item in urlList) {
        list.add(
          PageViewModel(
            title: "",
            body: "",
            image: _buildImage(item),
            /* decoration:  PageDecoration(
             titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
             bodyTextStyle: TextStyle(fontSize: 19.0),
             descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
             pageColor: Colors.white,
             imagePadding: EdgeInsets.zero,
           ),*/

            decoration: PageDecoration(
              contentMargin: const EdgeInsets.symmetric(horizontal: 16),
              fullScreen: true,
              bodyFlex: 2,
              imageFlex: 3,
            ),
          ),
        );
      }
      return list;
    } else {
      list.add(
        PageViewModel(
          title: "",
          body: "",
          image: null,
          /* decoration:  PageDecoration(
             titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
             bodyTextStyle: TextStyle(fontSize: 19.0),
             descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
             pageColor: Colors.white,
             imagePadding: EdgeInsets.zero,
           ),*/

          decoration: PageDecoration(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
      );
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: ScrollController(),
      physics: ScrollPhysics(parent: PageScrollPhysics()),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            actions: [
              CloseButton(
                color: Colors.black,
              )
            ],
            leading: Container(),
          ),
        ];
      },
      body: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.transparent,

        globalFooter: Container(
          color: Colors.transparent,
          width: double.infinity,
          child: TextButton(
            child: Text(
              Tran.of(context).text("close"),
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            onPressed: () => _onIntroEnd(context),
          ),
        ),
        pages: pageList(),

        /*[
        PageViewModel(
          title: "",
          body:
          "",
          image: _buildImage('https://s29843.pcdn.co/blog/wp-content/uploads/sites/2/2019/12/remove-background-from-picture-768x576.png'),
          decoration: pageDecoration,

        ),
        PageViewModel(
          title: "Learn as you go",
          body:
          "Download the Stockpile app and master the market with our mini-lesson.",
          image: _buildImage('https://s29843.pcdn.co/blog/wp-content/uploads/sites/2/2019/12/remove-background-from-picture-768x576.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Kids and teens",
          body:
          "Kids and teens can track their stocks 24/7 and place trades that you approve.",
          image: _buildImage('https://s29843.pcdn.co/blog/wp-content/uploads/sites/2/2019/12/remove-background-from-picture-768x576.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Full Screen Page",
          body:
          "Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          image: _buildFullscrenImage(),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
        PageViewModel(
          title: "Another title page",
          body: "Another beautiful body text for this example onboarding",
          image: _buildImage('https://s29843.pcdn.co/blog/wp-content/uploads/sites/2/2019/12/remove-background-from-picture-768x576.png'),
          footer: ElevatedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: const Text(
              'FooButton',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Title of last page - reversed",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Click on ", style: bodyStyle),
              Icon(Icons.edit),
              Text(" to edit a post", style: bodyStyle),
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: _buildImage('https://s29843.pcdn.co/blog/wp-content/uploads/sites/2/2019/12/remove-background-from-picture-768x576.png'),
          reverse: true,
        ),
      ],*/
        onDone: () => _onIntroEnd(context),
        //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        //rtl: true, // Display as right-to-left
        skip: const Text('Skip'),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: kIsWeb
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          // size: Size(10.0, 10.0),
          color: Colors.blue,
          // activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1.0)),
          ),
        ),
        dotsContainerDecorator: ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1.0)),
          ),
        ),
      ),
    );
  }
}
