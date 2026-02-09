import 'package:flutter/material.dart';

/// ================= 通用输入框 =================
///
/// 用法：
/// - 普通文本
/// - 数字 / 金额
/// - 多行备注
/// - 只读（如日期选择）
class FormInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? iconData;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final VoidCallback? onTap;

  const FormInput({
    super.key,
    required this.controller,
    required this.label,
    this.iconData,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      readOnly: onTap != null,
      onTap: onTap,
      decoration: _decoration(),
    );
  }

  InputDecoration _decoration() {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8F9FB),
      prefixIcon: iconData != null ? Icon(iconData) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}

/// ================= 多行文本（语义封装） =================
class FormTextarea extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  const FormTextarea({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return FormInput(
      controller: controller,
      label: label,
      hint: hint,
      maxLines: 3,
      maxLength: 100,
    );
  }
}

/// ================= 金额输入（语义封装） =================
class FormMoneyInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const FormMoneyInput({
    super.key,
    required this.controller,
    this.label = '金额',
  });

  @override
  Widget build(BuildContext context) {
    return FormInput(
      controller: controller,
      label: label,
      iconData: Icons.currency_yuan,
      keyboardType: TextInputType.number,
    );
  }
}
