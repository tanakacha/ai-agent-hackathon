// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../nodes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nodesNotifierHash() => r'710d75d8134bfeb729cb446d222f547007e15edb';

/// See also [NodesNotifier].
@ProviderFor(NodesNotifier)
final nodesNotifierProvider =
    AutoDisposeNotifierProvider<NodesNotifier, Map<String, Node>>.internal(
  NodesNotifier.new,
  name: r'nodesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nodesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NodesNotifier = AutoDisposeNotifier<Map<String, Node>>;
String _$selectedNodeNotifierHash() =>
    r'3385fe9e6e3c347f642419be9833707fbbaa83c3';

/// See also [SelectedNodeNotifier].
@ProviderFor(SelectedNodeNotifier)
final selectedNodeNotifierProvider =
    AutoDisposeNotifierProvider<SelectedNodeNotifier, String?>.internal(
  SelectedNodeNotifier.new,
  name: r'selectedNodeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedNodeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedNodeNotifier = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
