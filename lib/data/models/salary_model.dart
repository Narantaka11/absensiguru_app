class SalaryModel {
  final int id;
  final int year;
  final int month;

  final String monthName;

  final double baseSalary;
  final int totalPresentDays;
  final int totalAbsentDays;
  final int totalLateMinutes;

  final double deductionForAbsence;
  final double deductionForLate;
  final double totalDeduction;

  final double totalSalary;

  final String status;
  final String statusLabel;

  SalaryModel({
    required this.id,
    required this.year,
    required this.month,
    required this.monthName,
    required this.baseSalary,
    required this.totalPresentDays,
    required this.totalAbsentDays,
    required this.totalLateMinutes,
    required this.deductionForAbsence,
    required this.deductionForLate,
    required this.totalDeduction,
    required this.totalSalary,
    required this.status,
    required this.statusLabel,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    return SalaryModel(
      id: int.tryParse(json['id'].toString()) ?? 0,

      year: int.tryParse(json['year'].toString()) ?? 0,

      month: int.tryParse(json['month'].toString()) ?? 0,
      monthName: json['month_name'] ?? '',

      baseSalary: double.tryParse(json['base_salary'].toString()) ?? 0,

      totalPresentDays:
          int.tryParse(json['total_present_days'].toString()) ?? 0,

      totalAbsentDays: int.tryParse(json['total_absent_days'].toString()) ?? 0,

      totalLateMinutes:
          int.tryParse(json['total_late_minutes'].toString()) ?? 0,

      deductionForAbsence:
          double.tryParse(json['deduction_for_absence'].toString()) ?? 0,

      deductionForLate:
          double.tryParse(json['deduction_for_late'].toString()) ?? 0,

      totalDeduction: double.tryParse(json['total_deduction'].toString()) ?? 0,

      totalSalary: double.tryParse(json['total_salary'].toString()) ?? 0,

      status: json['status'] ?? '',
      statusLabel: json['status_label'] ?? '',
    );
  }
}
