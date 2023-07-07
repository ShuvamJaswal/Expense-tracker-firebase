import 'package:intl/intl.dart';

class FeedbackModel {
  final String description;
  final String userId;
  late String dateTime;

  FeedbackModel({
    required DateTime date,
    required this.description,
    required this.userId,
  }) {
    dateTime =
        "${date.microsecondsSinceEpoch.toString()} ${DateFormat('dd/MM/yy \'at\' HH:mm').format(date)}";
  }

  Map<String, dynamic> toJson() {
    return {
      'datetime': dateTime,
      'userId': userId,
      'description': description,
    };
  }

  factory FeedbackModel.fromJson(
      Map<String, dynamic> data, String firestoreId) {
    return FeedbackModel(
      date: data['datetime'],
      description: data['description'],
      userId: data['userId'],
    );
  }
}
