//TODO: Add error handling

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Column(
        children: [
          Text(''),
          Text(''),
          Text(''),
          Text(''),
          ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(content: FeedbackWidget()),
                );
              },
              child: Text('Feedback'))
        ],
      ),
    );
  }
}

class FeedbackWidget extends StatelessWidget {
  FeedbackWidget({
    super.key,
  });

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<bool> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_validateAndSaveForm()) {
      String user = FirebaseAuth.instance.currentUser?.uid ?? 'Anon';
      await FirebaseFirestore.instance
          .collection('utilities/feedbacks/All')
          .add({
        'Description': _feedbackController.text,
        'Created_at': DateTime.now().millisecondsSinceEpoch,
        'user': user
      });
      return true;
    }
    return false;
  }

  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                onSaved: (value) => _feedbackController.text = value!.trim(),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _feedbackController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  labelText: "Text",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                }),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () async {
              if (await _submit()) {
                context.pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Something went wrong')));
              }
            },
            child: Text('Submit Feedback'),
          )
        ],
      ),
    );
  }
}
