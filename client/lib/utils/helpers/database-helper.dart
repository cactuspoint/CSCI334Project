class DatabaseHelper {}

class Visit {
  final int id; // dummy id for primary key
  final String datetime; // iso8601
  final String location; // iso6709

  Visit(this.id, this.datetime, this.location);

  Map<String, dynamic> toMap() {
    return {'id': id, 'datetime': datetime, 'location': location};
  }

  @override
  String toString() {
    return "id:${id.toString()} datetime:$datetime location:$location";
  }
}
