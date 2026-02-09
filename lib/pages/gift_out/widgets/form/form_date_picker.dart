import 'package:flutter/material.dart';
import 'form_input.dart';

class FormDatePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  const FormDatePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? ''
        : '${value!.year}-${value!.month.toString().padLeft(2, '0')}-${value!.day.toString().padLeft(2, '0')}';

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(DateTime.now().year + 5),
        );
        if (picked != null) onChanged(picked);
      },
      child: IgnorePointer(
        child: FormInput(
          controller: TextEditingController(text: text),
          label: label,
          iconData: Icons.calendar_month,
        ),
      ),
    );
  }
}
