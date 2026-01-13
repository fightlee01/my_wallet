class Person {
  final int? id;
  final String name;
  final int? relation;
  final String? phone;
  final String? remark;
  final String? createdAt;

  Person({
    this.id,
    required this.name,
    this.relation,
    this.phone,
    this.remark,
    this.createdAt,
  });

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'] as int?,
      name: map['name'] as String,
      relation: map['relation'] as int?,
      phone: map['phone'] as String?,
      remark: map['remark'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'phone': phone,
      'remark': remark,
      'created_at': createdAt,
    };
  }

  Person copyWith({
    int? id,
    String? name,
    int? relation,
    String? phone,
    String? remark,
    String? createdAt,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      phone: phone ?? this.phone,
      remark: remark ?? this.remark,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
