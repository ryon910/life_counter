import 'package:isar/isar.dart';
import '../models/daily_record.dart';

class DailyRecordRepository {
  DailyRecordRepository(this._isar);
  final Isar _isar;

  Future<DailyRecord?> getByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return _isar.dailyRecords
        .filter()
        .dateBetween(start, end, includeUpper: false)
        .findFirst();
  }

  Future<List<DailyRecord>> getByMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    return _isar.dailyRecords
        .filter()
        .dateBetween(start, end, includeUpper: false)
        .sortByDate()
        .findAll();
  }

  Future<List<DailyRecord>> getAll() {
    return _isar.dailyRecords.where().sortByDateDesc().findAll();
  }

  Stream<List<DailyRecord>> watchByMonth(int year, int month) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    return _isar.dailyRecords
        .filter()
        .dateBetween(start, end, includeUpper: false)
        .sortByDate()
        .watch(fireImmediately: true);
  }

  Future<DailyRecord> getOrCreate(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    var record = await getByDate(normalized);
    if (record == null) {
      record = DailyRecord()..date = normalized;
      await _isar.writeTxn(() => _isar.dailyRecords.put(record!));
    }
    return record;
  }

  Future<void> save(DailyRecord record) async {
    record.updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.dailyRecords.put(record));
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() => _isar.dailyRecords.delete(id));
  }
}
