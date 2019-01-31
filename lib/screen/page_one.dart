import 'package:flutter/material.dart';

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  @override
  Widget build(BuildContext context) {
    Widget cardDetails(
      String title,
      String imgPath,
      String urlLink,
    ) {
      return InkWell(
        onTap: () => Navigator.of(context).pushNamed(urlLink),
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(7.0),
          child: Container(
            height: 100.0,
            width: (MediaQuery.of(context).size.width / 2) - 20.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: Color(0xFFF05A4D)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 2.0),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Center(
                    child: Image.asset(
                      imgPath,
                      fit: BoxFit.fitHeight,
                      height: 70.0,
                      width: 70.0,
                    ),
                  ),
                ),
//                SizedBox(height: 2.0),
                Padding(
                  padding: EdgeInsets.all(0.2),
                  child: Center(
                    child: Text(title,
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 15.0,
                          color: Colors.white,
                        )),
                  ),
                ),

                /*Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(valueCount,
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 15.0,
                        color: Colors.red,
                        fontWeight: FontWeight.bold)),
              )*/
              ],
            ),
          ),
        ),
      );
    }

    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 8.0),
          child: Text('เมนูหลัก',
              style: TextStyle(
                fontFamily: 'Kanit',
                fontWeight: FontWeight.bold,
              )),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    cardDetails(
                        'ข้อมูลส่วนตัว', 'assets/images/A.png', '/users'),
                    cardDetails('คิวรับบริการ', 'assets/images/B.png', '2'),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    cardDetails('รายการยา', 'assets/images/C.png', '8'),
                    cardDetails(
                        'ข้อมูลการรับบริการ', 'assets/images/D.png', '0'),
                  ],
                ),
                SizedBox(height: 5.0)
              ],
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'รายการอื่นๆ',
            style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    cardDetails('Hygge Website', 'assets/card.png', '5'),
                    cardDetails('Facebook Fanpage', 'assets/box.png', '2'),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    cardDetails(
                        'นโยบายความเป็นส่วนตัว', 'assets/trucks.png', '8'),
                    cardDetails(
                        'ข้อมูลการรับบริการ', 'assets/returnbox.png', '0'),
                  ],
                ),
                SizedBox(height: 5.0)
              ],
            )),
      ],
    );
  }
}
