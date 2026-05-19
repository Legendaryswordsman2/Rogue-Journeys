import 'package:flutter/material.dart';

class EditableList extends StatefulWidget {
  EditableList({
    super.key,
    this.title = "",
    List<String>? initialItems,
    this.inputBoxHint = "Add Item",
    this.onListChanged,
  }) : items = initialItems ?? [];

  final String title;
  final String inputBoxHint;
  final List<String> items;

  final void Function(List<String>)? onListChanged;

  @override
  State<EditableList> createState() => _EditableListState();
}

class _EditableListState extends State<EditableList> {
  final TextEditingController controller = TextEditingController();

  void addItem() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      widget.items.add(controller.text.trim());
      controller.clear();
      widget.onListChanged?.call(widget.items);
    });
  }

  void removeItem(int index) {
    setState(() {
      widget.items.removeAt(index);
      widget.onListChanged?.call(widget.items);
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
                    onSubmitted: (value) => addItem(),
                    controller: controller,
                    decoration: InputDecoration(hintText: widget.inputBoxHint),
                  ),
                ),

                IconButton(onPressed: addItem, icon: const Icon(Icons.add)),
              ],
            ),
          ),

          ReorderableListView.builder(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;

                final item = widget.items.removeAt(oldIndex);
                widget.items.insert(newIndex, item);
                widget.onListChanged?.call(widget.items);
              });
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.items.length,
            buildDefaultDragHandles: true,
            itemBuilder: (context, index) {
              return ListTile(
                key: ValueKey(index),
                title: Text(widget.items[index]),

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
