// Copyright 2022 susatthi All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../components/common/search_app_bar.dart';
import '../../components/repo/repo_order_toggle_button.dart';
import '../../components/repo/repo_search_text_field.dart';
import '../../components/repo/repo_sort_button.dart';

/// リポジトリ検索画面
class RepoSearchPage extends StatelessWidget {
  const RepoSearchPage({super.key});

  static const name = 'repo_search';
  static const path = 'search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SearchAppBar(
            title: const RepoSearchTextField(),
            actions: const [
              RepoOrderToggleButton(),
              RepoSortButton(),
            ],
            backgroundColor: Theme.of(context).colorScheme.background,
            pinned: true,
          ),
        ],
      ),
    );
  }
}
