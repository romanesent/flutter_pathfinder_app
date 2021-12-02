class ServerResult {
  const ServerResult({
    required this.id,
    required this.correct,
  });

  final String id;
  final bool correct;

  factory ServerResult.fromJson(Map<String, dynamic> json) => ServerResult(
    id: json['id'],
    correct: json['correct'],
  );
}
