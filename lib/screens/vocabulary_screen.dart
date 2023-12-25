import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MaterialApp(home: VocabularyScreen()));

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({Key? key}) : super(key: key);

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  int correctAnswersCount = 0;
  int currentQuestionIndex = 1;
  int totalQuestions = 10;
  final Color primaryColor = Colors.blue.shade300;
  String currentQuestion = '';
  List<String> options = [];
  String correctOption = '';
  Map<String, Color> optionColors = {};
  bool quizCompleted = false;

  @override
  void initState() {
    super.initState();
    fetchQuestionAndOptions();
  }

void fetchQuestionAndOptions() async {
  try {
    var questionsSnapshot = await FirebaseFirestore.instance.collection('vocabulary').get();
    var documents = questionsSnapshot.docs;

    if (documents.length > 1) { // Ensure there are at least 2 documents to choose from
      var randomQuestionDoc = (documents..shuffle()).first;
      var questionData = randomQuestionDoc.data();

      var question = questionData?['Question'] as String?;
      var response = questionData?['Response'] as String?;

      if (question != null && response != null) {
        // Filter out the correct response and shuffle the remaining to get random options
        var incorrectOptions = documents
          .where((doc) => doc.id != randomQuestionDoc.id)
          .map((doc) => doc.data()?['Response'] as String?)
          .whereType<String>() // Filter out nulls and ensure a list of non-null Strings
          .toList()
          ..shuffle();

        // Ensure there are 3 incorrect options, repeat some if necessary
        while (incorrectOptions.length < 3) {
          incorrectOptions.add(incorrectOptions[incorrectOptions.length % incorrectOptions.length]);
        }

        // Take the first 3 incorrect options and add the correct response
        List<String> mixedOptions = incorrectOptions.sublist(0, 3);
        mixedOptions.add(response);
        mixedOptions.shuffle();

        setState(() {
          currentQuestion = question;
          correctOption = response;
          options = mixedOptions; // mixedOptions is guaranteed to be List<String>
          optionColors = Map.fromIterable(mixedOptions, key: (e) => e, value: (e) => Colors.white);
        });
      } else {
        print('The document does not contain the Question and/or Response field.');
      }
    } else {
      print('Not enough documents in the collection to create options.');
    }
  } catch (e) {
    print('Error fetching question: $e');
  }
}

  void checkAnswerAndUpdate(String option) {
    if (option == correctOption) {
      correctAnswersCount++; // Increment the correct answers count
    }
    // Update the color of the option cards
    setState(() {
      optionColors[option] = option == correctOption ? Colors.green : Colors.red;
      optionColors.keys.where((key) => key != option).forEach((key) {
        optionColors[key] = Colors.white;
      });
    });
  }

void goToNextQuestion() {
  if (currentQuestionIndex < totalQuestions) {
    setState(() {
      currentQuestionIndex++; // Increment the question index
      optionColors.updateAll((key, value) => Colors.white); // Reset colors
      fetchQuestionAndOptions(); // Fetch the next question and options
    });
  } else {
    // When reaching the last question, update the state to show the score
    setState(() {
      quizCompleted = true;
    });
    // Call the method to show the score
    showScore(context);
  }
}



Widget _buildOptionCard(String option, TextTheme textTheme) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
    elevation: 4,
    shadowColor: Colors.black54,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    color: optionColors[option], // Use the color from the state
    child: ListTile(
      title: Text(option, textAlign: TextAlign.center, style: GoogleFonts.nunito(fontSize: 20)),
      onTap: () {
        checkAnswerAndUpdate(option);
      },
    ),
  );
}

  

  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme.apply(bodyColor: Colors.white);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Vocabulary",
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
    // Use currentQuestion for the question text
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text("Question $currentQuestionIndex", style: GoogleFonts.nunito(fontSize: 18)),
          SizedBox(height: 8),
          Text(currentQuestion.isEmpty ? 'Loading...' : currentQuestion, 
              style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 26),
          _buildCircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildCircularProgressIndicator() {
    // The progress value is calculated as the number of correct answers over total questions
    double progressValue = correctAnswersCount / totalQuestions;
    
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.white.withOpacity(0.5),
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            strokeWidth: 6,
          ),
         Center(child: Text('${(progressValue * 100).toInt()}%', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions(TextTheme textTheme) {
    // Use the dynamic options list from the state
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: options.map((option) => _buildOptionCard(option, textTheme)).toList(),
      ),
    );
  }



Widget _buildNextQuestionButton(TextTheme textTheme) {
  // Disable the button if the quiz is completed
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(20),
    child: ElevatedButton(
      onPressed: quizCompleted ? null : goToNextQuestion,
      // If the quiz is completed, show a different text
      child: Text(
        quizCompleted ? "SHOW SCORE" : "NEXT QUESTION",
        style: textTheme.subtitle1?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        primary: quizCompleted ? Colors.grey : primaryColor,
        padding: EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
      ),
    ),
  );
}
String getScoreMessage(double scorePercent) {
  if (scorePercent >= 90) {
    return 'Outstanding!';
  } else if (scorePercent >= 80) {
    return 'Excellent!';
  } else if (scorePercent >= 70) {
    return 'Very Good!';
  } else if (scorePercent >= 60) {
    return 'Good Job!';
  } else if (scorePercent >= 50) {
    return 'Nice Effort!';
  } else if (scorePercent >= 40) {
    return 'Keep Trying!';
  } else {
    return 'Better luck next time!';
  }
}

void showScore(BuildContext context) {
  double scorePercent = correctAnswersCount / totalQuestions * 100;
  String scoreMessage = getScoreMessage(scorePercent);

  // Define the colors for the gradient based on your palette
List<Color> gradientColors = [
  Color(0xFFe5bcee), // Soft purple
  Color(0xFF8cddf5), // Light blue
  Color(0xFFd3d8ee), // Light periwinkle
  Color(0xFFaaa0f0), // Soft violet
  Color(0xFF7d71f7), // Bright violet
];

  showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: scorePercent / 100,
                    strokeWidth: 12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      gradientColors.last, // Use the darkest color for the progress bar
                    ),
                    backgroundColor: Colors.white.withOpacity(0.5),
                  ),
                  Center(
                    child: Text(
                      '${(scorePercent).toInt()}%',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Your Score:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Use the lightest color for text
                ),
              ),
            ),
            Text(
              scoreMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white, // Use the lightest color for text
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Use the lightest color for the button background
                onPrimary: gradientColors.last, // Use the darkest color for button text
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    ),
  );
}




}

