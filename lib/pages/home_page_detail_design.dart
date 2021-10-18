// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/pages/me_page.dart';
import 'package:left_style/pages/user_profile_page.dart';
import 'package:left_style/widgets/wallet.dart';
import 'home_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }
  int page=0;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: _pageController,
          children: <Widget>[
            HomePage(),
            Wallet(),
            MePage(),
          ],
          onPageChanged: (int index) {
            setState(() {
              _pageController.jumpToPage(index);
            });
          }
      ),
      bottomNavigationBar: CurvedNavigationBar(
        // animationCurve: Curves.easeInOutBack,
        buttonBackgroundColor: Colors.white,
        animationCurve: Curves.easeInOutBack,
        animationDuration: Duration(milliseconds: 600),
        index:0,
        items: <Widget>[

          (page == 0)?Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                 //color: Colors.blue,
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  shape: BoxShape.circle
              ),
             child: Image.asset("assets/image/activeHome.png",width: 25,height: 25,)):Image.asset("assets/image/inactiveHome.png",width: 25,height: 25,),
          (page == 1)?Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                //color: Colors.blue,
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  shape: BoxShape.circle
              ),
              child: Image.asset("assets/image/activewallet.png",width: 25,height: 25,)):Image.asset("assets/image/inactivewallet.png",width: 25,height: 25,),
          (page == 2)?Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                //color: Colors.blue,
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  shape: BoxShape.circle
              ),
              child: Image.asset("assets/image/activeme.png",width: 25,height: 25,)):Image.asset("assets/image/inactiveme.png",width: 25,height: 25,),


        ],
        color: Colors.blue,
        backgroundColor: Colors.white,
        height: 60.0,
        onTap: (int index) {
          setState(() {
            _pageController.jumpToPage(index);
           page=index;
           print(page);
          });
        },
      ),
    );
  }
}