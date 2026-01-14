import 'package:flutter/material.dart';

class GiftInEditPage extends StatefulWidget {
  const GiftInEditPage({super.key});

  @override
  State<GiftInEditPage> createState() => _GiftInEditPageState();
}

class _GiftInEditPageState extends State<GiftInEditPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _guestRemarkController = TextEditingController();

  final _amountController = TextEditingController();
  final _giftController = TextEditingController();
  final _giftRemarkController = TextEditingController();

  String? _relation;
  final _relations = ['亲戚', '朋友', '同事', '同学', '其他'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('新增入礼'),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        child: Column(
          children: [
            _buildGuestCard(),
            const SizedBox(height: 12),
            _buildGiftCard(),
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(),
    );
  }

  /// ================= 宾客信息 =================
  Widget _buildGuestCard() {
    return _buildCard(
      title: '宾客信息',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _input(
                  controller: _nameController,
                  label: '姓名 *',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _dropdown(
                  label: '关系',
                  value: _relation,
                  items: _relations,
                  onChanged: (v) => setState(() => _relation = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _input(
            controller: _phoneController,
            label: '电话',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          _textarea(
            controller: _guestRemarkController,
            label: '宾客备注',
            hint: '例如：同村亲戚',
          ),
        ],
      ),
    );
  }

  /// ================= 礼物信息 =================
  Widget _buildGiftCard() {
    return _buildCard(
      title: '礼物信息',
      child: Column(
        children: [
          _moneyInput(),
          const SizedBox(height: 12),
          _input(
            controller: _giftController,
            label: '礼品',
            hint: '如：烟酒、水果',
          ),
          const SizedBox(height: 12),
          _textarea(
            controller: _giftRemarkController,
            label: '礼物备注',
            hint: '请输入备注信息',
          ),
        ],
      ),
    );
  }

  /// ================= 通用组件 =================
  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _decoration(label, hint: hint),
    );
  }

  Widget _textarea({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      maxLines: 3,
      maxLength: 100,
      decoration: _decoration(label, hint: hint),
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _decoration(label),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _moneyInput() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: _decoration('礼金').copyWith(
        prefixText: '¥ ',
      ),
    );
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8F9FB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  /// ================= 底部保存 =================
  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            onPressed: _onSave,
            child: const Text(
              '保存',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void _onSave() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请输入姓名')));
      return;
    }

    // TODO：这里接 Provider / 数据库保存
    Navigator.pop(context);
  }
}
