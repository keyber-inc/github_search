// Copyright 2022 susatthi All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:markdown/markdown.dart';

import '../../../entities/repo/repo_data.dart';
import '../../../utils/assets/assets.gen.dart';
import '../../../utils/logger.dart';
import '../../../utils/url_launcher.dart';
import 'repo_readme_content.dart';

/// リポジトリREADMEのMarkdown表示
class RepoReadmeMarkdown extends ConsumerWidget {
  const RepoReadmeMarkdown({
    super.key,
    required this.repo,
    this.cacheManager,
  });

  /// 選択中のリポジトリデータ
  final RepoData repo;

  /// CacheManager
  final CacheManager? cacheManager;

  /// CacheManager
  CacheManager get _defaultCacheManager => CacheManager(
        Config(
          'RepoReadmeMarkdown',
          stalePeriod: const Duration(days: 1),
          maxNrOfCacheObjects: 200,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(repoReadmeContentProviderFamily(repo));
    return asyncValue.when(
      data: (content) => RepoReadmeMarkdownInternal(
        content: content,
        cacheManager: cacheManager ?? _defaultCacheManager,
      ),
      error: (_, __) => const SizedBox(),
      loading: () => const _LoadingIndicator(),
    );
  }
}

@visibleForTesting
class RepoReadmeMarkdownInternal extends StatelessWidget {
  const RepoReadmeMarkdownInternal({
    super.key,
    required this.content,
    required this.cacheManager,
  });

  /// Markdown　文字列
  final String content;

  /// CacheManager
  final CacheManager cacheManager;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: content,
      selectable: true,
      onTapLink: (_, href, __) async {
        logger.i('Tapped link: href = $href');
        if (href != null) {
          await launchUrlInApp(href);
        }
      },
      extensionSet: ExtensionSet(
        ExtensionSet.gitHubFlavored.blockSyntaxes,
        [
          EmojiSyntax(),
          ...ExtensionSet.gitHubFlavored.inlineSyntaxes,
        ],
      ),
      // CachedNetworkImage は SVG をサポートしていないため SVG が表示されない
      // 対策として、まずは画像として取得してみて、だめだったらSVGとして取得し直している
      // 参考サイト: https://github.com/Baseflow/flutter_cached_network_image/issues/383
      imageBuilder: (uri, _, __) => CachedNetworkImage(
        imageUrl: uri.toString(),
        cacheManager: cacheManager,
        errorWidget: (_, url, dynamic __) => SvgPicture.network(url),
      ),
    );
  }
}

/// ローディングインジケーター
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 64,
            child: Lottie.asset(Assets.lottie.loadingIndicator),
          ),
        ],
      ),
    );
  }
}
