import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/data/news_fetch.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/utils/colors.dart';
import 'package:news_app/utils/strings.dart';
import 'package:news_app/utils/textstyles.dart';
import 'package:news_app/views/article_detail.dart';
import 'package:news_app/widgets/card_widget.dart';
import 'package:news_app/widgets/no_internet.dart';
import 'package:news_app/widgets/no_result.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsFetch? newsFetch;
  ArticleModel? articleModel;
  final TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    getNews();
    super.initState();
  }

  Future getNews({String country = "in"}) async {
    articleModel = await Provider.of<NewsFetch>(context, listen: false)
        .getNews(textEditingController.text, country: country);
  }

  @override
  Widget build(BuildContext context) {
    checkInternet();
    newsFetch = Provider.of<NewsFetch>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: getNews,
        child: Scaffold(
          backgroundColor: kSecondaryColor,
          appBar: buildAppBar(),
          body: newsFetch!.isConnected
              ? !newsFetch!.isLoading
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: width * 0.04,
                              right: width * 0.04,
                              top: height * 0.023),
                          child: Column(
                            children: [searchTextField(), buildHead()],
                          ),
                        ),
                        buildBody(height),
                      ],
                    )
                  : Center(child: CircularProgressIndicator())
              : NoInternet(),
        ),
      ),
    );
  }

  Widget buildBody(double height) {
    return (textEditingController.text.isNotEmpty &&
                                  articleModel?.articles?.length == 0) ||
                              articleModel == null
                          ? Padding(
                              padding: EdgeInsets.only(top: height * 0.2),
                              child: NoResult(),
                            )
                          : Expanded(
                              child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: articleModel?.articles?.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  int? l = articleModel?.articles?.length;
                                  int fromLast = l! - index - 1;
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ArticleDetail(
                                                    article: articleModel
                                                        ?.articles?[index],
                                                  )));
                                    },
                                    child: CardWidget(
                                        article: newsFetch!.isOldest
                                            ? articleModel
                                                ?.articles![fromLast]
                                            : articleModel?.articles?[index]),
                                  );
                                },
                              ),
                            );
  }

  Padding buildHead() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            heading,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff586580)),
          ),
          GestureDetector(
            onTap: () {
              showPopupMenu();
            },
            child: Row(
              children: [
                Text(
                  "Sort: ",
                  style: kCaption,
                ),
                Text(newsFetch!.oldest ? "Oldest" : "Newest",
                    style: kCaption.copyWith(color: Color(0xff586580))),
                Icon(
                  Icons.arrow_drop_down_sharp,
                  color: kPrimaryAccentColor,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container searchTextField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: kGrey,
        border: Border.all(
          color: kGrey,
          width: 1,
        ),
      ),
      child: TextField(
        cursorColor: kPrimaryAccentColor,
        textCapitalization: TextCapitalization.sentences,
        maxLines: null,
        controller: textEditingController,
        onSubmitted: null,
        onChanged: (val) {
          if (val.length > 0) {
            newsFetch?.isSearching = true;
          } else {
            newsFetch?.isSearching = false;
          }
          getNews();
        },
        keyboardType: TextInputType.text,
        style:
            TextStyle(fontWeight: FontWeight.w400, color: kPrimaryAccentColor),
        decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
                fontWeight: FontWeight.w400, color: kPrimaryAccentColor),
            contentPadding: const EdgeInsets.only(left: 6, top: 12),
            suffixIcon: Icon(
              Icons.search_rounded,
              color: kPrimaryAccentColor,
              size: 20,
            )),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: newsFetch!.searching
          ? IconButton(
              icon: Icon(Icons.keyboard_arrow_left, color: kWhite),
              onPressed: () {
                newsFetch?.isSearching = false;
                textEditingController.clear();
                getNews();
              },
            )
          : Icon(
              Icons.cloud,
              color: kWhite,
            ),
      titleSpacing: 0,
      title: Text(
        newsFetch!.searching ? search : title,
        style: kBody.copyWith(color: kSecondaryColor),
      ),
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: kPrimaryColor),
      backgroundColor: kPrimaryColor,
      actions: [
        newsFetch!.searching
            ? Container(
                height: 0,
                width: 0,
              )
            : GestureDetector(
                onTap: () {
                  showCountryBottomSheet();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0, top: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location,
                        style: kBody1.copyWith(
                            fontSize: 12, color: kSecondaryColor),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Icon(
                              Icons.location_on,
                              size: 14,
                              color: kSecondaryColor,
                            ),
                          ),
                          Text(
                            newsFetch!.country.toString(),
                            style: kBody1.copyWith(color: kSecondaryColor),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
      ],
    );
  }

  Future<void> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        newsFetch?.isConnected = true;
      }
    } on SocketException catch (_) {
      newsFetch?.isConnected = false;
    }
  }

  showPopupMenu() {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(25.0, 100.0, 0.0, 0.0),
      items: [
        PopupMenuItem<String>(child: const Text('newest'), value: '1'),
        PopupMenuItem<String>(child: const Text('oldest'), value: '2'),
      ],
      elevation: 8.0,
    ).then((itemSelected) {
      if (itemSelected == "1") {
        newsFetch?.isOldest = false;
      } else if (itemSelected == "2") {
        newsFetch?.isOldest = true;
      }
    });
  }

  showCountryBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          width: 60,
                          height: 4.0,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            color: kPrimaryAccentColor,
                          ),
                          child: const Divider(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Choose your location",
                        style: TextStyle(
                            color: Color(0xff586580),
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: new Text('India'),
                      onTap: () {
                        getNews(country: "in");
                        newsFetch?.selCountry = "India";
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: new Text('USA'),
                      onTap: () {
                        getNews(country: "us");
                        newsFetch?.selCountry = "USA";
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: new Text('Czech Republic'),
                      onTap: () {
                        getNews(country: "cz");
                        newsFetch?.selCountry = "Czech Republic";
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: new Text('China'),
                      onTap: () {
                        newsFetch?.selCountry = "China";
                        getNews(country: "cn");
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: new Text('France'),
                      onTap: () {
                        getNews(country: "fr");
                        newsFetch?.selCountry = "France";
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: new Text('Thailand'),
                      onTap: () {
                        getNews(country: "th");
                        newsFetch?.selCountry = "Thailand";
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
