// @dart=2.9
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:left_style/pages/me_page.dart';

import 'package:left_style/widgets/wallet.dart';

import 'home_page.dart';

class HomePageDetail extends StatefulWidget {
  const HomePageDetail({Key key}) : super(key: key);

  @override
  _HomePageDetailState createState() => _HomePageDetailState();
}

class _HomePageDetailState extends State<HomePageDetail> {
  static MePage _mePage = MePage();
  static HomePage _homePage = HomePage();
  static Wallet _walletPage = Wallet();

  PageController controller = PageController();
  List<Widget> _list = <Widget>[
    new Center(child: _homePage),
    new Center(child: _walletPage),
    new Center(child: _mePage),
  ];
  int bottomSelectedIndex = 0;

  Future<void> bottomTapped(int index) async {
    setState(() {
      bottomSelectedIndex = index;
      controller.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: _list,
        scrollDirection: Axis.horizontal,
        // reverse: true,
        // physics: BouncingScrollPhysics(),
        controller: controller,
        onPageChanged: (num) {
          setState(() {
            bottomSelectedIndex = num;
          });
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: bottomSelectedIndex,
          onTap: (index) {
            bottomTapped(index);
          },
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(FontAwesomeIcons.home),
              icon: Icon(FontAwesomeIcons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                FontAwesomeIcons.wallet,
              ),
              icon: Icon(FontAwesomeIcons.wallet),
              label: "Wallet",
            ),
            BottomNavigationBarItem(
                activeIcon: Icon(FontAwesomeIcons.user),
                icon: Icon(FontAwesomeIcons.user),
                label: "Me"),
          ],
        ),
      ),
    );
  }
}
