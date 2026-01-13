import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wallet/models/gift_in_event.dart';
import 'package:my_wallet/providers/gift_in_provider.dart';
import 'package:provider/provider.dart';

class GiftInAddEventsPage extends StatefulWidget {
  // When saved, this page will Navigator.pop(context, Map<String, dynamic> event)
  const GiftInAddEventsPage({Key? key}) : super(key: key);

  @override
  _GiftInAddEventsPageState createState() => _GiftInAddEventsPageState();
}

class _GiftInAddEventsPageState extends State<GiftInAddEventsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _costAmountController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // default event_date to today
    _dateController.text = _formatDate(DateTime.now());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _totalAmountController.dispose();
    _costAmountController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(_dateController.text) ?? now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final eventDate = _dateController.text.trim();
    final location = _locationController.text.trim().isEmpty ? null : _locationController.text.trim();
    final totalAmount = int.tryParse(_totalAmountController.text.trim()) ?? 0;
    final costAmount = int.tryParse(_costAmountController.text.trim()) ?? 0;
    final remark = _remarkController.text.trim().isEmpty ? null : _remarkController.text.trim();

    final event = GiftInEvent(
      title: title,
      eventDate: eventDate,
      location: location,
      totalAmount: totalAmount,
      costAmount: costAmount,
      remark: remark,
      // 'created_at' can be set by DB; include if desired:
      // 'created_at': DateTime.now().toIso8601String(),
    );
    context.read<GiftInProvider>().addGiftInEvent(event);
    Navigator.of(context).pop(event);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          '新增入礼事件',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildField(
                        controller: _titleController,
                        label: '标题 *',
                        hint: '例如：张三婚礼',
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? '请填写标题' : null,
                      ),
                      const SizedBox(height: 16),

                      _buildDateField(),
                      const SizedBox(height: 16),

                      _buildField(
                        controller: _locationController,
                        label: '地点',
                        hint: '例如：希尔顿酒店',
                      ),
                      const SizedBox(height: 16),

                      _buildNumberField(
                        controller: _totalAmountController,
                        label: '总额',
                        hint: '收到礼金（元）',
                      ),
                      const SizedBox(height: 16),

                      _buildNumberField(
                        controller: _costAmountController,
                        label: '成本',
                        hint: '随礼或成本（元）',
                      ),
                      const SizedBox(height: 16),

                      _buildField(
                        controller: _remarkController,
                        label: '备注',
                        hint: '可填写关系、备注信息',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 保存按钮
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text(
                  '保存并返回',
                  style: TextStyle(fontSize: 16),
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return null;
        final n = int.tryParse(v.trim());
        if (n == null) return '请输入有效整数';
        if (n < 0) return '不能为负数';
        return null;
      },
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      onTap: _pickDate,
      decoration: InputDecoration(
        labelText: '日期 *',
        filled: true,
        suffixIcon: Icon(Icons.calendar_month),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) =>
          v == null || v.trim().isEmpty ? '请选择日期' : null,
    );
  }

}

