import 'package:flutter/material.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({Key? key}) : super(key: key);

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  int currentQuestionIndex = 1; // Assuming question index starts from 1
  int totalQuestions = 10;
  final Color primaryColor = Colors.blue.shade300; // Make sure this color is defined in your palette

  @override
  Widget build(BuildContext context) {
    // Use theme to define text styles
    TextTheme textTheme = Theme.of(context).textTheme;

    // Define colors based on the background palette
    // Make sure this color is defined in your palette

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Vocabulary",
          style: textTheme.headline6?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              // TODO: Add close quiz functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView( // This will allow the content to scroll
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background4.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Makes the column only as tall as its children
              children: [
                SizedBox(height: 35),
                _buildQuestionArea(textTheme),
                SizedBox(height: 5),
                _buildAnswerOptions(textTheme),
                _buildNextQuestionButton( textTheme),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildQuestionArea(TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            "Question $currentQuestionIndex",
            style: textTheme.subtitle1?.copyWith(color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            "Aasleema?",
            style: textTheme.headline6?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 36),
          _buildCircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildCircularProgressIndicator() {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: currentQuestionIndex / totalQuestions,
            backgroundColor: Colors.white.withOpacity(0.5),
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            strokeWidth: 6,
          ),
          Center(
            child: Text(
              '${(currentQuestionIndex / totalQuestions * 100).toInt()}%',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildAnswerOptions(TextTheme textTheme) {
  List<String> options = ["Bitte", "Danke", "Hallo", "Ja"];
  

  // Reduce the padding or margin as needed to create more space at the bottom
  return Container(
    // Consider reducing this height to allow more space for the 'NEXT QUESTION' button
    
    padding: EdgeInsets.symmetric(vertical: 32),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: options.map((option) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: ListTile(
            title: Text(
              option,
              style: textTheme.subtitle1?.copyWith(color: Colors.black87),
            ),
            onTap: () {
              // TODO: Handle answer option tap
            },
          ),
        );
      }).toList(),
    ),
  );
}

Widget _buildNextQuestionButton(TextTheme textTheme) {
  // Extracted colors from the provided palette
  final Color buttonColor = Color(0xFFFA709A); // Pink shade from the palette
  final Color textColor1 = Colors.white; // White color for the text

  return Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(16, 60, 16, 50),
    child: ElevatedButton(
      onPressed: () {
        // Handle next question tap
      },
      style: ElevatedButton.styleFrom(
        primary: buttonColor, // Use the pink shade for the button
        padding: EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        textStyle: textTheme.subtitle1?.copyWith(color: textColor1, fontWeight: FontWeight.bold),
      ),
            child: Text(
        "NEXT QUESTION",
        style: TextStyle(color: textColor1, fontWeight: FontWeight.bold), // Set text color to white
      ),
    ),
  );
}






void main() => runApp(MaterialApp(home: VocabularyScreen()));
}