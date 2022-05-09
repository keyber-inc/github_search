// Copyright 2022 susatthi All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../../localizations/strings.g.dart';
import '../../components/repo/repo_order_toggle_button.dart';
import '../../components/repo/repo_search_text_field.dart';
import '../../components/repo/repo_sort_selector_dialog.dart';

/// リポジトリ検索画面
class RepoSearchPage extends StatelessWidget {
  const RepoSearchPage({Key? key}) : super(key: key);

  static const name = 'repo_search';
  static const path = 'search';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              pinned: true,
              titleSpacing: 0,
              title: const RepoSearchTextField(),
              iconTheme: IconTheme.of(context),
              actionsIconTheme: IconTheme.of(context),
              actions: [
                const RepoOrderToggleButton(),
                IconButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) => const RepoSortSelectorDialog(),
                  ),
                  icon: const Icon(Icons.sort),
                  tooltip: i18n.sort,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}