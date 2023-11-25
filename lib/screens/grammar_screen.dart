import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MaterialApp(home: GrammarScreen()));

class GrammarScreen extends StatefulWidget {
  const GrammarScreen({Key? key}) : super(key: key);

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  int currentQuestionIndex = 1;
  int totalQuestions = 10;
  final Color primaryColor = Colors.blue.shade300;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme.apply(bodyColor: Colors.white);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Grammar",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/background4.png"), fit: BoxFit.cover),
          ),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 30),
                _buildQuestionArea(textTheme),
                SizedBox(height: 10),
                _buildAnswerOptions(textTheme),
                _buildNextQuestionButton(textTheme),
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
          Text("Question $currentQuestionIndex", style: GoogleFonts.nunito(fontSize: 18)),
          SizedBox(height: 8),
          Text("Aasleema?", style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 26),
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
          Center(child: Text('${(currentQuestionIndex / totalQuestions * 100).toInt()}%', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions(TextTheme textTheme) {
    List<String> options = ["Bitte", "Danke", "Hallo", "Ja"];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: options.map((option) => _buildOptionCard(option, textTheme)).toList(),
      ),
    );
  }

  Widget _buildOptionCard(String option, TextTheme textTheme) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      elevation: 4,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: ListTile(
        title: Text(option, textAlign: TextAlign.center, style: GoogleFonts.nunito(fontSize: 20)),
        onTap: () {
          // Handle answer option tap
        },
      ),
    );
  }

 Widget _buildNextQuestionButton(TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          if (currentQuestionIndex < totalQuestions) {
            setState(() {
              currentQuestionIndex++; // Increment the question index
            });
          } else {
            // TODO: Handle completion of questions
          }
        },
        style: ElevatedButton.styleFrom(
          primary: primaryColor, // Use the primary color
          padding: EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        child: Text(
          "NEXT QUESTION",
          style: textTheme.subtitle1?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

