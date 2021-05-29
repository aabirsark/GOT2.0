import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.black,
        fontFamily: GoogleFonts.pacifico().fontFamily,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final url =
      "http://api.tvmaze.com/singlesearch/shows?q=game-of-thrones&embed=episodes";

  var data;

  @override
  void initState() {
    super.initState();
    _fetchdata();
  }

  void _fetchdata() async {
    var res = await http.get(Uri.parse(url));
    var decodedData = jsonDecode(res.body);
    data = decodedData;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "GOT 2.0",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: data == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : MainBody(
              data: data,
            ),
    );
  }
}

class MainBody extends StatelessWidget {
  final data;
  const MainBody({
    @required this.data,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.1,
                  backgroundImage: NetworkImage(data["image"]["original"]),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              data["name"],
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1,
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2),
                    itemCount: data["_embedded"]["episodes"].length,
                    itemBuilder: (ctx, index) {
                      var _episodes = data["_embedded"]["episodes"][index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Card(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      _episodes["name"],
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontFamily:
                                                              GoogleFonts
                                                                      .poppins()
                                                                  .fontFamily,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      _episodes["summary"],
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Image.network(
                                  _episodes["image"]["original"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _episodes["name"],
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.amberAccent,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "S${_episodes["season"]}E${_episodes["number"]}",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      );
}
