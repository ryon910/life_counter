import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../repositories/daily_record_repository.dart';
import '../repositories/important_person_repository.dart';

/// Isarインスタンス（main.dartでオーバーライド）
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Override in main.dart');
});

final dailyRecordRepositoryProvider = Provider<DailyRecordRepository>((ref) {
  return DailyRecordRepository(ref.watch(isarProvider));
});

final importantPersonRepositoryProvider =
    Provider<ImportantPersonRepository>((ref) {
  return ImportantPersonRepository(ref.watch(isarProvider));
});
