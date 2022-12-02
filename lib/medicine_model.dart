import 'logs_model.dart';

class Medicine {
  int id;
  String name;
  String expireDate;
  List<Logs> logs;

  Medicine(this.id, this.name, this.expireDate, this.logs);
}
