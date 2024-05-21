class TheCountry {
  final String country;
  final List<String> cities;

  TheCountry({required this.country, required this.cities});

  factory TheCountry.fromJson(Map<String, dynamic> json) {
    return TheCountry(
      country: json['country'],
      cities: List<String>.from(json['cities']),
    );
  }
}
