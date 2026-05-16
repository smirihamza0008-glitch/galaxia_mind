class StageModel {
  final String id;
  final String question;
  final String correctAnswer;
  final List<String> scrambledLetters;
  final int rewardCoins;

  StageModel({
    required this.id,
    required this.question,
    required this.correctAnswer,
    required this.scrambledLetters,
    required this.rewardCoins,
  });

  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      id: json['id'] as String,
      question: json['question'] as String,
      correctAnswer: json['correctAnswer'] as String,
      scrambledLetters: List<String>.from(json['scrambledLetters'] as List),
      rewardCoins: json['rewardCoins'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'correctAnswer': correctAnswer,
      'scrambledLetters': scrambledLetters,
      'rewardCoins': rewardCoins,
    };
  }
}

