import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';

class FooterPage extends StatefulWidget {
  @override
  FooterPageState createState() {
    return new FooterPageState();
  }
}

class FooterPageState extends State<FooterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: new Text(
        'Flutter Footer View',
        style: TextStyle(fontWeight: FontWeight.w200),
      )),
      drawer: new Drawer(),
      body: FooterView(
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(top: 50, left: 70),
                  child: new Text('Scrollable View Section'),
                )
              ],
            ),
          ],
          footer: new Footer(
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Center(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Container(
                            height: 45.0,
                            width: 45.0,
                            child: Center(
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      25.0), // half of height and width of Image
                                ),
                                child: IconButton(
                                  icon: new Icon(
                                    Icons.audiotrack,
                                    size: 20.0,
                                  ),
                                  color: Color(0xFF162A49),
                                  onPressed: () {},
                                ),
                              ),
                            )),
                        new Container(
                            height: 45.0,
                            width: 45.0,
                            child: Center(
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      25.0), // half of height and width of Image
                                ),
                                child: IconButton(
                                  icon: new Icon(
                                    Icons.fingerprint,
                                    size: 20.0,
                                  ),
                                  color: Color(0xFF162A49),
                                  onPressed: () {},
                                ),
                              ),
                            )),
                        new Container(
                            height: 45.0,
                            width: 45.0,
                            child: Center(
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      25.0), // half of height and width of Image
                                ),
                                child: IconButton(
                                  icon: new Icon(
                                    Icons.call,
                                    size: 20.0,
                                  ),
                                  color: Color(0xFF162A49),
                                  onPressed: () {},
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Text(
                    'Copyright ©2020, All Rights Reserved.',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0,
                        color: Color(0xFF162A49)),
                  ),
                  Text(
                    'Powered by Nexsport',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0,
                        color: Color(0xFF162A49)),
                  ),
                ]),
            padding: EdgeInsets.all(5.0),
          )),
      floatingActionButton: new FloatingActionButton(
          elevation: 10.0,
          child: new Icon(Icons.chat),
          backgroundColor: Color(0xFF162A49),
          onPressed: () {}),
    );
  }
}
