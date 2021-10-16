// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/pages/me_page.dart';

import 'package:left_style/widgets/wallet.dart';

import 'home_page.dart';
class HomePageDetail extends StatefulWidget {
  const HomePageDetail({Key key}) : super(key: key);

  @override
  _HomePageDetailState createState() => _HomePageDetailState();
}

class _HomePageDetailState extends State<HomePageDetail> {
  static  MePage _mePage=MePage();
  static HomePage _homePage=HomePage();
  static Wallet _walletPage=Wallet();

  PageController controller=PageController();
  List<Widget> _list=<Widget>[
    new Center(child:_homePage),
    new Center(child:_walletPage),
    new Center(child:_mePage),
  ];
  int bottomSelectedIndex=0;

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
        children:
        _list,
        scrollDirection: Axis.horizontal,
        // reverse: true,
        // physics: BouncingScrollPhysics(),
        controller: controller,
        onPageChanged: (num){
          setState(() {
            bottomSelectedIndex=num;
          });
        },
      ),

      bottomNavigationBar:
      SizedBox(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: bottomSelectedIndex,
          onTap: (index) {
            bottomTapped(index);
          },
          items: [
            BottomNavigationBarItem(
              activeIcon: Image.asset("assets/image/activeHome.png",width: 25,height: 25,),
              icon: Image.asset("assets/image/inactiveHome.png",width: 25,height: 25,),
              title: Text("Home",style: TextStyle(fontSize: 12),),
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset("assets/image/activewallet.png",width: 25,height: 25,),
              icon: Image.asset("assets/image/inactivewallet.png",width: 25,height: 25,),//FaIcon(FontAwesomeIcons.wallet),
              title: new Text("Wallet",style: TextStyle(fontSize: 12),),
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset("assets/image/activeme.png",width: 25,height: 25,),
              icon: Image.asset("assets/image/inactiveme.png",width: 25,height: 25,),
              title: new Text("Me",style: TextStyle(fontSize: 12),),
            ),

          ],
        ),
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //       backgroundColor: Colors.red,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.business),
      //       label: 'Business',
      //       backgroundColor: Colors.green,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.school),
      //       label: 'School',
      //       backgroundColor: Colors.purple,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'Settings',
      //       backgroundColor: Colors.pink,
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: _onItemTapped,
      // ),

    );
  }
}
