
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'CommonExampleRouteWrapper.dart';
class ProfileImage extends StatelessWidget {

  const ProfileImage({Key? key,required this.imageurl, this.onChanged,this.width=100,this.height=100,this.borderColor=Colors.white}) : super(key: key);
  final String imageurl;
  final ValueChanged<String>? onChanged;
  final double width,height;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [

        InkWell(
          onTap: () async {
            if(imageurl!=null && imageurl.length>0){
           var newImageUrl=await  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommonExampleRouteWrapper(
                    imageProvider:  NetworkImage(
                      imageurl,
                    ),

                  ),
                ),
              );

           if(newImageUrl==null){
             onChanged!("https://image.freepik.com/free-vector/honey-comb-cartoon-vector-icon-illustration-food-nature-icon-concept-isolated-premium-vector-flat-cartoon-style_138676-3660.jpg");
           }
            }

          },

          child:CachedNetworkImage(
            width: width,
            height: height,
            imageUrl: imageurl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                border:
                Border.all(color: borderColor, width: 1.0),
                borderRadius:
                new BorderRadius.all(const Radius.circular(80.0)),
                image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    colorFilter:
                    ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),

          ),

        ),


      ],
    );
  }
}


