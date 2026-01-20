class GiftInDetail {
  final int? id;
  final int eventId;
  final int personId;
  final int amount;
  final String? gift;
  final String? remark;
  final String? createdAt;

  /// UI 常用冗余字段（非数据库字段）
  final String personName;
  final String? relation;
  final int? relationId;
  final String? phone;
  final String? personRemark;


  GiftInDetail({
    this.id,
    required this.eventId,
    required this.personId,
    required this.amount,
    this.gift,
    this.remark,
    this.createdAt,
    required this.personName,
    required this.relation,
    this.relationId,
    this.phone,
    this.personRemark,
  });

  factory GiftInDetail.fromMap(Map<String, dynamic> map) {
    return GiftInDetail(
      id: map['id'] as int?,
      eventId: map['event_id'] as int,
      personId: map['person_id'] as int,
      amount: map['amount'] as int,
      gift: map['gift'] as String?,
      remark: map['remark'] as String?,
      createdAt: map['created_at'] as String?,
      personName: map['person_name'] as String,
      relation: map['relation'] as String?,
      relationId: map['relation_id'] as int?,
      phone: map['phone'] as String?,
      personRemark: map['person_remark'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_id': eventId,
      'person_id': personId,
      'amount': amount,
      'gift': gift,
      'remark': remark,
      'created_at': createdAt,
      'person_name': personName,
      'relation': relation,
      'relation_id': relationId,
      'phone': phone,
      'person_remark': personRemark,
    };
  }

  GiftInDetail copyWith({
    int? id,
    int? eventId,
    int? personId,
    int? amount,
    String? gift,
    String? remark,
    String? createdAt,
    String? personName,
    String? relation,
    int? relationId,
    String? phone,
    String? personRemark,
  }) {
    return GiftInDetail(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      personId: personId ?? this.personId,
      amount: amount ?? this.amount,
      gift: gift ?? this.gift,
      remark: remark ?? this.remark,
      createdAt: createdAt ?? this.createdAt,
      personName: personName ?? this.personName,
      relation: relation ?? this.relation,
      relationId: relationId ?? this.relationId,
      phone: phone ?? this.phone,
      personRemark: personRemark ?? this.personRemark,
    );
  }

}