import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Analytics",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            children: [
              LeaveCardSection(),
              SizedBox(height: 20),
              QuerySection(),
              // Include PayDetailRow here if needed
            ],
          ),
        ),
      ),
    );
  }
}

class LeaveCardSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for the circular progress indicators
    final List<Map<String, dynamic>> leaveData = [
      {"type": "Vocabluary", "available": 100, "done": 30},
      {"type": "Conjugation", "available": 82, "done": 30},
      {"type": "Grammar", "available": 60, "done": 30},
      {"type": "Numbers", "available": 50, "done": 30},
    ];

return GridView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(), 
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, 
    childAspectRatio: 1.5 / 2, 
    crossAxisSpacing: 10, 
    mainAxisSpacing: 10, 
  ),
  itemCount: leaveData.length,
  itemBuilder: (context, index) {
    return LeaveCard(data: leaveData[index]);
  },
);

  }
}


class LeaveCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const LeaveCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progressValue = data['available'] / (data['available'] + data['done']);
    List<Color> cardGradientColors = [
      Color(0xFFB6A2DB), 
      Color(0xFF89CFF0), 
      Color(0xFFF8B7D0), 
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cardGradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "${data['type']}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          CustomPaint(
            painter: ProgressRingPainter(progressValue: progressValue, baseColor: Colors.white24, progressColor: Colors.white),
            child: Container(
              height: 80,
              width: 80,
              alignment: Alignment.center,
              child: Text(
                "${(progressValue * 100).toInt()}%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "available ${data['available']} | done ${data['done']}",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}


class ProgressRingPainter extends CustomPainter {
  final double progressValue;
  final Color baseColor;
  final Color progressColor;

  ProgressRingPainter({
    required this.progressValue,
    required this.baseColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint basePaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    canvas.drawCircle(center, radius, basePaint);
    double sweepAngle = 2 * 3.141592653589793238 * progressValue;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -3.141592653589793238 / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}



class QuerySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(230), 
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            spreadRadius: 1,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          QueryCard(
            icon: Icons.question_answer,
            count: '09',
            label: 'Total Flashcards',
            color: Theme.of(context).colorScheme.secondary, 
          ),
          QueryCard(
            icon: Icons.check_circle_outline,
            count: '02',
            label: 'Flashcards Answered',
            color: Theme.of(context).colorScheme.primary, 
          ),
        ],
      ),
    );
  }
}



class QueryCard extends StatelessWidget {
  final IconData icon;
  final String count;
  final String label;
  final Color color;

  const QueryCard({
    Key? key,
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 40, color: color),
        SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}




class PayDetailRow extends StatelessWidget {
  final String label;
  final String amount;

  const PayDetailRow({Key? key, required this.label, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            amount,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
