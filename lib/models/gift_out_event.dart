class GiftOutEvent {
  final int? id;
  final String title;
  final String? remark;

  GiftOutEvent({
    this.id,
    required this.title,
    this.remark,
  });

  factory GiftOutEvent.fromMap(Map<String, dynamic> map) {
    return GiftOutEvent(
      id: map['id'] as int?,
      title: map['title'],
      remark: map['remark'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'remark': remark,
    };
  }
}
