import 'package:flutter/material.dart';

import '../data/testimonial.dart';

class TestimonialDropdown extends StatefulWidget {
  const TestimonialDropdown({super.key});

  @override
  State<TestimonialDropdown> createState() => _TestimonialDropdownState();
}

class _TestimonialDropdownState extends State<TestimonialDropdown> {
  final List<TestimonialItem> _data = testimonialList;

  @override
  Widget build(BuildContext context) {
    return _buildPanel();
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((TestimonialItem item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                item.title!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            );
          },
          body: Column(
            children: [
              ListTile(
                title: Text(
                  item.description!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 15)
            ],
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
