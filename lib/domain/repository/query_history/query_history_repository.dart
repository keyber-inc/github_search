// Copyright 2022 susatthi All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'entity/query_history.dart';

/// 検索履歴一覧のFutureプロバイダー
final queryHistoriesFutureProviderFamily =
    FutureProvider.autoDispose.family<List<QueryHistory>, String>(
  (ref, queryString) =>
      ref.watch(queryHistoryRepositoryProvider).finds(queryString: queryString),
);

/// 検索履歴一覧のStreamプロバイダー
final queryHistoriesStreamProviderFamily =
    StreamProvider.autoDispose.family<List<QueryHistory>, String>(
  (ref, queryString) => ref
      .watch(queryHistoryRepositoryProvider)
      .changes(queryString: queryString),
);

/// 検索履歴Repositoryプロバイダー
final queryHistoryRepositoryProvider = Provider<QueryHistoryRepository>(
  (ref) => throw UnimplementedError('Provider was not initialized'),
);

/// 検索履歴Repository
abstract class QueryHistoryRepository {
  /// 検索履歴を登録する
  Future<void> add(QueryHistory queryHistory);

  /// 検索履歴を削除する
  Future<void> delete(QueryHistory queryHistory);

  /// 検索履歴一覧を検索する
  ///
  /// - 検索条件
  ///   - 大文字小文字を区別しない [queryString] から始まる
  /// - ソート
  ///   - 検索日時の降順
  /// - 検索件数
  ///   - 20件
  Future<List<QueryHistory>> finds({required String queryString});

  /// 検索履歴一覧のStreamを返す
  ///
  /// - 検索条件
  ///   - 大文字小文字を区別しない [queryString] から始まる
  /// - ソート
  ///   - 検索日時の降順
  /// - 検索件数
  ///   - 20件
  Stream<List<QueryHistory>> changes({required String queryString});
}
