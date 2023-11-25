import 'package:flutter/material.dart';
import 'package:quizzapp/screens/home_screen.dart';
import 'package:quizzapp/screens/settings_screen.dart';
import 'package:quizzapp/screens/signin_screen.dart';
import 'package:quizzapp/utils/color_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  int _selectedIndex = 1;
final List<Map<String, dynamic>> courses = [
  {
    'title': 'Vocabulary',
    'color1': Color(0xFFFFF3E0), 
    'color2': Color(0xFFFFE0B2), 
    'icon': Icons.menu_book, 
    'link': 'https://vocabulary-course-link.com'
  },
  {
    'title': 'Conjugation',
    'color1': Color(0xFFE1F5FE), 
    'color2': Color(0xFFB3E5FC),
    'icon': Icons.speaker_notes, 
    'link': 'https://conjugation-course-link.com'
  },
  {
    'title': 'Grammar',
    'color1': Color(0xFFF1F8E9), 
    'color2': Color(0xFFDCEDC8),
    'icon': Icons.book,
    'link': 'https://grammar-course-link.com'
  },
  {
    'title': 'Numbers',
    'color1': Color(0xFFFCE4EC), 
    'color2': Color(0xFFF8BBD0),
    'icon': Icons.filter_1, 
    'link': 'https://numbers-course-link.com'
  },
 
];



    @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Courses",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
body: Container(
  width: MediaQuery.of(context).size.width,
  height: MediaQuery.of(context).size.height,
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/images/background3.png"),
      fit: BoxFit.cover,
    ),
  ),
  child: ListView.builder(
    padding: EdgeInsets.fromLTRB(
      16, 
      100,
      16,
      kBottomNavigationBarHeight + 16, 
    ),
    itemCount: courses.length,
    itemBuilder: (context, index) {
      return _buildCourseCard(courses[index]);
    },
  ),
),



      
bottomNavigationBar: BottomNavigationBar(
  iconSize: 32,
  selectedItemColor: hexStringToColor("#aaa0f0"),
  selectedFontSize: 18,
  unselectedItemColor: Colors.grey,
  currentIndex: _selectedIndex, 
  onTap: onTabTapped, 
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Courses'),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
  ],
),
  );
  }


Widget _buildCourseCard(Map<String, dynamic> course) {

  final Map<String, List<Color>> courseGradients = {
    'Vocabulary': [Color(0xFFCDB4DB), Color(0xFFE2AFF2)], 
    'Conjugation': [Color(0xFFA0C4FF), Color(0xFFBDB2FF)], 
    'Grammar': [Color(0xFFFFC6FF), Color(0xFFFFE0F0)], 
    'Numbers': [Color(0xFFAFCBFF), Color(0xFFC0FDFF)],
  };

  List<Color> gradientColors = courseGradients[course['title']] ?? [Colors.grey.shade300, Colors.grey.shade200];

  return GestureDetector(
    onTap: () => launchURL(course['link']),
    child: Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    course['title'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Icon(course['icon'], size: 40, color: Colors.white),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Explore this course for a comprehensive understanding of the subject.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white.withOpacity(0.85),
                  onPrimary: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () => launchURL(course['link']),
                child: Text('Learn More'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



 Future<void> launchURL(String url) async {
    if (!await launch(url)) {
     
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
        ),
      );
    }
  }

 void onTabTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });

 

  switch (index) {
    case 0:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      break;
    case 1: 
      if (_selectedIndex != 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CoursesScreen()),
        );
      }
      break;
    case 2: 
      
      break;
    case 3: 
     
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
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
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
}
}