class MyUtils {
  /// 将字符串时间戳转换为 "YYYY-MM-DD" 格式的日期字符串。
  /// 支持：
  /// - 秒级时间戳（10 位，例如 "1625097600"）
  /// - 毫秒级时间戳（13 位，例如 "1625097600000"）
  /// - 带小数的秒（例如 "1625097600.123"）
  /// - ISO 日期字符串（例如 "2021-07-01T00:00:00Z"）
  /// 解析失败时返回空字符串。
  static String timestampToDate(String? timestamp) {
    if (timestamp == null) return '';
    final s = timestamp.trim();
    if (s.isEmpty) return '';

    // 尝试直接解析为数字时间戳
    final numReg = RegExp(r'^\d+(\.\d+)?$');
    if (numReg.hasMatch(s)) {
      try {
        if (s.contains('.')) {
          // 带小数，视为秒
          final d = double.parse(s);
          final ms = (d * 1000).toInt();
          return _formatDate(DateTime.fromMillisecondsSinceEpoch(ms));
        } else {
          final n = int.parse(s);
          // 根据长度判断是秒还是毫秒（常见规则）
          if (s.length == 10) {
            return _formatDate(
                DateTime.fromMillisecondsSinceEpoch(n * 1000));
          } else if (s.length == 13) {
            return _formatDate(DateTime.fromMillisecondsSinceEpoch(n));
          } else if (s.length < 13) {
            // 少于13位但不等于10位，假定为秒
            return _formatDate(
                DateTime.fromMillisecondsSinceEpoch(n * 1000));
          } else {
            // 超过13位，截取高位（可能包含纳秒等），先取低13位
            final ms = int.parse(s.substring(0, 13));
            return _formatDate(DateTime.fromMillisecondsSinceEpoch(ms));
          }
        }
      } catch (_) {
        // 继续尝试其他解析方式
      }
    }

    // 尝试解析为 ISO 日期字符串
    try {
      final dt = DateTime.parse(s);
      return _formatDate(dt);
    } catch (_) {}

    return '';
  }

  static String _formatDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}