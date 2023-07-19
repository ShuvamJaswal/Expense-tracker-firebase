import 'package:expense_tracker/src/features/about/presentation/widgets/feedback_widget.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'EXPENSE TRACKER',
            style: TextStyle(fontSize: 40),
          ),
          SizedBox(
            height: 300,
            width: 300,
            child: Image(image: AssetImage('assets/logo.png')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(content: FeedbackWidget()),
                    );
                  },
                  child: const Text('Feedback')),
            ),
          )
        ],
      ),
    );
  }
}
