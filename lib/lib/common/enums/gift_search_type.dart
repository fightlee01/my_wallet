enum GiftSearchType {
  name,
  event,
  relation,
}

enum GiftMenuAction {
  addRecord,
  manageEvent,
}

extension GiftSearchTypeX on GiftSearchType {
  String get label {
    switch (this) {
      case GiftSearchType.name:
        return '姓名';
      case GiftSearchType.event:
        return '事件';
      case GiftSearchType.relation:
        return '关系';
    }
  }
}
