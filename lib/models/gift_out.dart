class GiftOut {
  final int? id;
  final int personId;
  final int date;
  final double? money;
  final String? gift;
  final String? location;
  final String? remark;

  GiftOut({
    this.id,
    required this.personId,
    required this.date,
    this.money,
    this.gift,
    this.location,
    this.remark,
  });

  factory GiftOut.fromMap(Map<String, dynamic> map) {
    return GiftOut(
      id: map['id'],
      personId: map['person_id'],
      date: map['date'],
      money: map['money'],
      gift: map['gift'],
      location: map['location'],
      remark: map['remark'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'person_id': personId,
      'date': date,
      'money': money,
      'gift': gift,
      'location': location,
      'remark': remark,
    };
  }
}
