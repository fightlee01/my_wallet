import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/gift_out.dart';
import '../../models/person.dart';
import '../../providers/person_provider.dart';
import '../../providers/gift_out_provider.dart';

class GiftOutAddPage extends StatefulWidget {
  const GiftOutAddPage({super.key});

  @override
  State<GiftOutAddPage> createState() => _GiftOutAddPageState();
}

class _GiftOutAddPageState extends State<GiftOutAddPage> {
  final _formKey = GlobalKey<FormState>();

  Person? _selectedPerson;
  DateTime _date = DateTime.now();

  final _moneyController = TextEditingController();
  final _giftController = TextEditingController();
  final _locationController = TextEditingController();
  final _remarkController = TextEditingController();

  @override
  void dispose() {
    _moneyController.dispose();
    _giftController.dispose();
    _locationController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (result != null) {
      setState(() => _date = result);
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPerson == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请选择送礼对象')));
      return;
    }

    final money = _moneyController.text.isEmpty
        ? null
        : double.tryParse(_moneyController.text);

    final giftOut = GiftOut(
      personId: _selectedPerson!.id!,
      date: _date.millisecondsSinceEpoch,
      money: money,
      gift: _giftController.text.trim().isEmpty
          ? null
          : _giftController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      remark: _remarkController.text.trim().isEmpty
          ? null
          : _remarkController.text.trim(),
    );

    await context.read<GiftOutProvider>().add(giftOut);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final persons = context.watch<PersonProvider>().list;

    return Scaffold(
      appBar: AppBar(
        title: const Text('新增送礼'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text('保存'),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// 人物选择
            DropdownButtonFormField<Person>(
              decoration: const InputDecoration(
                labelText: '送礼对象',
                border: OutlineInputBorder(),
              ),
              items: persons
                  .map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Text('${p.name}（${p.relation}）'),
                    ),
                  )
                  .toList(),
              value: _selectedPerson,
              onChanged: (v) => setState(() => _selectedPerson = v),
              validator: (v) => v == null ? '请选择人物' : null,
            ),

            const SizedBox(height: 16),

            /// 日期
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: '送礼日期',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 礼金
            TextFormField(
              controller: _moneyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '礼金（元）',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// 礼品
            TextFormField(
              controller: _giftController,
              decoration: const InputDecoration(
                labelText: '礼品',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// 地点
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: '地点',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// 备注
            TextFormField(
              controller: _remarkController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '备注',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
