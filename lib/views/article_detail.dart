import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/utils/colors.dart';
import 'package:news_app/utils/textstyles.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetail extends StatefulWidget {
  final Article? article;

  const ArticleDetail({Key? key, this.article}) : super(key: key);
  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left, color: kWhite),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backwardsCompatibility: false,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: kPrimaryColor),
          backgroundColor: kPrimaryColor,
        ),
        body: Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: "${widget?.article?.urlToImage}",
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Positioned(
                    top: height * 0.32,
                    left: width * 0.04,
                    right: width * 0.04,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(widget!.article!.title.toString(),
                            maxLines: 2,
                            style: kHeading.copyWith(color: kWhite)))),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04, vertical: height * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget!.article!.source!.name.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: Color(0xff586580))),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 16),
                    child: Text(
                      "${DateFormat('dd-MM-yyy, hh:mm a').format(widget!.article!.publishedAt!)}",
                      style: kCaption,
                    ),
                  ),
                  Text(
                    widget!.article!.content != null
                        ? widget!.article!.content.toString()
                        : "",
                    style: kBody,
                  ),
                  GestureDetector(
                    onTap: () => _launchURL(widget!.article!.url.toString()),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Text("See full story ", style: kBody1.copyWith(fontSize:20)),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Color(0xff8caee1),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ?  launch(_url)
      : throw 'Could not launch $_url';
}
