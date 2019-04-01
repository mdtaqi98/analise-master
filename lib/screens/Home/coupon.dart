import 'package:flutter/material.dart';
import 'hazardreport_screen.dart';


void main() => runApp(new coupons());

class coupons extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<coupons> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Coupons'),
              leading: new IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.white, size: 20.0),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            body:  new ListView(


                children: [
                  new _RestaurantCard(
                      headImageAssetPath: 'assets/mcdonalds.png',
                      icon: Icons.fastfood,
                      iconBackgroundColor: Colors.orange,
                      title: 'il domacca',
                      subtitle: "78 5TH AVENUE, NEW YORK",
                      heartCount: 84
                  ),
                  new _RestaurantCard(
                      headImageAssetPath: 'assets/starrbucks.png',
                      icon: Icons.local_dining,
                      iconBackgroundColor: Colors.red,
                      title: 'Mc Grady',
                      subtitle: "79 5TH AVENUE, NEW YORK",
                      heartCount: 84
                  ),
                  new _RestaurantCard(
                      headImageAssetPath: 'assets/mcdonalds.png',
                      icon: Icons.fastfood,
                      iconBackgroundColor: Colors.purpleAccent,
                      title: 'Sugar & Spice',
                      subtitle: "80 5TH AVENUE, NEW YORK",
                      heartCount: 84
                  ),
                ]
            )
            ));
  }




}

class _RestaurantCard extends StatelessWidget {

  final String headImageAssetPath;
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final int heartCount;

  _RestaurantCard({
    this.headImageAssetPath,
    this.icon,
    this.iconBackgroundColor,
    this.title,
    this.subtitle,
    this.heartCount,
  });

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: new Card(
        elevation: 10.0,
        child: new Column(
          children: [
            new Image.asset(
              headImageAssetPath,
              width: double.infinity,
              height: 150.0,
              fit: BoxFit.cover,
            ),
            new Row(
              children: [
                new Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: new Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: new BorderRadius.all(const Radius.circular(15.0)),
                    ),
                    child: new Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Text(
                        title,
                        style: const TextStyle(
                          fontSize: 25.0,
                          fontFamily: 'mermaid',
                        ),
                      ),
                      new Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'bebas-neue',
                          letterSpacing: 1.0,
                          color: const Color(0xFFAAAAAA),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  width: 2.0,
                  height: 70.0,
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white,
                        const Color(0xFFAAAAAA),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: new Column(
                    children: [
                      new Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),
                      new Text(
                        '$heartCount',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}























