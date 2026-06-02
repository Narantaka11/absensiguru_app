class AssessmentModel {

  final int id;
  final double absensi;
  final double disiplin;
  final double keterampilan;
  final double produktivitas;
  final double total;
  final int month;
  final int year;

  AssessmentModel({
    required this.id,
    required this.absensi,
    required this.disiplin,
    required this.keterampilan,
    required this.produktivitas,
    required this.total,
    required this.month,
    required this.year,
  });

  factory AssessmentModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return AssessmentModel(
      id: json['id'] ?? 0,

      absensi:
          double.tryParse(
            json['absensi'].toString(),
          ) ??
          0,

      disiplin:
          double.tryParse(
            json['disiplin'].toString(),
          ) ??
          0,

      keterampilan:
          double.tryParse(
            json['keterampilan'].toString(),
          ) ??
          0,

      produktivitas:
          double.tryParse(
            json['produktivitas'].toString(),
          ) ??
          0,

      total:
          double.tryParse(
            json['total'].toString(),
          ) ??
          0,

      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
    );
  }
}
