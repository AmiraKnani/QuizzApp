import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quizzapp/screens/analytics_screen.dart';
import 'package:quizzapp/screens/conjugation_screen.dart';
import 'package:quizzapp/screens/courses_screen.dart';
import 'package:quizzapp/screens/grammar_screen.dart';
import 'package:quizzapp/screens/mixed_screen.dart';
import 'package:quizzapp/screens/numbers_screen.dart';
import 'package:quizzapp/screens/settings_screen.dart';
import 'package:quizzapp/screens/signin_screen.dart';
import 'package:quizzapp/screens/vocabulary_screen.dart';
import 'package:quizzapp/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _userName = ''; // Declare the userName variable

  List<String> catNames = [
    "Analytics",
    "Vocabulary",
    "Conjugation",
    "Grammar",
    "Numbers",
    "Mixed"
  ];

  // Corrected the color list by removing the incomplete color value
  List<Color> catColors = [
    Color(0xFFFFCF2F),
    Color(0xFF6FE08D),
    Color(0xFF51BDFD),
    Color(0xFFFFC7F7F),
    Color(0xFFCB84FB),
    Color(0xFF78E667),
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
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            _userName = documentSnapshot['userName'].split(' ')[0];
          });
        }
      }).catchError((error) {
        // Handle any errors here
      });
    }
  }

  void _onSearch(String query) {
    // Convert the search query to a format that matches your category names
    String formattedQuery = query.trim().toLowerCase();

    // Find the matching category
    String? matchedCategory;
    for (var category in catNames) {
      if (category.toLowerCase() == formattedQuery) {
        matchedCategory = category;
        break;
      }
    }

    // Navigate to the corresponding screen based on the matched category
    if (matchedCategory != null) {
      switch (matchedCategory) {
        case "Analytics":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AnalyticsScreen()),
          );
          break;
        case "Vocabulary":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VocabularyScreen()),
          );
          break;
        case "Conjugation":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConjugationScreen()),
          );
          break;
        case "Grammar":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GrammarScreen()),
          );
          break;
        case "Numbers":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NumbersScreen()),
          );
          break;
        case "Mixed":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MixedScreen()),
          );
          break;
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Search Result"),
            content: Text("No matching category found."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

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
                        child: Text("Hallo $_userName,",
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
                      controller: _searchController,
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
                          onFieldSubmitted: _onSearch,
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
              Lottie.asset(
                'assets/animations/rock.json',
                height: 240,
                width: 240,
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
                            } else if (catNames[index] == "Conjugation") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ConjugationScreen()),
                              );
                            } else if (catNames[index] == "Grammar") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GrammarScreen()),
                              );
                            } else if (catNames[index] == "Numbers") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NumbersScreen()),
                              );
                            } else if (catNames[index] == "Mixed") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MixedScreen()),
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
          switch (index) {
            case 0: // Home
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1: // Courses
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CoursesScreen()),
              );
              break;
            case 2: // Wishlist
              // Handle Wishlist navigation
              break;
            case 3: // Account, Settings, Logout
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
              break;
            default:
              break;
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
