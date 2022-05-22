// Copyright 2022 susatthi All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';

import '../../../entities/repo/repo_data.dart';
import 'repo_detail_view_notifier.dart';

/// アバター画像プレビューView
class RepoAvatarPreviewView extends ConsumerWidget {
  const RepoAvatarPreviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(repoDetailViewStateProvider);
    return asyncValue.when(
      data: (data) => _RepoAvatarPreviewView(data: data),
      // ほぼ失敗しないしすぐに元に戻れるのでエラー表示はしない
      error: (e, s) => const SizedBox(),
      // 取得時間は短いと思うのでローディング表示はしない
      loading: () => const SizedBox(),
    );
  }
}

class _RepoAvatarPreviewView extends ConsumerWidget {
  const _RepoAvatarPreviewView({
    required this.data,
  });

  final RepoData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PhotoView(
      imageProvider: CachedNetworkImageProvider(data.owner.avatarUrl),
      backgroundDecoration: const BoxDecoration(),
    );
  }
}