import 'package:flutter/material.dart';

class MultiDaySelectTextField extends StatefulWidget {
  @override
  _MultiDaySelectTextFieldState createState() => _MultiDaySelectTextFieldState();
}

class _MultiDaySelectTextFieldState extends State<MultiDaySelectTextField> {
  TextEditingController _controller = TextEditingController();
  List<String> _selectedDays = [];

  final List<String> _daysList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  Future<void> _selectDays(BuildContext context) async {
    List<bool> isSelected = List.generate(_daysList.length, (index) => _selectedDays.contains(_daysList[index]));

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Days'),
          content: MultiSelectChip(
            daysList: _daysList,
            isSelected: isSelected,
            onSelectionChanged: (List<bool> selected) {
              setState(() {
                isSelected = selected;
                _selectedDays.clear();
                for (int i = 0; i < isSelected.length; i++) {
                  if (isSelected[i]) {
                    _selectedDays.add(_daysList[i]);
                  }
                }
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Done'),
            ),
          ],
        );
      },
    );

    _controller.text = _formatSelectedDays();
  }

  String _formatSelectedDays() {
    return _selectedDays.join(", ");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDays(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Select Days',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> daysList;
  final List<bool> isSelected;
  final Function(List<bool>) onSelectionChanged;

  MultiSelectChip({
    required this.daysList,
    required this.isSelected,
    required this.onSelectionChanged,
  });

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: List<Widget>.generate(widget.daysList.length, (int index) {
        return FilterChip(
          label: Text(widget.daysList[index]),
          selected: widget.isSelected[index],
          onSelected: (bool selected) {
            setState(() {
              widget.isSelected[index] = selected;
              widget.onSelectionChanged(widget.isSelected);
            });
          },
        );
      }).toList(),
    );
  }
}
