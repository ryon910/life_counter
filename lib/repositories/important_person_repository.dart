import 'package:isar/isar.dart';
import '../models/important_person.dart';

class ImportantPersonRepository {
  ImportantPersonRepository(this._isar);
  final Isar _isar;

  Stream<List<ImportantPerson>> watchAll() {
    return _isar.importantPersons
        .where()
        .sortByCreatedAt()
        .watch(fireImmediately: true);
  }

  Future<List<ImportantPerson>> getAll() {
    return _isar.importantPersons.where().sortByCreatedAt().findAll();
  }

  Future<int> count() => _isar.importantPersons.count();

  Future<void> add(ImportantPerson person) async {
    await _isar.writeTxn(() => _isar.importantPersons.put(person));
  }

  Future<void> update(ImportantPerson person) async {
    person.updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.importantPersons.put(person));
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() => _isar.importantPersons.delete(id));
  }
}
