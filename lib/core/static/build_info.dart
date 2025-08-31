/// Build information constants
/// This file can be auto-generated during build process
class BuildInfo {
  // This can be replaced during CI/CD build process
  static const String buildDate = '2025-08-31'; // ISO format

  // Convert ISO date to readable format
  static String get formattedBuildDate {
    try {
      final date = DateTime.parse(buildDate);
      final monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${monthNames[date.month - 1]} ${date.year}';
    } catch (e) {
      // Fallback to current date
      final now = DateTime.now();
      final monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${monthNames[now.month - 1]} ${now.year}';
    }
  }
}
