class GiftInEvent {
  final int? id;
  final String title;
  final String eventDate;
  final String? location;
  final int totalAmount;
  final int costAmount;
  final String? remark;
  final String? createdAt;

  GiftInEvent({
    this.id,
    required this.title,
    required this.eventDate,
    this.location,
    this.totalAmount = 0,
    this.costAmount = 0,
    this.remark,
    this.createdAt,
  });

  factory GiftInEvent.fromMap(Map<String, dynamic> map) {
    return GiftInEvent(
      id: map['id'] as int?,
      title: map['title'] as String,
      eventDate: map['event_date'] as String,
      location: map['location'] as String?,
      totalAmount: map['total_amount'] as int? ?? 0,
      costAmount: map['cost_amount'] as int? ?? 0,
      remark: map['remark'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'event_date': eventDate,
      'location': location,
      'total_amount': totalAmount,
      'cost_amount': costAmount,
      'remark': remark,
      'created_at': createdAt,
    };
  }

  GiftInEvent copyWith({
    int? id,
    String? title,
    String? eventDate,
    String? location,
    int? totalAmount,
    int? costAmount,
    String? remark,
    String? createdAt,
  }) {
    return GiftInEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      eventDate: eventDate ?? this.eventDate,
      location: location ?? this.location,
      totalAmount: totalAmount ?? this.totalAmount,
      costAmount: costAmount ?? this.costAmount,
      remark: remark ?? this.remark,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
