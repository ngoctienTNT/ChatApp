import 'package:flutter/material.dart';

class SectionModel extends StatelessWidget {
  const SectionModel(this._title, this._content, this._onSeeAllPressed, {Key? key}) : super(key: key);
  final String _title;
  final Function() _onSeeAllPressed;
  final Widget _content;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [Text(_title), TextButton(onPressed: _onSeeAllPressed, child: const Text('See all'))],
        ),
        _content
      ],
    );
  }
}
