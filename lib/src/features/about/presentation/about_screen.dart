import 'package:expense_tracker/src/features/about/presentation/about_controller.dart';
import 'package:expense_tracker/src/utils/async_ui/error_snackbar_on_async.dart';
import 'package:expense_tracker/src/utils/async_ui/loading_on_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

class FeedbackWidget extends ConsumerWidget {
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

  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(aboutControllerProvider, (_, state) {
      state.showSnackbarOnError(context);
      state.showLoading(context);
    });
    Future<void> submit() async {
      FocusManager.instance.primaryFocus?.unfocus();
      if (_validateAndSaveForm()) {
        final success = await ref
            .read(aboutControllerProvider.notifier)
            .submit(description: _feedbackController.text);
        if (success) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Feedback Submitted.')));
          context.pop();
        }
      }
    }

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
              await submit();
            },
            child: Text('Submit Feedback'),
          )
        ],
      ),
    );
  }
}
