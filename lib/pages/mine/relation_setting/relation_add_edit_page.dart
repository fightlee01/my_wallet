import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/relation.dart';
import '../../../providers/relation_provider.dart';

class RelationEditPage extends StatefulWidget {
  final Relation? relation;

  const RelationEditPage({super.key, this.relation});

  @override
  State<RelationEditPage> createState() => _RelationEditPageState();
}

class _RelationEditPageState extends State<RelationEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _remarkController = TextEditingController();

  bool get isEdit => widget.relation != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      _nameController.text = widget.relation!.name;
      _remarkController.text = widget.relation!.remark ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? '编辑关系' : '添加关系'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildNameField(),
              const SizedBox(height: 12),
              _buildRemarkField(),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _submit,
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

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: '关系名称',
        hintText: '如：朋友 / 同事 / 亲戚',
        border: OutlineInputBorder(),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return '请输入关系名称';
        }
        return null;
      },
    );
  }

  Widget _buildRemarkField() {
    return TextFormField(
      controller: _remarkController,
      decoration: const InputDecoration(
        labelText: '备注（可选）',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final relation = Relation(
      id: widget.relation?.id,
      name: _nameController.text.trim(),
      remark: _remarkController.text.trim(),
      sort: 0,
      createdAt: DateTime.now().toString(),
    );

    final provider = context.read<RelationProvider>();

    if (isEdit) {
      await provider.updateRelation(relation);
    } else {
      await provider.addRelation(relation);
    }

    // Navigator.pop(context, true);
    Navigator.of(context).pop(true);
  }
}
