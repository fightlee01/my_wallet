class GiftOutDetail {
  final int? id;
  final int eventId;
  final int personId;
  final int giftOutAmount;
  final String? gift;
  final String? remark;
  final String giftOutDate;

  /// UI 常用冗余字段（非数据库字段）
  final String personName;
  final String? relation;
  final int? relationId;
  final String? phone;
  final String? personRemark;


  GiftOutDetail({
    this.id,
    required this.eventId,
    required this.personId,
    required this.giftOutAmount,
    this.gift,
    this.remark,
    required this.personName,
    required this.relation,
    this.relationId,
    this.phone,
    this.personRemark,
    required this.giftOutDate,
  });

  factory GiftOutDetail.fromMap(Map<String, dynamic> map) {
    return GiftOutDetail(
      id: map['id'] as int?,
      eventId: map['event_id'] as int,
      personId: map['person_id'] as int,
      giftOutAmount: map['gift_out_amount'] as int,
      gift: map['gift'] as String?,
      remark: map['remark'] as String?,
      personName: map['person_name'] as String,
      relation: map['relation'] as String?,
      relationId: map['relation_id'] as int?,
      phone: map['phone'] as String?,
      personRemark: map['person_remark'] as String?,
      giftOutDate: map['gift_out_date'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_id': eventId,
      'person_id': personId,
      'gift_out_amount': giftOutAmount,
      'gift': gift,
      'remark': remark,
      'person_name': personName,
      'relation': relation,
      'relation_id': relationId,
      'phone': phone,
      'person_remark': personRemark,
      'gift_out_date': giftOutDate,
    };
  }

  GiftOutDetail copyWith({
    int? id,
    int? eventId,
    int? personId,
    int? giftOutAmount,
    String? gift,
    String? remark,
    String? createdAt,
    String? personName,
    String? relation,
    int? relationId,
    String? phone,
    String? personRemark,
    String? giftOutDate,
  }) {
    return GiftOutDetail(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      personId: personId ?? this.personId,
      giftOutAmount: giftOutAmount ?? this.giftOutAmount,
      gift: gift ?? this.gift,
      remark: remark ?? this.remark,
      personName: personName ?? this.personName,
      relation: relation ?? this.relation,
      relationId: relationId ?? this.relationId,
      phone: phone ?? this.phone,
      personRemark: personRemark ?? this.personRemark,
      giftOutDate: giftOutDate ?? this.giftOutDate,
    );
  }
}