class Customer {
  final int? id;
  final int? userId;
  final String? deletedAt;
  final String? createdAt;
  final List<dynamic>? favorites;

  Customer({
    this.id,
    this.userId,
    this.deletedAt,
    this.createdAt,
    this.favorites,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      userId: json['user_id'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      favorites: (json['favorites'] as List?)?.map((e) => e).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'favorites': favorites,
    };
  }
}
