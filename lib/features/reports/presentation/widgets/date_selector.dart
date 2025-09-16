import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DateSelector extends StatelessWidget {
  final String reportType;
  final DateTime selectedDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime) onDateChanged;
  final Function(DateTime?, DateTime?) onRangeChanged;

  const DateSelector({
    super.key,
    required this.reportType,
    required this.selectedDate,
    this.startDate,
    this.endDate,
    required this.onDateChanged,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getDateSelectorTitle(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          
          // Date Selection based on report type
          if (reportType == 'daily') ...[
            _buildDaySelector(context),
          ] else if (reportType == 'monthly') ...[
            _buildMonthYearSelector(context),
          ] else if (reportType == 'range') ...[
            _buildDateRangeSelector(context),
          ],
        ],
      ),
    );
  }

  String _getDateSelectorTitle() {
    switch (reportType) {
      case 'daily':
        return 'Select Date';
      case 'monthly':
        return 'Select Month';
      case 'range':
        return 'Select Date Range';
      default:
        return 'Select Date';
    }
  }

  Widget _buildDaySelector(BuildContext context) {
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year && 
                   selectedDate.month == now.month && 
                   selectedDate.day == now.day;
    final canGoForward = selectedDate.isBefore(now);

    return Column(
      children: [
        Row(
          children: [
            // Previous Day
            IconButton(
              onPressed: () {
                final newDate = selectedDate.subtract(const Duration(days: 1));
                onDateChanged(newDate);
              },
              icon: const Icon(Icons.chevron_left),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[100],
              ),
            ),
            
            // Date Display
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    onDateChanged(date);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.primaryColor.withOpacity(0.05),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _formatDisplayDate(selectedDate),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      if (isToday)
                        Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Next Day
            IconButton(
              onPressed: canGoForward ? () {
                final newDate = selectedDate.add(const Duration(days: 1));
                onDateChanged(newDate);
              } : null,
              icon: const Icon(Icons.chevron_right),
              style: IconButton.styleFrom(
                backgroundColor: canGoForward ? Colors.grey[100] : Colors.grey[50],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Tap date to pick from calendar',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMonthYearSelector(BuildContext context) {
    final now = DateTime.now();
    final isCurrentMonth = selectedDate.year == now.year && selectedDate.month == now.month;
    final canGoForward = selectedDate.isBefore(DateTime(now.year, now.month + 1));

    return Column(
      children: [
        Row(
          children: [
            // Previous Month
            IconButton(
              onPressed: () {
                final newDate = DateTime(selectedDate.year, selectedDate.month - 1);
                onDateChanged(newDate);
              },
              icon: const Icon(Icons.chevron_left),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[100],
              ),
            ),
            
            // Month/Year Display
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    onDateChanged(DateTime(date.year, date.month));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.primaryColor.withOpacity(0.05),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      if (isCurrentMonth)
                        Text(
                          'Current Month',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Next Month
            IconButton(
              onPressed: canGoForward ? () {
                final newDate = DateTime(selectedDate.year, selectedDate.month + 1);
                onDateChanged(newDate);
              } : null,
              icon: const Icon(Icons.chevron_right),
              style: IconButton.styleFrom(
                backgroundColor: canGoForward ? Colors.grey[100] : Colors.grey[50],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Tap month to pick from calendar',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDateRangeSelector(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDateButton(
                context,
                'Start Date',
                startDate,
                (date) => onRangeChanged(date, endDate),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateButton(
                context,
                'End Date',
                endDate,
                (date) => onRangeChanged(startDate, date),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (startDate != null && endDate != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600], size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Range: ${_getDaysDifference(startDate!, endDate!)} days',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange[600], size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Select both start and end dates',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDateButton(
    BuildContext context,
    String label,
    DateTime? date,
    Function(DateTime?) onSelected,
  ) {
    return GestureDetector(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        onSelected(selectedDate);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: date != null ? AppTheme.primaryColor.withOpacity(0.3) : Colors.grey[300]!
          ),
          borderRadius: BorderRadius.circular(8),
          color: date != null ? AppTheme.primaryColor.withOpacity(0.05) : Colors.grey[50],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date != null 
                  ? _formatDisplayDate(date)
                  : 'Select date',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: date != null ? const Color(0xFF1F2937) : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDisplayDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  int _getDaysDifference(DateTime start, DateTime end) {
    return end.difference(start).inDays + 1;
  }
}