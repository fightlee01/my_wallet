import 'package:flutter/material.dart';
import 'package:my_wallet/models/git_in_detail.dart';
import 'package:my_wallet/models/person.dart';
import 'package:my_wallet/providers/gift_in_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/constants/error_codes.dart';

class GiftInEditPage extends StatefulWidget {
  final Person? person;
  final GiftInDetail? detail;
  const GiftInEditPage({super.key, this.person, this.detail});

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
  String _selectedRelation = '';
  int? _selectedRelationId;

  @override
  void initState() {
    super.initState();
    // 初始化数据
    if (widget.detail != null) {
      _nameController.text = widget.detail!.personName;
      _amountController.text = widget.detail!.amount.toString();
      _phoneController.text = widget.detail!.phone ?? '';
      _guestRemarkController.text = widget.detail!.personRemark ?? '';
      _giftController.text = widget.detail!.gift ?? '';
      _giftRemarkController.text = widget.detail!.remark ?? '';
      _selectedRelation = widget.detail!.relation ?? '';
      _selectedRelationId = widget.detail!.relationId ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GiftInProvider>(
      builder: (context, provider, _) {
        return _buildBody(context, provider);
      },
    );
  }

  Widget _buildBody(BuildContext context, GiftInProvider provider) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: Text(widget.detail != null ? '编辑入礼' : '新增入礼'),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        child: Column(
          children: [
            _buildGuestCard(provider),
            const SizedBox(height: 12),
            _buildGiftCard(provider),
            const SizedBox(height: 12),
            _buildBottomBar(provider)
          ],
        ),
      ),
      // bottomSheet: _buildBottomBar(),
    );
  }

  /// ================= 宾客信息 =================
  Widget _buildGuestCard(GiftInProvider provider) {
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
                  iconData: Icons.person,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _dropdown(
                  label: '关系',
                  value: _selectedRelation.isNotEmpty ? _selectedRelation : null,
                  items: provider.relations,
                  onChanged: (v) => _onRelationChanged(provider, v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _input(
            controller: _phoneController,
            label: '电话',
            iconData: Icons.phone,
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
  Widget _buildGiftCard(GiftInProvider provider) {
    return _buildCard(
      title: '礼物信息',
      child: Column(
        children: [
          _moneyInput(),
          const SizedBox(height: 12),
          _input(
            controller: _giftController,
            label: '礼品',
            iconData: Icons.card_giftcard,
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
    IconData? iconData,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _decoration(label, iconData, hint: hint),
    );
  }

  Widget _textarea({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? iconData,
  }) {
    return TextField(
      controller: controller,
      maxLines: 3,
      maxLength: 100,
      decoration: _decoration(label, iconData, hint: hint),
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
      decoration: _decoration(label, null),
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
      decoration: _decoration('礼金', Icons.currency_yuan),
    );
  }

  InputDecoration _decoration(String label, IconData? iconData, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      prefixIcon: iconData != null ? Icon(iconData) : null,
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
  Widget _buildBottomBar(GiftInProvider provider) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
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
            onPressed: () => _onSave(provider),
            child: const Text(
              '保存',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void _onRelationChanged(GiftInProvider provider, String? value) {
    provider.oriRelations.firstWhere((element) {
      if (element.name == value) {
        _selectedRelationId = element.id;
        return true;
      }
      return false;
    });
    setState(() {
      _selectedRelation = value ?? '';
    });
  }

  Future<void> _onSave(GiftInProvider provider) async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请输入姓名')));
      return;
    }

    if (_amountController.text.trim().isEmpty || int.tryParse(_amountController.text.trim()) == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请输入正确的礼金金额')));
      return;
    }

    if (widget.detail != null) {
      // 编辑逻辑
      // 比较宾客变化部分
      Map<String, dynamic> changePerson = {};
      if (_nameController.text.trim() != widget.detail!.personName) {
        changePerson['name'] = _nameController.text.trim();
      }
      if (_selectedRelationId != widget.detail!.relationId) {
        changePerson['relation'] = _selectedRelationId;
      }
      if (_phoneController.text.trim() != widget.detail!.phone) {
        changePerson['phone'] = _phoneController.text.trim();
      }
      if (_guestRemarkController.text.trim() != widget.detail!.personRemark) {
        changePerson['remark'] = _guestRemarkController.text.trim();
      }
      if (changePerson.isNotEmpty) {
        int? result = await provider.updatePerson(widget.detail!.personId, changePerson);
        if (result <= 0) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('更新宾客信息失败')));
          return;
        }
      }
      // 比较入礼详情变化部分
      Map<String, dynamic> changeDetail = {};
      if (int.parse(_amountController.text.trim()) != widget.detail!.amount) {
        changeDetail['amount'] = int.parse(_amountController.text.trim());
      }
      if (_giftController.text.trim() != (widget.detail!.gift ?? '')) {
        changeDetail['gift'] = _giftController.text.trim();
      }
      if (_giftRemarkController.text.trim() != (widget.detail!.remark ?? '')) {
        changeDetail['remark'] = _giftRemarkController.text.trim();
      }
      if (changeDetail.isNotEmpty) {
        int? result = await provider.updateGiftInDetail(widget.detail!.id!, changeDetail);
        if (result <= 0) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('更新入礼详情失败')));
          return;
        }
      }
      provider.selectEvent(provider.selectedEvent!); // 刷新数据
      if (!mounted) return;
      Navigator.pop(context);
    } else {
      // 新增逻辑
      Map<String, dynamic> newPerson = {};
      newPerson['name'] = _nameController.text.trim();
      newPerson['relation'] = _selectedRelationId;
      newPerson['phone'] = _phoneController.text.trim();
      newPerson['remark'] = _guestRemarkController.text.trim();
      // 插入宾客信息
      int? personId = await provider.insertPerson(newPerson);
      if (personId == DBErrorCodes.personInsertError) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('插入宾客信息失败')));
        return;
      }
      // 插入入礼详情
      Map<String, dynamic> newGiftInDetail = {};
      newGiftInDetail['person_id'] = personId;
      newGiftInDetail['event_id'] = provider.selectedEvent!.id;
      newGiftInDetail['amount'] = int.parse(_amountController.text.trim());
      newGiftInDetail['gift'] = _giftController.text.trim();
      newGiftInDetail['remark'] = _giftRemarkController.text.trim();
      int? detailId = await provider.insertGiftInDetail(newGiftInDetail, provider.selectedEvent!.id, personId);
      if (detailId == DBErrorCodes.detailExists) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('该宾客入礼详情已存在，请修改后重试')));
        return;
      } else if (detailId == DBErrorCodes.detailInsertError) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('插入入礼详情失败')));
        return;
      }
      provider.selectEvent(provider.selectedEvent!); // 刷新数据
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}