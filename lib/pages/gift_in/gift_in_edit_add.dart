import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wallet/models/gift_in_event.dart';
import 'package:my_wallet/models/person.dart';
import 'package:my_wallet/providers/gift_in_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/models/relation.dart';
import 'package:my_wallet/models/git_in_detail.dart';

class GiftInEditAddPersonPage extends StatefulWidget {
  // When saved, this page will Navigator.pop(context, Map<String, dynamic> event)
  // bool isEdit = false;
  const GiftInEditAddPersonPage({super.key});

  @override
  _GiftInEditAddPersonPageState createState() => _GiftInEditAddPersonPageState();
}

class _GiftInEditAddPersonPageState extends State<GiftInEditAddPersonPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _giftAmountController = TextEditingController();
  final TextEditingController _costAmountController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();


  @override
  void dispose() {
    _nameController.dispose();
    _giftAmountController.dispose();
    _giftController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final giftAmount = int.tryParse(_totalAmountController.text.trim()) ?? 0;
    final costAmount = int.tryParse(_costAmountController.text.trim()) ?? 0;
    final remark = _remarkController.text.trim().isEmpty ? null : _remarkController.text.trim();

    final person = Person(
      name: name,
      relation: context.read<GiftInProvider>().selectedRelationIdForAdd,
      remark: remark,
      // 'created_at' can be set by DB; include if desired:
      // 'created_at': DateTime.now().toIso8601String(),
    );
    final giftInDetail = GiftInDetail(
      eventId: context.read<GiftInProvider>().selectedEvent!.id!,
      personId: -3,
      amount: giftAmount,
      personName: name,
      relation: '',
      remark: remark,
    );
    final result = context.read<GiftInProvider>().addSinglePerson(person, giftInDetail);
    if (result == -2) {
      // Name already exists
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('该姓名已存在，请修改后重试')),
      );
      return;
    }
    Navigator.of(context).pop(person);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<GiftInProvider>();

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
                        controller: _nameController,
                        label: '姓名 *',
                        hint: '例如：张三',
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? '请填写姓名' : null,
                      ),
                      const SizedBox(height: 16),

                      _buildRelationSelector(text: provider.selectedRelationForAdd ?? '请选择关系', onTap: () => _showRelationSelector(context, provider)),
                      const SizedBox(height: 16),

                      _buildDateField(),
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

  Widget _buildRelationSelector({
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            const SizedBox(width: 8),
            const Icon(Icons.filter_list),
            // const Icon(Icons.keyboard_arrow_down, size: 20),
          ],
        ),
      ),
    );
  }

  void _showRelationSelector(
    BuildContext context,
    GiftInProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView(
            shrinkWrap: true,
            children: provider.oriRelations.map((e) {
              return ListTile(
                title: Text(e.name),
                onTap: () {
                  provider.setSelectRelationForAdd(e.name, e.id);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

}

