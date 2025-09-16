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
    return Row(
      children: [
        // Previous Day
        IconButton(
          onPressed: () {
            final newDate = selectedDate.subtract(const Duration(days: 1));
            onDateChanged(newDate);
          },
          icon: const Icon(Icons.chevron_left),
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
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        
        // Next Day
        IconButton(
          onPressed: () {
            final newDate = selectedDate.add(const Duration(days: 1));
            if (newDate.isBefore(DateTime.now()) || 
                (newDate.year == DateTime.now().year && 
                 newDate.month == DateTime.now().month && 
                 newDate.day == DateTime.now().day)) {
              onDateChanged(newDate);
            }
          },
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget _buildMonthYearSelector(BuildContext context) {
    return Row(
      children: [
        // Previous Month
        IconButton(
          onPressed: () {
            final newDate = DateTime(selectedDate.year, selectedDate.month - 1);
            onDateChanged(newDate);
          },
          icon: const Icon(Icons.chevron_left),
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
                onDateChanged(date);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        
        // Next Month
        IconButton(
          onPressed: () {
            final newDate = DateTime(selectedDate.year, selectedDate.month + 1);
            if (newDate.isBefore(DateTime.now()) || 
                (newDate.year == DateTime.now().year && newDate.month == DateTime.now().month)) {
              onDateChanged(newDate);
            }
          },
          icon: const Icon(Icons.chevron_right),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date != null 
                  ? '${date.day}/${date.month}/${date.year}'
                  : 'Select date',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: date != null ? Colors.black : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}