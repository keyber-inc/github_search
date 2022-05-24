// Copyright 2022 susatthi All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_search/presentation/components/common/search_app_bar.dart';

import '../../../test_utils/locale.dart';
import '../../../test_utils/mocks.dart';

void main() {
  setUp(useEnvironmentLocale);
  group('SearchAppBar', () {
    testWidgets('デフォルトのAppBarの高さが意図した高さであるはず', (tester) async {
      await tester.pumpWidget(
        mockGitHubSearchApp(
          home: const Scaffold(
            body: CustomScrollView(
              slivers: [
                SearchAppBar(
                  backgroundColor: Colors.red,
                )
              ],
            ),
          ),
        ),
      );

      expect(find.byType(SliverAppBar), findsOneWidget);
      final sliverAppBar =
          tester.widgetList(find.byType(SliverAppBar)).first as SliverAppBar;

      // AppBarの高さが意図した高さであるはず
      expect(sliverAppBar.toolbarHeight, SearchAppBar.defaultToolBarHeight);
    });
  });
}
