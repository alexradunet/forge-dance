import 'package:flutter/widgets.dart';
import 'package:forge_dance/design_system/molecules/inputs/fg_radio_group.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_radio_group.stories.g.dart';

const meta = Meta(FgStringRadioGroupPreview.new);

final $Playground = _Story(name: 'Playground');

class FgStringRadioGroupPreview extends StatefulWidget {
  const FgStringRadioGroupPreview({
    super.key,
    this.initialValue = 'house',
    this.semanticLabel = 'Preferred dance style',
  });

  final String initialValue;
  final String semanticLabel;

  @override
  State<FgStringRadioGroupPreview> createState() =>
      _FgStringRadioGroupPreviewState();
}

class _FgStringRadioGroupPreviewState extends State<FgStringRadioGroupPreview> {
  late String _selectedValue = widget.initialValue;

  @override
  void didUpdateWidget(covariant FgStringRadioGroupPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _selectedValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FgRadioGroup<String>(
      semanticLabel: widget.semanticLabel,
      selectedValue: _selectedValue,
      items: const [
        FgRadioGroupItem(
          label: 'Hip hop',
          value: 'hip-hop',
          description: 'Groove, bounce, and musicality',
        ),
        FgRadioGroupItem(
          label: 'House',
          value: 'house',
          description: 'Footwork, jacking, and flow',
        ),
        FgRadioGroupItem(
          label: 'Breaking',
          value: 'breaking',
          description: 'Toprock, footwork, and freezes',
        ),
      ],
      onChanged: (value) => setState(() => _selectedValue = value),
    );
  }
}
