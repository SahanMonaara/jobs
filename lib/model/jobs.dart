class Job {
  final String id;
  final String title;
  final String description;
  final double budget;
  final DateTime postedAt;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
    required this.postedAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      budget: double.parse(json['budget']),
      postedAt: DateTime.parse(json['posted_at']),
    );
  }
}
