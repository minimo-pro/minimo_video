import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../models/compression_settings.dart';
import '../services/compression_service.dart';
import '../services/file_service.dart';
import '../services/utils.dart';
import '../widgets/crf_slider.dart';
import '../widgets/size_row.dart';

@RoutePage()
class CompressScreen extends StatefulWidget {
  final PickedVideo? initialVideo;

  const CompressScreen({super.key, this.initialVideo});

  @override
  State<CompressScreen> createState() => _CompressScreenState();
}

class _CompressScreenState extends State<CompressScreen> {
  final _fileService = FileService();
  final _compressionService = CompressionService();

  PickedVideo? _video;
  int? _compressedSize;
  String? _outputPath;
  bool _loading = false;
  bool _processing = false;
  bool _done = false;
  final _settings = CompressionSettings();

  static const _presets = ['ultrafast', 'fast', 'medium', 'slow'];
  static const _resolutions = <String?>[null, '1920:1080', '1280:720', '854:480'];

  @override
  @override
  void initState() {
    super.initState();
    if (widget.initialVideo != null) {
      _video = widget.initialVideo;
    }
  }

  bool get _showSettings => _video != null && !_processing && !_done;

  Future<void> _pickVideo() async {
    setState(() => _loading = true);

    try {
      final video = await _fileService.pickVideo();
      if (video != null) {
        setState(() {
          _video = video;
          _done = false;
          _outputPath = null;
          _compressedSize = null;
        });
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _compress() async {
    if (_video == null) return;

    final outputPath = FileService.tempOutputPath;
    final command = _settings.buildCommand(_video!.path, outputPath);

    setState(() => _processing = true);

    final result = await _compressionService.execute(command, outputPath);

    setState(() {
      _compressedSize = result.outputSize;
      _outputPath = result.outputPath;
      _processing = false;
      _done = true;
    });
  }

  Future<void> _save() async {
    if (_outputPath == null) return;
    try {
      await _fileService.saveToGallery(_outputPath!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved to gallery')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('minimo (video)'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_loading) ..._buildLoadingUI(theme),
              if (_video == null && !_processing && !_loading) ..._buildPickUI(theme),
              if (_showSettings && _video != null) ..._buildSettingsUI(theme),
              if (_processing) ..._buildProgressUI(theme),
              if (_done) ..._buildResultUI(theme),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLoadingUI(ThemeData theme) {
    return [
      const SizedBox(width: 100, height: 100, child: CircularProgressIndicator(strokeWidth: 8)),
      const SizedBox(height: 32),
      Text('Loading video...',
        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Text('Please wait',
        style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    ];
  }

  List<Widget> _buildPickUI(ThemeData theme) {
    return [
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(Icons.video_library_rounded, size: 56, color: theme.colorScheme.primary),
      ),
      const SizedBox(height: 32),
      Text('Video Compressor',
        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      Text('Select a video to compress',
        style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: 32),
      FilledButton.icon(
        onPressed: _pickVideo,
        icon: const Icon(Icons.photo_library_rounded),
        label: const Text('Choose from Gallery'),
        style: FilledButton.styleFrom(
          minimumSize: const Size(240, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    ];
  }

  List<Widget> _buildSettingsUI(ThemeData theme) {
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.check_circle, size: 44, color: Colors.green.shade400),
              ),
              const SizedBox(height: 16),
              Text(_video!.name,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(Utils.formatSize(_video!.size),
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              _sectionHeader('Quality', theme),
              const SizedBox(height: 8),
              CrfSlider(value: _settings.crf, onChanged: (v) => setState(() => _settings.crf = v)),
              const SizedBox(height: 20),
              _sectionHeader('Speed', theme),
              const SizedBox(height: 8),
              _buildChipRow(_presets, _settings.preset, (v) => setState(() => _settings.preset = v)),
              const SizedBox(height: 20),
              _sectionHeader('Resolution', theme),
              const SizedBox(height: 8),
              _buildResolutionChips(theme),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _compress,
                icon: const Icon(Icons.compress_rounded),
                label: const Text('Compress Video'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(240, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => setState(() => _video = null),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Choose another video'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _sectionHeader(String title, ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildChipRow(List<String> items, String selected, ValueChanged<String> onChanged) {
    return Row(
      children: items.map((item) {
        final isSelected = selected == item;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(_presetLabel(item)),
            selected: isSelected,
            onSelected: (_) => onChanged(item),
          ),
        );
      }).toList(),
    );
  }

  String _presetLabel(String p) {
    switch (p) {
      case 'ultrafast': return 'Ultra Fast';
      case 'fast': return 'Fast';
      case 'medium': return 'Medium';
      case 'slow': return 'Slow';
      default: return p;
    }
  }

  Widget _buildResolutionChips(ThemeData theme) {
    return Row(
      children: _resolutions.map((r) {
        final isSelected = _settings.resolution == r;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(_resolutionLabel(r)),
            selected: isSelected,
            onSelected: (_) => setState(() => _settings.resolution = r),
          ),
        );
      }).toList(),
    );
  }

  String _resolutionLabel(String? r) {
    if (r == null) return 'Original';
    switch (r) {
      case '1920:1080': return '1080p';
      case '1280:720': return '720p';
      case '854:480': return '480p';
      default: return r;
    }
  }

  List<Widget> _buildProgressUI(ThemeData theme) {
    return [
      const SizedBox(width: 100, height: 100, child: CircularProgressIndicator(strokeWidth: 8)),
      const SizedBox(height: 32),
      Text('Compressing...',
        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Text('Please wait, this may take a while',
        style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    ];
  }

  List<Widget> _buildResultUI(ThemeData theme) {
    final vidSize = _video?.size;
    final savings = vidSize != null && _compressedSize != null
        ? Utils.savingsPercent(vidSize, _compressedSize!)
        : '0';

    return [
      Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.check_circle, size: 44, color: Colors.green.shade400),
      ),
      const SizedBox(height: 24),
      Text('Compression Complete!',
        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 4),
      Text(Utils.formatSize(_compressedSize ?? 0),
        style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
      ),
      const SizedBox(height: 24),
      if (vidSize != null && _compressedSize != null) ...[
        SizeRow(label: 'Original', size: vidSize, color: Colors.grey),
        const SizedBox(height: 8),
        SizeRow(label: 'Compressed', size: _compressedSize!, color: Colors.green),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.trending_down, color: Colors.green.shade600, size: 22),
              const SizedBox(width: 8),
              Text('-$savings%',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green.shade600),
              ),
            ],
          ),
        ),
      ],
      const SizedBox(height: 8),
      Text(
        'Settings: ${_settings.qualityLabel.toLowerCase()} quality, ${_settings.presetLabel.toLowerCase()}, ${_settings.resolutionLabel.toLowerCase()}',
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: 24),
      FilledButton.icon(
        onPressed: _save,
        icon: const Icon(Icons.save_alt_rounded),
        label: const Text('Save to Gallery'),
        style: FilledButton.styleFrom(
          minimumSize: const Size(240, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      const SizedBox(height: 12),
      TextButton.icon(
        onPressed: () => setState(() {
          _video = null;
          _compressedSize = null;
          _outputPath = null;
          _done = false;
        }),
        icon: const Icon(Icons.compress_rounded),
        label: const Text('Compress another video'),
      ),
    ];
  }
}
