import 'package:flutter/material.dart';
import 'package:my_wallet/models/gift_out_event.dart';
import 'package:my_wallet/providers/gift_out_provider.dart';

class GiftOutEventFormSheet extends StatefulWidget {
  final GiftOutEvent? event;
  final GiftOutProvider provider;

  const GiftOutEventFormSheet({super.key, this.event, required this.provider});

  @override
  State<GiftOutEventFormSheet> createState() =>
      _GiftOutEventFormSheetState();
}

class _GiftOutEventFormSheetState extends State<GiftOutEventFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _remarkController;

  bool get isEdit => widget.event != null;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.event?.title ?? '');
    _remarkController =
        TextEditingController(text: widget.event?.remark ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _submit() async{
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final remark = _remarkController.text.trim();

    if (isEdit) {
      print('更新事件：${widget.event!.id} / $title / $remark');
    } else {
      Map<String, dynamic> newEvent = {
        'title': title,
        'remark': remark,
      };
      await widget.provider.insertGiftOutEvent(newEvent);
    }
    await widget.provider.loadEvents();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: const BoxDecoration(
          color: Color(0xFFF7F4F1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DragHandle(),
              Text(
                isEdit ? '编辑送礼事件' : '添加送礼事件',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              _buildField(
                label: '事件名称 *',
                controller: _titleController,
                hint: '例如：张三结婚',
                validator: (v) =>
                    v == null || v.trim().isEmpty ? '请输入事件名称' : null,
              ),
              const SizedBox(height: 16),
              _buildField(
                label: '备注',
                controller: _remarkController,
                hint: '可选填写',
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A45),
                      ),
                      child: const Text('保存'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
