import 'package:flutter/material.dart';
import '../../services/gift_in_excel_import_services.dart';

class GiftInExcelImportPage extends StatefulWidget {
  final int eventId;

  const GiftInExcelImportPage({
    super.key,
    required this.eventId,
  });

  @override
  State<GiftInExcelImportPage> createState() =>
      _GiftInExcelImportPageState();
}

class _GiftInExcelImportPageState extends State<GiftInExcelImportPage> {
  bool _loading = false;

  Future<void> _import() async {
    setState(() => _loading = true);

    final result = await GiftInExcelImportService.import(
      context: context,
      eventId: widget.eventId,
    );

    setState(() => _loading = false);

    if (!mounted || result == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('导入完成'),
        content: Text(
          '成功导入：${result.success} 条\n'
          '跳过无效：${result.skipped} 条',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true); // 返回并刷新
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel 批量导入宾客'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Excel 格式要求：',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('姓名 | 关系 | 金额 | 礼品 | 备注'),
            const SizedBox(height: 24),

            _loading
                ? const Center(child: CircularProgressIndicator())
                : FilledButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text('选择 Excel 文件并导入'),
                    onPressed: _import,
                  ),
          ],
        ),
      ),
    );
  }
}
