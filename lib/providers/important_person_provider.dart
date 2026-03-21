import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/important_person.dart';
import 'isar_provider.dart';

/// 大切な人リストのプロバイダー
final importantPersonsProvider =
    StreamProvider<List<ImportantPerson>>((ref) {
  final repo = ref.watch(importantPersonRepositoryProvider);
  return repo.watchAll();
});

/// 大切な人の追加
final addPersonProvider =
    Provider<Future<void> Function(ImportantPerson)>((ref) {
  final repo = ref.watch(importantPersonRepositoryProvider);
  return (person) => repo.add(person);
});
