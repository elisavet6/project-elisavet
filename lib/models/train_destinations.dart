class TrainTrip {
  final String duration;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String origin;
  final String destination;
  final double amount;

  TrainTrip({
    required this.duration,
    required this.departureTime,
    required this.arrivalTime,
    required this.origin,
    required this.destination,
    required this.amount,
  });

  // Factory constructor to create a TrainTrip instance from JSON
  factory TrainTrip.fromJson(Map<String, dynamic> json) {
    return TrainTrip(
      duration: json['solution']['duration'],
      departureTime: DateTime.parse(json['solution']['departureTime']),
      arrivalTime: DateTime.parse(json['solution']['arrivalTime']),
      origin: json['solution']['origin'],
      destination: json['solution']['destination'],
      amount: json['solution']['price']['amount'].toDouble(),
    );
  }
}
