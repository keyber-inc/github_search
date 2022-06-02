// Copyright 2022 susatthi All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:github_search/localizations/strings.g.dart';
import 'package:github_search/presentation/repo/components/search_text_field.dart';
import 'package:github_search/presentation/repo/components/sort_button.dart';
import 'package:github_search/presentation/repo/components/sort_selector_bottom_sheet.dart';
import 'package:github_search/presentation/repo/pages/search_page.dart';

import '../../../test_utils/test_agent.dart';

void main() {
  final agent = TestAgent();
  setUp(agent.setUp);
  tearDown(agent.tearDown);

  group('RepoSearchPage', () {
    testWidgets('画面が表示され必要なWidgetが存在するはず', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          agent.mockApp(
            home: const RepoSearchPage(),
          ),
        );
      });

      expect(find.byType(RepoSearchTextField), findsOneWidget);
      expect(find.byType(RepoSortButton), findsOneWidget);

      // RepoSearchTextに自動でフォーカスが当たるはず
      final state = tester.firstState(find.byType(RepoSearchTextField))
          as RepoSearchTextFieldState;
      expect(state.focusNode.hasFocus, true);
    });
    testWidgets('ソートボタン押下でボトムシートが表示されるはず', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          agent.mockApp(
            home: const RepoSearchPage(),
          ),
        );
        await tester.pump();

        // ソートボタンをタップ
        await tester.tap(find.byType(RepoSortButton));
        await tester.pumpAndSettle();

        // ソート選択ボトムシートが表示したはず
        expect(find.byType(RepoSortSelectorBottomSheet), findsOneWidget);

        // stars をタップ
        await tester.tap(find.text(i18n.starsCount));
        await tester.pumpAndSettle();

        // ソート選択が閉じたはず
        expect(find.byType(RepoSortSelectorBottomSheet), findsNothing);
      });
    });
  });
}
