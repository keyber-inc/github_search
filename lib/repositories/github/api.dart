// Copyright 2022 Keyber Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

/// GitHub API の定義
/// 各APIはUriを返す
class GitHubApi {
  const GitHubApi();

  static const _scheme = 'https';
  static const _apiUrl = 'api.github.com';
  static const _apiPath = '';

  /// Uriを構築する
  Uri _buildUri({
    required String endpoint,
    Map<String, String> Function()? parametersBuilder,
  }) {
    return Uri(
      scheme: _scheme,
      host: _apiUrl,
      path: '$_apiPath$endpoint',
      queryParameters: parametersBuilder != null ? parametersBuilder() : null,
    );
  }

  /// https://docs.github.com/ja/rest/reference/search#search-repositories
  Uri searchRepos({
    required String query,
    GitHubParamSearchReposSort? sort,
    GitHubParamOrder? order,
    int? perPage,
    int? page,
  }) {
    assert(query.isNotEmpty);
    assert(perPage == null || (0 < perPage && perPage <= 100));
    assert(page == null || 0 < page);
    return _buildUri(
      endpoint: '/search/repositories',
      parametersBuilder: () {
        return {
          'q': query,
          if (sort != null) 'sort': sort.name,
          if (order != null) 'order': order.name,
          if (perPage != null) 'per_page': '$perPage',
          if (page != null) 'page': '$page',
        };
      },
    );
  }

  /// https://docs.github.com/ja/rest/reference/repos#get-a-repository
  Uri getRepo({
    required String ownerName,
    required String repoName,
  }) {
    assert(ownerName.isNotEmpty);
    assert(repoName.isNotEmpty);
    return _buildUri(
      endpoint: '/repos/$ownerName/$repoName',
    );
  }
}

/// Sorts the results of your query
enum GitHubParamSearchReposSort {
  stars,
  forks,
  helpWantedIssues,
}

extension GitHubParamSearchReposSortHelper on GitHubParamSearchReposSort {
  static final names = <GitHubParamSearchReposSort, String>{
    GitHubParamSearchReposSort.stars: 'stars',
    GitHubParamSearchReposSort.forks: 'forks',
    GitHubParamSearchReposSort.helpWantedIssues: 'help-wanted-issues',
  };

  /// override
  String get name => names[this]!;
}

/// Determines whether the first search result returned is the highest number
/// of matches (desc) or lowest number of matches (asc). This parameter is
/// ignored unless you provide sort.
enum GitHubParamOrder {
  asc,
  desc,
}
