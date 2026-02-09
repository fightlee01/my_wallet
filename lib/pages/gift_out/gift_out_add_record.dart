import 'package:flutter/material.dart';
import 'package:my_wallet/models/gift_out_detail.dart';
import 'package:my_wallet/providers/gift_out_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/constants/error_codes.dart';
import './widgets/form/form_input.dart';
import './widgets/form/form_dropdown.dart';
import './widgets/form/form_date_picker.dart';
import 'package:my_wallet/widgets/confirm_dialog.dart';

class GiftOutAddEditPage extends StatefulWidget {
  final GiftOutDetail? detail;
  const GiftOutAddEditPage({super.key, this.detail});

  @override
  State<GiftOutAddEditPage> createState() => _GiftOutAddEditPageState();
}

class _GiftOutAddEditPageState extends State<GiftOutAddEditPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _guestRemarkController = TextEditingController();

  final _amountController = TextEditingController();
  final _giftController = TextEditingController();
  // 日期
  final _giftDateController = TextEditingController();
  final _giftRemarkController = TextEditingController();
  String _selectedRelation = '';
  int? _selectedEventId = 0;
  int? _selectedRelationId;
  String _selectedEvent = '';

  @override
  void initState() {
    super.initState();
    // 初始化数据
    if (widget.detail != null) {
      _nameController.text = widget.detail!.personName;
      _amountController.text = widget.detail!.giftOutAmount.toString();
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
    return Consumer<GiftOutProvider>(
      builder: (context, provider, _) {
        return _buildBody(context, provider);
      },
    );
  }

  Widget _buildBody(BuildContext context, GiftOutProvider provider) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: Text(widget.detail != null ? '编辑送礼' : '新增送礼'),
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
            _buildGiftReasonsCard(provider),
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
  Widget _buildGuestCard(GiftOutProvider provider) {
    return _buildCard(
      title: '送礼对象',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FormInput(
                  controller: _nameController,
                  label: '姓名 *',
                  iconData: Icons.person,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FormDropdown(
                  label: '关系',
                  items: provider.relations,
                  onChanged: (v) => _onRelationChanged(provider, v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FormInput(
            controller: _phoneController,
            label: '电话',
            iconData: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          FormTextarea(
            controller: _guestRemarkController,
            label: '宾客备注',
            hint: '例如：同事',
          ),
        ],
      ),
    );
  }

  // ================= 送礼事由 =================
  Widget _buildGiftReasonsCard(GiftOutProvider provider) {
    return _buildCard(
      title: '送礼事由',
      child: Column(
        children: [
          FormDropdown(
            label: '送礼事由',
            items: provider.events.map((e) => e.title).toList(),
            onChanged: (v) => _onSelectEventChanged(provider, v),
          ),
          const SizedBox(height: 12),
          FormDatePicker(
            label: '送礼日期',
            value: widget.detail != null
                ? DateTime.parse(widget.detail!.giftOutDate!)
                : DateTime.parse(_giftDateController.text),
            onChanged: (v) {
              setState(() {
                _giftDateController.text =
                    '${v.year}-${v.month.toString().padLeft(2, '0')}-${v.day.toString().padLeft(2, '0')}';
              });
            },
          ),
        ],
      ),
    );
  }

  /// ================= 礼物信息 =================
  Widget _buildGiftCard(GiftOutProvider provider) {
    return _buildCard(
      title: '礼物信息',
      child: Column(
        children: [
          FormInput(
            controller: _amountController,
            label: '礼金',
            iconData: Icons.currency_yuan,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          FormInput(
            controller: _giftController,
            label: '礼品',
            iconData: Icons.card_giftcard,
            hint: '如：烟酒、水果',
          ),
          const SizedBox(height: 12),
          FormTextarea(
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
  /// ================= 底部保存 =================
  Widget _buildBottomBar(GiftOutProvider provider) {
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

  void _onRelationChanged(GiftOutProvider provider, String? value) {
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

  void _onSelectEventChanged(GiftOutProvider provider, String? event) {
    provider.events.firstWhere((element) {
      if (element.title == event) {
        _selectedEvent = element.title;
        _selectedEventId = element.id;
        return true;
      }
      return false;
    });
  }

  Future<void> _onSave(GiftOutProvider provider) async {
    // 校验必填项
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写姓名')),
      );
      return;
    }
    if (_selectedEvent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择送礼事由')),
      );
      return;
    }
    if (_amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写礼金金额')),
      );
      return;
    }

    if (widget.detail == null) {
        // 新增宾客
      Map<String, dynamic> person = {};
      person['name'] = _nameController.text.trim();
      person['phone'] = _phoneController.text.trim();
      person['relation'] = _selectedRelationId ?? 0;
      person['remark'] = _guestRemarkController.text.trim();
      int personId = await provider.getPersonIdByName(_nameController.text.trim());
      if (personId != DBErrorCodes.personNotFound) {
        if (!mounted) return;
        bool isUpdatePerson = await ConfirmDialog.show(
          context,
          title: '宾客已存在',
          content: '该姓名的宾客已存在，是否更新其信息？',
          confirmText: '更新',
          cancelText: '取消',
        );
        if (isUpdatePerson) {
          // provider.updatePerson(personId, person);
        }
      } else {
        personId = await provider.insertPerson(person);
      }
      
      Map<String, dynamic> detail = {};
      detail['event_id'] = _selectedEventId;
      detail['person_id'] = personId;
      detail['gift_out_amount'] = int.parse(_amountController.text.trim());
      detail['gift'] = _giftController.text.trim();
      detail['remark'] = _giftRemarkController.text.trim();
      detail['gift_out_date'] = _giftDateController.text.trim();
      print('detail: $detail');


    }

    // 保存数据
    if (widget.detail != null) {
      // await provider.update(detail);
    } else {
      // await provider.add(detail);
    }

    if (!mounted) return;
    // Navigator.pop(context);
  }
}