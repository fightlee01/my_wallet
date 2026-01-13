class Relation {
  final int? id;
  final String name;
  final String? remark;
  final int? sort;
  final String? createdAt;

  Relation({
    this.id,
    required this.name,
    this.remark,
    this.sort,
    this.createdAt,
  });

  factory Relation.fromMap(Map<String, dynamic> map) {
    return Relation(
      id: map['id'] as int,
      name: map['name'] as String,
      remark: map['remark'],
      sort: map['sort'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'remark': remark,
      'sort': sort,
      'created_at': createdAt,
    };
  }
}
