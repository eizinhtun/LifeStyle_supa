import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:left_style/pages/sign_in_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class Wallet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>WalletState();

}



class WalletState extends State<Wallet>{




    RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length+1).toString());
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
     /* appBar: AppBar(
        title: Text("Transication history"),
      ),*/
        body: Stack(

          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,

              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(100.0),bottomRight:Radius.circular(100.0)),

                ),

                /* child: CustomScrollView(
                          slivers: <Widget>[
                            SliverAppBar(
                              leading: IconButton(icon: Icon(Icons.water_damage), onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignInScreen()));
                              },),
                              iconTheme: IconThemeData(color: Colors.black),
                              backgroundColor: Colors.blue,
                              pinned: true,
                              snap: false,
                              floating: false,
                              expandedHeight: 0.0,
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(400),
                                child: Container(

                                  child: Center(child: Text("Appbar With Gradient",style: TextStyle(color: Colors.white,fontSize: 25.0),)),
                                ),
                              ),

                              ),



                          ])

                      ,*/

              ),
            ),

            Positioned(
              top: 100,
              left: 0,

              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height-100,
                width: MediaQuery.of(context).size.width-20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      height: 200,
                      //color: Colors.red,

                    ),

                   Flexible(
                     child: SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropHeader(),
                        footer: CustomFooter(
                          builder: (BuildContext context, mode){
                            Widget body ;
                            if(mode==LoadStatus.idle){
                              body =  Text("pull up load");
                            }
                            else if(mode==LoadStatus.loading){
                              body =  CupertinoActivityIndicator();
                            }
                            else if(mode == LoadStatus.failed){
                              body = Text("Load Failed!Click retry!");
                            }
                            else if(mode == LoadStatus.canLoading){
                              body = Text("release to load more");
                            }
                            else{
                              body = Text("No more Data");
                            }
                            return Container(
                              height: 55.0,
                              child: Center(child:body),
                            );
                          },
                        ),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,
                        child: ListView.builder(
                          itemBuilder: (c, i) => Card(child: Center(child: Text(items[i]))),
                          itemExtent: 100.0,
                          itemCount: items.length,
                        ),
                      ),
                   ),
                  ],
                ),

                /* child: CustomScrollView(
                          slivers: <Widget>[
                            SliverAppBar(
                              leading: IconButton(icon: Icon(Icons.water_damage), onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignInScreen()));
                              },),
                              iconTheme: IconThemeData(color: Colors.black),
                              backgroundColor: Colors.blue,
                              pinned: true,
                              snap: false,
                              floating: false,
                              expandedHeight: 0.0,
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(400),
                                child: Container(

                                  child: Center(child: Text("Appbar With Gradient",style: TextStyle(color: Colors.white,fontSize: 25.0),)),
                                ),
                              ),

                              ),



                          ])

                      ,*/

              ),
            ),



          ],
        )





    );

    return Scaffold(

      body: CustomScrollView(

        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 0.0,

          ),
          SliverToBoxAdapter(
            child: Center(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
                footer: CustomFooter(
                  builder: (BuildContext context, mode){
                    Widget body ;
                    if(mode==LoadStatus.idle){
                      body =  Text("pull up load");
                    }
                    else if(mode==LoadStatus.loading){
                      body =  CupertinoActivityIndicator();
                    }
                    else if(mode == LoadStatus.failed){
                      body = Text("Load Failed!Click retry!");
                    }
                    else if(mode == LoadStatus.canLoading){
                      body = Text("release to load more");
                    }
                    else{
                      body = Text("No more Data");
                    }
                    return Container(
                      height: 55.0,
                      child: Center(child:body),
                    );
                  },
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                  itemBuilder: (c, i) => Card(child: Center(child: Text(items[i]))),
                  itemExtent: 100.0,
                  itemCount: items.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
