import 'package:flutter/material.dart';

class CrfSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const CrfSlider({super.key, required this.value, required this.onChanged});

  @override
  State<CrfSlider> createState() => _CrfSliderState();
}

class _CrfSliderState extends State<CrfSlider> {
  static const _labels = ['High', 'Good', 'Medium', 'Small'];
  static const _values = [18.0, 23.0, 28.0, 33.0];

  String get _label {
    final idx = _values.indexOf(widget.value);
    if (idx != -1) return _labels[idx];
    if (widget.value < 20) return 'High';
    if (widget.value < 25) return 'Good';
    if (widget.value < 31) return 'Medium';
    return 'Small';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_label,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text('CRF ${widget.value.toInt()}',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          SizedBox(
            height: 48,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              ),
              child: Slider(
                value: widget.value,
                min: 18,
                max: 33,
                divisions: 15,
                label: '${widget.value.toInt()}',
                onChanged: widget.onChanged,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Better', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              Text('Smaller', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}
