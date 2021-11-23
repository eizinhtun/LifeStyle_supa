// @dart=2.9
import 'package:flutter/material.dart';

class HomeItemWidget extends StatelessWidget {
  const HomeItemWidget(
      {Key key,
      this.context,
      this.title,
      this.iconData,
      this.img,
      this.onPress})
      : super(key: key);
  final BuildContext context;
  final String title;
  final String img;
  final IconData iconData;

  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPress(context),
      child: Container(
        width: 100,
        child: Column(
          children: [
            img == null
                ? Icon(
                    iconData,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  )
                : Image.asset(
                    img,
                    color: Theme.of(context).primaryColor,
                    height: 40,
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
      ),
    );
  }
}
