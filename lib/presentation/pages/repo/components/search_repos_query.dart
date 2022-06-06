// Copyright 2022 susatthi All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/env.dart';
import '../../../../config/env_define.dart';
import '../../../../domain/repositories/query_history/entities/query_history_input.dart';
import '../../../../domain/repositories/query_history/query_history_repository.dart';
import '../../../../utils/logger.dart';

/// リポジトリ検索文字列初期値プロバイダー
final searchReposInitQueryStringProvider = Provider<String>(
  (ref) => const String.fromEnvironment(
    dartDefineKeyDefaultSearchValue,
    //ignore: avoid_redundant_argument_values
    defaultValue: Env.defaultSearchValue,
  ),
);

/// リポジトリ検索文字列プロバイダー
final searchReposQueryStringProvider = StateProvider<String>(
  (ref) => ref.read(searchReposInitQueryStringProvider),
);

/// リポジトリ検索文字列更新メソッドプロバイダー
final searchReposQueryStringUpdater = Provider(
  (ref) => (String queryString) async {
    ref.read(searchReposQueryStringProvider.notifier).state = queryString;
    await ref.read(queryHistoryRepositoryProvider).add(
          QueryHistoryInput(queryString: queryString),
        );
  },
);

/// 入力中のリポジトリ検索文字列プロバイダー
final searchReposEnteringQueryStringProvider = StateProvider<String>(
  (ref) => ref.read(searchReposQueryStringProvider),
);

/// 入力中のリポジトリ検索文字列更新メソッドプロバイダー
final searchReposEnteringQueryStringUpdater = Provider(
  (ref) => (String queryString) async {
    // もし現在の文字列と同じ場合は更新しない
    final current = ref.read(searchReposEnteringQueryStringProvider);
    if (current != queryString) {
      logger.v(
        'Update searchReposEnteringQueryString: queryString = $queryString',
      );
      ref.read(searchReposEnteringQueryStringProvider.notifier).state =
          queryString;
    }
  },
);