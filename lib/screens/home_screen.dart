import 'package:flutter/material.dart';
import 'package:quizzapp/screens/analytics_screen.dart';
import 'package:quizzapp/screens/settings_screen.dart';
import 'package:quizzapp/screens/signin_screen.dart';
import 'package:quizzapp/screens/vocabulary_screen.dart';
import 'package:quizzapp/utils/color_utils.dart';

class HomeScreen extends StatelessWidget {
  List catNames = [
    "Analytics",
    "Vocabulary",
    "Conjugation",
    "Grammar",
    "Numbers",
    "Mixed"
  ];

  List<Color> catColors = [
    Color(0xFFFFCF2F),
    Color(0xFF6FE08D),
    Color(0xFF51BDFD),
    Color(0xFFFFC7F7F),
    Color(0xFFCB84FB),
    Color(0xFF78E667),
    Color(0xFF),
  ];

  List<Icon> catIcons = [
    Icon(Icons.analytics, color: Colors.white, size: 30),
    Icon(Icons.book, color: Colors.white, size: 30),
    Icon(Icons.chat, color: Colors.white, size: 30),
    Icon(Icons.grade, color: Colors.white, size: 30),
    Icon(Icons.calculate, color: Colors.white, size: 30),
    Icon(Icons.dashboard_customize, color: Colors.white, size: 30),
  ];

  @override
  Widget build(BuildContext context) {
    GlobalKey _accountKey = GlobalKey();
    return Scaffold(
      backgroundColor: hexStringToColor("#F9F9F9"),
      body: ListView(
        children: [
          Container(
              padding:
                  EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background2.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 3),
                        child: Text("Hallo, ",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              wordSpacing: 2,
                              color: Colors.white,
                            )),
                      ),
                      Icon(
                        Icons.notifications,
                        size: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3, bottom: 5),
                    child: Text("Guten Tag! ",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                          color: Colors.white,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search here...",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 25,
                          )),
                    ),
                  ),
                ],
              )),
          SizedBox(height: 22),
          Padding(
            padding: EdgeInsets.only(bottom: 22),
            child: Center(
              child: Text("Good job! Keep it up!",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    wordSpacing: 2,
                    color: Color.fromARGB(200, 0, 0, 0),
                  )),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/icon.png',
                height: 200,
                width: 200,
              ),
              SizedBox(
                height: 240,
                width: 240,
                child: CircularProgressIndicator(
                  value: 0.25,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: 15,
                  right: 15),
              child: Column(
                children: [
                  Container(
                    height: 240,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: GridView.builder(
                      itemCount: catNames.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (catNames[index] == "Analytics") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AnalyticsScreen()),
                              );
                            }
                              if (catNames[index] == "Vocabulary") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const VocabularyScreen()),
                              );
                            }
                            // Add else if conditions for other categories if needed
                          },
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: catColors[index],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(child: catIcons[index]),
                              ),
                              SizedBox(height: 10),
                              Text(
                                catNames[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 32,
        selectedItemColor: hexStringToColor("#aaa0f0"),
        selectedFontSize: 18,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          if (index == 3) {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Logout'),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'Courses'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
