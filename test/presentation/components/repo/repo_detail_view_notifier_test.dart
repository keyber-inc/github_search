// Copyright 2022 susatthi All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_search/config/router.dart';
import 'package:github_search/presentation/components/repo/repo_detail_view_notifier.dart';
import 'package:github_search/presentation/pages/repo/repo_view_page.dart';
import 'package:go_router/go_router.dart';

import '../../../test_utils/mocks.dart';

class _FirstPage extends StatelessWidget {
  const _FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        onPressed: () {
          context.goNamed(
            'repo_view',
            params: RepoViewPage.params(
              ownerName: 'ownerName',
              repoName: 'repoName',
            ),
          );
        },
        child: const Text('go'),
      ),
    );
  }
}

void main() {
  const repoDetailViewParameter = RepoDetailViewParameter(
    ownerName: 'flutter',
    repoName: 'flutter',
  );

  group('repoDetailViewStateProvider', () {
    test('最初はStateErrorをthrowするはず', () async {
      final container = mockProviderContainer();
      // ignore: prefer_function_declarations_over_variables
      final func = () {
        try {
          container.read(repoDetailViewStateProvider);
        } on ProviderException catch (e) {
          // ignore: only_throw_errors
          throw (e.exception as ProviderException).exception;
        }
      };
      expect(func, throwsStateError);
    });
    test('overridesすればStateErrorをthrowしないはず', () async {
      final container = mockProviderContainer(
        overrides: [
          repoDetailViewStateProvider.overrideWithProvider(
            repoDetailViewStateProviderFamily(repoDetailViewParameter),
          ),
        ],
      );
      // ignore: prefer_function_declarations_over_variables
      final func = () {
        try {
          container.read(repoDetailViewStateProvider);
        } on ProviderException catch (e) {
          // ignore: only_throw_errors
          throw (e.exception as ProviderException).exception;
        }
      };
      expect(func, func);
    });
  });
  group('RepoDetailViewParameter', () {
    testWidgets('from()でインスタンスが生成できるはず', (tester) async {
      await tester.pumpWidget(
        mockGitHubSearchApp(
          overrides: [
            routerProvider.overrideWithValue(
              GoRouter(
                routes: [
                  GoRoute(
                    path: '/',
                    builder: (context, state) => const _FirstPage(),
                    routes: [
                      GoRoute(
                        name: 'repo_view',
                        path: ':$pageParamKeyOwnerName/:$pageParamKeyRepoName',
                        builder: (context, state) {
                          final parameter = RepoDetailViewParameter.from(state);
                          expect(parameter.ownerName, 'ownerName');
                          expect(parameter.repoName, 'repoName');
                          return const Scaffold();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

      // ボタンをタップして次の画面に遷移する
      await tester.tap(find.byType(TextButton));
      await tester.pump();
    });
  });
  group('RepoDetailViewNotifier', () {
    test('Notifierを生成するとリポジトリエンティティを取得するはず', () async {
      final container = mockProviderContainer(
        overrides: [
          repoDetailViewStateProvider.overrideWithProvider(
            repoDetailViewStateProviderFamily(repoDetailViewParameter),
          ),
        ],
      );
      final notifier = container
          .listen(
            repoDetailViewStateProvider.notifier,
            (previous, next) {},
          )
          .read();
      // 初期値はAsyncLoading
      // ignore: INVALID_USE_OF_PROTECTED_MEMBER
      expect(notifier.state is AsyncLoading, true);

      // データを取り終わるまで待つ
      await Future<void>.delayed(const Duration(microseconds: 500));

      // データが取得できているはず
      // ignore: INVALID_USE_OF_PROTECTED_MEMBER
      expect(notifier.state is AsyncData, true);
    });
  });
}
