import 'package:flutter/material.dart';

enum DataSource { firebase, localStorage, loading, error }

class DataSourceIndicator extends StatelessWidget {
  final DataSource dataSource;
  final String? customMessage;
  final bool showIcon;
  final EdgeInsetsGeometry? margin;

  const DataSourceIndicator({
    super.key,
    required this.dataSource,
    this.customMessage,
    this.showIcon = true,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getBorderColor()),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[_buildIcon(), const SizedBox(width: 8)],
          Flexible(
            child: Text(
              customMessage ?? _getDefaultMessage(),
              style: TextStyle(
                color: _getTextColor(),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    switch (dataSource) {
      case DataSource.firebase:
        return Icon(Icons.cloud_done, size: 16, color: _getTextColor());
      case DataSource.localStorage:
        return Icon(Icons.storage, size: 16, color: _getTextColor());
      case DataSource.loading:
        return SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
          ),
        );
      case DataSource.error:
        return Icon(Icons.error_outline, size: 16, color: _getTextColor());
    }
  }

  Color _getBackgroundColor() {
    switch (dataSource) {
      case DataSource.firebase:
        return Colors.green.shade50;
      case DataSource.localStorage:
        return Colors.blue.shade50;
      case DataSource.loading:
        return Colors.orange.shade50;
      case DataSource.error:
        return Colors.red.shade50;
    }
  }

  Color _getBorderColor() {
    switch (dataSource) {
      case DataSource.firebase:
        return Colors.green.shade200;
      case DataSource.localStorage:
        return Colors.blue.shade200;
      case DataSource.loading:
        return Colors.orange.shade200;
      case DataSource.error:
        return Colors.red.shade200;
    }
  }

  Color _getTextColor() {
    switch (dataSource) {
      case DataSource.firebase:
        return Colors.green.shade800;
      case DataSource.localStorage:
        return Colors.blue.shade800;
      case DataSource.loading:
        return Colors.orange.shade800;
      case DataSource.error:
        return Colors.red.shade800;
    }
  }

  String _getDefaultMessage() {
    switch (dataSource) {
      case DataSource.firebase:
        return '☁️ ডেটা Firebase থেকে লোড হয়েছে';
      case DataSource.localStorage:
        return '📱 ডেটা Local Storage (Hive) থেকে লোড হয়েছে';
      case DataSource.loading:
        return '⏳ ডেটা লোড হচ্ছে...';
      case DataSource.error:
        return '❌ ডেটা লোড করতে সমস্যা হয়েছে';
    }
  }
}
