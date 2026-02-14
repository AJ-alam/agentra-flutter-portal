class Package {
  final String id;
  final String title;
  final String description;
  final String location;
  final double price;
  final String duration;
  final String? image;
  final double? rating;
  final int availableSeats;
  final String agentName;

  Package({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.price,
    required this.duration,
    this.image,
    this.rating,
    required this.availableSeats,
    required this.agentName,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration'] ?? '',
      image: json['image'],
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      availableSeats: json['availableSeats'] ?? 0,
      agentName: json['agentName'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'location': location,
      'price': price,
      'duration': duration,
      'image': image,
      'rating': rating,
      'availableSeats': availableSeats,
      'agentName': agentName,
    };
  }
}
