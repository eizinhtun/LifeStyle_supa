// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'CommonExampleRouteWrapper.dart';

class UserInfoScreenPhoto extends StatelessWidget {
  const UserInfoScreenPhoto(
      {Key key,
      this.name,
      this.imageurl,
      this.width = 120,
      this.height = 120,
      this.borderColor = Colors.white})
      : super(key: key);
  final String name;
  final String imageurl;
  final double width, height;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    print(imageurl);
    print(imageurl != null);
    return Row(
      children: [
        InkWell(
          onTap: () async {
            if (imageurl != null && imageurl.length > 0) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommonExampleRouteWrapper(
                    imageProvider: CachedNetworkImageProvider(imageurl),
                  ),
                ),
              );
            }
          },
          child: Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                ),
              ),
              imageurl != null
                  ? CachedNetworkImage(
                      width: width,
                      height: height,
                      imageUrl: imageurl,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3.0),
                          borderRadius: new BorderRadius.all(
                              const Radius.circular(100.0)),
                          image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.white, BlendMode.colorBurn)),
                        ),
                      ),
                      placeholder: (context, url) => CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  : Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        // color: Theme.of(context).primaryColor,
                        color: Colors.pink[200],
                        border: Border.all(color: Colors.white, width: 3.0),
                        borderRadius:
                            BorderRadius.all(const Radius.circular(100.0)),
                      ),
                      child: Center(
                        child: Text(
                          name,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
