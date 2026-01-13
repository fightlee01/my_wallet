import 'package:flutter/material.dart';
import 'package:my_wallet/models/relation.dart';

class RelationPickerDialog extends StatelessWidget {
  final List<Relation> relations;
  final int selectedId;
  final ValueChanged<Relation> onSelected;

  const RelationPickerDialog({
    super.key,
    required this.relations,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '选择关系',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...relations.map(
            (r) => ListTile(
              title: Text(r.name),
              trailing: r.id == selectedId
                  ? const Icon(Icons.check, color: Colors.red)
                  : null,
              onTap: () {
                onSelected(r);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
