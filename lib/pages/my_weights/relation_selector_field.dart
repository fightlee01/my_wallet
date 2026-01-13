import 'package:flutter/material.dart';
import 'package:my_wallet/models/relation.dart';
import 'relation_picker.dart';

class RelationSelectorField extends StatelessWidget {
  final String label;
  final List<Relation> relations;
  final int selectedId;
  final ValueChanged<Relation> onChanged;

  const RelationSelectorField({
    super.key,
    this.label = '关系',
    required this.relations,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = relations.firstWhere(
      (e) => e.id == selectedId,
      orElse: () => Relation(id: 0, name: '未设置'),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _show(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selected.name,
                style: TextStyle(
                  color: selectedId == 0 ? Colors.grey : Colors.black,
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  void _show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return RelationPickerDialog(
          relations: relations,
          selectedId: selectedId,
          onSelected: onChanged,
        );
      },
    );
  }
}
