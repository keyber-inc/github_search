// Copyright 2022 susatthi All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_search/localizations/strings.g.dart';
import 'package:github_search/presentation/components/repo/repo_sort_button.dart';
import 'package:github_search/presentation/components/repo/repo_sort_selector_bottom_sheet.dart';

import '../../../test_utils/hive.dart';
import '../../../test_utils/locale.dart';
import '../../../test_utils/mocks.dart';

void main() {
  late Directory tmpDir;
  setUp(() async {
    tmpDir = await openAppDataBox();
    useEnvironmentLocale();
  });

  tearDown(() async {
    await closeAppDataBox(tmpDir);
  });

  group('RepoSortButton', () {
    testWidgets('正しく表示できるはず', (tester) async {
      await tester.pumpWidget(
        mockGitHubSearchApp(
          home: const Scaffold(
            body: RepoSortButton(),
          ),
        ),
      );
      await tester.pump();

      // tooltipが正しいはず
      final button = tester.widget(find.byType(IconButton)) as IconButton;
      expect(button.tooltip, i18n.sort);

      // アイコンが正しいはず
      final icon = button.icon as Icon;
      expect(icon.icon, Icons.sort);
    });

    testWidgets('ボタン押下でボトムシートを表示するはず', (tester) async {
      await tester.pumpWidget(
        mockGitHubSearchApp(
          home: const Scaffold(
            body: RepoSortButton(),
          ),
        ),
      );
      await tester.pump();

      // まだ表示されていないはず
      expect(find.byType(RepoSortSelectorBottomSheet), findsNothing);

      // ボタンをタップ
      await tester.tap(find.byType(RepoSortButton));
      await tester.pumpAndSettle();

      // 表示したはず
      expect(find.byType(RepoSortSelectorBottomSheet), findsOneWidget);

      // 適当なところをタップ
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();

      // 消えたはず
      expect(find.byType(RepoSortSelectorBottomSheet), findsNothing);
    });
  });
}
