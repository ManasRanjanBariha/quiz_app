import 'package:flutter/material.dart';
import './answer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int quesstionIndex = 0;
  int totalScore = 0;
  bool answerWasSelected = false;
  bool endOfquiz = false;
  bool correctANswerSelected = false;
  List<Icon> _scoreTracker = [];

  void quesstionAnswered(bool answerScore) {
    setState(() {
      // answer was selected
      answerWasSelected = true;

      // Check if answer was correct
      if (answerScore) {
        correctANswerSelected = true;
        totalScore++;
      }
      _scoreTracker.add(
        answerScore
            ? const Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : const Icon(
                Icons.clear,
                color: Colors.red,
              ),
      );
      if (quesstionIndex + 1 == question.length) {
        endOfquiz = true;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      quesstionIndex++;
      answerWasSelected = false;
      correctANswerSelected = false;
    });
    if (quesstionIndex >= question.length) {
      resetQuiz();
    }
  }

  void resetQuiz() {
    setState(() {
      quesstionIndex = 0;
      totalScore = 0;
      _scoreTracker = [];
      endOfquiz = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz app',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                if (_scoreTracker.isEmpty)
                  const SizedBox(
                    height: 25.0,
                  ),
                if (_scoreTracker.isNotEmpty) ..._scoreTracker
              ],
            ),
            Container(
              width: double.infinity,
              height: 128.0,
              margin:
                  const EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  question[quesstionIndex]["quesstion"].toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ...(question[quesstionIndex]['answer'] as List<Map<String, Object>>)
                .map(
              (answer) => Answer(
                answerText: answer['answerText'].toString(),
                answerColor: answerWasSelected
                    ? answer['source'] != null
                        ? Colors.green
                        : Colors.red
                    : Colors.white,
                answerTap: () {
                  // If answer was already seleccted than nothing happen onTap
                  if (answerWasSelected) {
                    return;
                  }
                  //answer was being selected
                  quesstionAnswered(answer['source'] != null);
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40.0),
              ),
              onPressed: (() {
                if (!answerWasSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a answer'),
                    ),
                  );
                  return;
                }
                nextQuestion();
              }),
              child: Text(
                endOfquiz ? 'ResartQuiz' : 'NextQuestion',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '${totalScore.toString()}/${question.length}',
                style: const TextStyle(
                    fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
            ),
            if (answerWasSelected)
              Container(
                height: 100,
                width: double.infinity,
                color: correctANswerSelected ? Colors.green : Colors.red,
                child: Center(
                    child: Text(correctANswerSelected
                        ? 'Well done you got it right'
                        : 'Wrongs')),
              ),
          ],
        ),
      ),
    );
  }
}

const question = [
  {
    "quesstion": "Round the following numbers to the nearest 10",
    "answer": [
      {
        "answerText": "50",
      },
      {"answerText": '40', 'source': true},
    ],
  },
  {
    "quesstion": "Round the following numbers to the nearest 100",
    "answer": [
      {"answerText": "50", 'source': true},
      {
        "answerText": '30',
      },
    ],
  },
  {
    "quesstion": "Round the following numbers to the farest 10",
    "answer": [
      {
        "answerText": "50",'source': true,
      },
      {"answerText": '1', }
    ],
  },
];
