import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intership_task/Api/ApiGet.dart';
import 'package:intership_task/Api/ApiModel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Api/ApiCall.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NewsViewModel newsViewModel = NewsViewModel();
  List<ApiModel> _news = [];

  bool isLoading = true;
  var image =
      "https://img.freepik.com/free-vector/breaking-news-information-concept_52683-36243.jpg?w=900&t=st=1704629794~exp=1704630394~hmac=8ac7635cfae5401ac302550299bba4746b24b4a3804d97bfbad0f1fb12e0354a";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getNews();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Text(
              "News",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "App",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder<ApiModel>(
              future: newsViewModel.fetchHeadline(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.9,
                      ));
                }
                if (snapshot.data == null) {
                  return Center(
                    child: Text(
                      "No Data Found ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 29,
                          color: Colors.black.withOpacity(0.3)),
                    ),
                  );
                }
                var data = snapshot.data?.articles;

                return ListView.builder(
                    itemCount: data?.length,
                    itemBuilder: (context, index) {
                      var title = data?[index].title;
                      var time = data?[index].publishedAt;
                      var imageUrl = data?[index].urlToImage??image;
                      var newsUrl = data?[index].url;
                      var author = data?[index].author;

                      return GestureDetector(
                        onTap: () async {
                          launchUrl(newsUrl!);
                        },
                        child: Container(
                          //  margin: EdgeInsets.all(4),
                          height: 200,
                          width: MediaQuery.of(context).size.width * 0.9,
                          color: Colors.blue,
                          child: Card(child: Stack(
                            children: [

                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage("$imageUrl"),fit: BoxFit.fill),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.black.withOpacity(0.5),
                                highlightColor: Colors.grey.withOpacity(.1),
                                child: Container(
                                  color: Colors.black.withOpacity(0.9),
                                ),
                              ),
                              Column(
                                children: [
                                  Text("$author", style: TextStyle(
                                    color: Colors.white54
                                  ),),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.start, color: Colors.orange,),
                                      ),
                                      Expanded(
                                        child: Text("$title",style: TextStyle(
                                            color: Colors.white
                                        )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.timelapse, color: Colors.white,),
                                      ),

                                      Expanded(
                                        child: Text("$time",style: TextStyle(
                                            color: Colors.white
                                        )),
                                      ),
                                    ],
                                  )
                                  
                                  
                                  
                                  
                                ],
                              )
                              
                              


                            ],
                          )),
                        ),
                      );
                    });
              },
            ))
          ],
        ),
      ),
    );
  }

  void showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'CLOSE',
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }
  void launchUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
      showToast(context, "we are anable to open $url");
      // Handle the error as needed, e.g., show a custom message.
    }
  }
}
