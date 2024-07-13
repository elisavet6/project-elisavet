class TrainDestination {
  final String label;
  final int locationId;

  TrainDestination({required this.label, required this.locationId});

  factory TrainDestination.fromJson(Map<String, dynamic> json) {
    return TrainDestination(
        label: json['label'], locationId: json['locationId']);
  }
}
