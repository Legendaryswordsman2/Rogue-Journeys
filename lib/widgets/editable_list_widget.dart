import 'package:flutter/material.dart';

class EditableList extends StatefulWidget {
  const EditableList({
    super.key,
    this.title = "",
    this.inputBoxHint = "Add Item",
  });

  final String title;
  final String inputBoxHint;

  @override
  State<EditableList> createState() => _EditableListState();
}

class _EditableListState extends State<EditableList> {
  final List<String> items = ["Category 1", "Category 2", "Category 3"];

  final TextEditingController controller = TextEditingController();

  void addItem() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      items.add(controller.text.trim());
      controller.clear();
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          if (widget.title.isNotEmpty)
            Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: widget.inputBoxHint),
                  ),
                ),

                IconButton(onPressed: addItem, icon: const Icon(Icons.add)),
              ],
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index]),

                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => removeItem(index),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
