class DBErrorCodes {
  // 人员名称已存在
  static const int personNameExists = -1001;
  // 根据姓名未找到人员 ID
  static const int personNotFound = -1002;
  // 插入人员时的其他错误
  static const int personInsertError = -1003;
  // 收礼明细已存在
  static const int detailExists = -1004;
  // 插入收礼事件时的错误
  static const int detailInsertError = -1005;

}