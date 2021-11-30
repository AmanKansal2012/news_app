import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app/data/news_fetch.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/utils/colors.dart';
import 'package:provider/provider.dart';

class NoInternet extends StatefulWidget {
  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  NewsFetch? newsFetch;

  ArticleModel? articleModel;

  Future getNews() async {
    articleModel = await Provider?.of<NewsFetch>(context, listen: false)!
        .getNews("");
  }

  @override
  Widget build(BuildContext context) {
    newsFetch = Provider.of<NewsFetch>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/no_internet.svg",height: 100,width: 100,),
          Padding(
            padding: const EdgeInsets.only(top:4.0,bottom: 4),
            child: Text("No internet connection",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
          ),
          ElevatedButton(onPressed: (){
            getNews();
          }, child: Text("Try again"),style: ElevatedButton.styleFrom(
            primary: kPrimaryColor,
            onPrimary: Colors.white,
            shadowColor: kPrimaryAccentColor,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            minimumSize: Size(100, 40), //////// HERE
          ),),
        ],
      ),
    );
  }
}
