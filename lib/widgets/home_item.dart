// @dart=2.9
import 'package:flutter/material.dart';

class HomeItemWidget extends StatelessWidget {
  const HomeItemWidget(
      {Key key, this.context, this.title, this.iconData, this.onPress})
      : super(key: key);
  final BuildContext context;
  final String title;
  final IconData iconData;

  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              onPress(context);
            },
            icon: Icon(
              iconData,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.black87),
          )
        ],
      ),
    );
  }
}
