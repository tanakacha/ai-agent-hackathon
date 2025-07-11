import 'package:flutter_client/common/model/node.dart';

final Map<String, Node> sampleNodes = {
  '1': Node(
    id: '1',
    parentId: null,
    childrenIds: ['2', '4', '5', '10', '3'],
    nodeType: NodeType.root,
    title: 'Root',
    description: 'Root node',
    duration: 0,
    progressRate: 0,
    dueAt: DateTime.now().add(const Duration(days: 10)),
    finishedAt: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  '2': Node(
    id: '2',
    parentId: '1',
    childrenIds: [],
    nodeType: NodeType.start,
    title: 'Start',
    description: 'Start node',
    duration: 1,
    progressRate: 0,
    dueAt: DateTime.now().add(const Duration(days: 7)),
    finishedAt: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  '3': Node(
    id: '3',
    parentId: '1',
    childrenIds: [],
    nodeType: NodeType.goal,
    title: 'Goal',
    description: 'Goal node',
    duration: 1,
    progressRate: 0,
    dueAt: DateTime.now().add(const Duration(days: 14)),
    finishedAt: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  '4': Node(
    id: '4',
    parentId: '1',
    childrenIds: ['6', '7'],
    nodeType: NodeType.normal,
    title: 'Child A',
    description: 'A child node A',
    duration: 2,
    progressRate: 0,
    dueAt: DateTime.now().add(const Duration(days: 5)),
    finishedAt: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  '5': Node(
    id: '5',
    parentId: '1',
    childrenIds: [],
    nodeType: NodeType.normal,
    title: 'Child B',
    description: 'A child node B',
    duration: 3,
    progressRate: 0,
    dueAt: DateTime.now().add(const Duration(days: 4)),
    finishedAt: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  '6': Node(
    id: '6',
    parentId: '4',
    childrenIds: [],
    nodeType: NodeType.normal,
    title: 'Leaf A1',
    description: 'Leaf node under Child A',
    duration: 1,
    progressRate: 0,
    dueAt: DateTime.now().add(const Duration(days: 3)),
    finishedAt: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  '7': Node(
    id: '7',
    parentId: '4',
    childrenIds: ['8', '9'],
    nodeType: NodeType.normal,
    title: 'Leaf A2',
    description: 'Another leaf under Child A',
    duration: 2,
    progressRate: 0,
    dueAt: DateTime.now().add(const Duration(days: 2)),
    finishedAt: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  '8': Node(
    id: '8',
    parentId: '7',
    childrenIds: [],
    nodeType: NodeType.normal,
    title: 'Intermediate A2-1',
    description: 'Intermediate node between A2 and Goal',
    duration: 2,
    progressRate: 0,
    dueAt: DateTime.now().add(const Duration(days: 1)),
    finishedAt: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  '9': Node(
    id: '9',
    parentId: '7',
    childrenIds: [],
    nodeType: NodeType.normal,
    title: 'Bridge to Goal',
    description: 'Bridging node to Goal',
    duration: 1,
    progressRate: 0,
    dueAt: DateTime.now().add(const Duration(days: 1)),
    finishedAt: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  '10': Node(
    id: '10',
    parentId: '1',
    childrenIds: [],
    nodeType: NodeType.normal,
    title: 'Final Goal',
    description: 'Reached the goal node',
    duration: 1,
    progressRate: 0,
    dueAt: DateTime.now().add(const Duration(days: 1)),
    finishedAt: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
};
