class Medicine {
  final int? id;
  final String name;
  final String date; // selected day
  final String time; // HH:mm
  final bool repeatDaily;
  final String? imagePath;

  Medicine({
    this.id,
    required this.name,
    required this.date,
    required this.time,
    this.repeatDaily = false,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'time': time,
      'repeatDaily': repeatDaily ? 1 : 0,
      'imagePath': imagePath,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      date: map['date'],
      time: map['time'],
      repeatDaily: map['repeatDaily'] == 1,
      imagePath: map['imagePath'],
    );
  }
}
