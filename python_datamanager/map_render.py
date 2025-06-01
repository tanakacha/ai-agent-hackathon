import matplotlib.pyplot as plt
from dataclasses import dataclass, field
from typing import List, Dict, Optional

# 定数
WIDTH = 50  # ノードの幅
HEIGHT = 30  # ノードの高さ
DEPTH_SPACING = 80  # 深さ方向の間隔
MIN_SPREAD_SPACING = 50  # 広さ方向の最小間隔 (ノード間の空き)

@dataclass
class Node:
    id: str
    parentId: Optional[str] = None
    childrenIds: List[str] = field(default_factory=list)
    offsetInParent: int = 0  # 親の子配列内での位置 (0-indexed)
    
    # 座標計算用 (後で設定)
    x: float = 0.0
    y: float = 0.0
    
    # サブツリーのXオフセット計算用 (一時的に使用)
    min_subtree_x_offset: float = 0.0  # このノードを0とした場合の、サブツリー内の最も左の子孫のXオフセット
    max_subtree_x_offset: float = 0.0  # このノードを0とした場合の、サブツリー内の最も右の子孫のXオフセット
    
    # 親の中心からの相対X座標 (このノードの中心)
    x_relative_to_parent_center: float = 0.0 

# 木構造のデータ（例）
node_data: List[Node] = [
    Node(id='A', childrenIds=['B', 'C', 'P']),
    Node(id='B', parentId='A', childrenIds=['D', 'E', 'Q'], offsetInParent=0),
    Node(id='C', parentId='A', childrenIds=['F', 'G', 'V'], offsetInParent=1),
    Node(id='P', parentId='A', childrenIds=['R', 'W'], offsetInParent=2),

    Node(id='D', parentId='B', childrenIds=['H', 'I'], offsetInParent=0),
    Node(id='E', parentId='B', childrenIds=['J', 'X'], offsetInParent=1),
    Node(id='Q', parentId='B', childrenIds=['S', 'T'], offsetInParent=2),

    Node(id='F', parentId='C', childrenIds=['K', 'U'], offsetInParent=0),
    Node(id='G', parentId='C', childrenIds=['L', 'M'], offsetInParent=1),
    Node(id='V', parentId='C', childrenIds=['Y', 'Z'], offsetInParent=2),

    Node(id='H', parentId='D', offsetInParent=0),
    Node(id='I', parentId='D', offsetInParent=1),

    Node(id='J', parentId='E', childrenIds=['N', 'AA'], offsetInParent=0),
    Node(id='X', parentId='E', childrenIds=['AB', 'AC'], offsetInParent=1),

    Node(id='K', parentId='F', offsetInParent=0),
    Node(id='U', parentId='F', offsetInParent=1),

    Node(id='L', parentId='G', offsetInParent=0),
    Node(id='M', parentId='G', offsetInParent=1),

    Node(id='N', parentId='J', offsetInParent=0),
    Node(id='AA', parentId='J', offsetInParent=1),

    Node(id='R', parentId='P', offsetInParent=0),
    Node(id='W', parentId='P', offsetInParent=1),

    Node(id='S', parentId='Q', offsetInParent=0),
    Node(id='T', parentId='Q', offsetInParent=1),

    Node(id='Y', parentId='V', offsetInParent=0),
    Node(id='Z', parentId='V', offsetInParent=1),

    Node(id='AB', parentId='X', offsetInParent=0),
    Node(id='AC', parentId='X', offsetInParent=1),
]


# ハッシュマップ（idからNodeを検索）
node_map: Dict[str, Node] = {node.id: node for node in node_data}

def _calculate_subtree_x_offsets(node_id: str, nodes: Dict[str, Node]):
    """
    各ノードのサブツリーにおける、最も左/右の子孫のXオフセット（ノード中心を0とした相対座標）と、
    親ノードの中心からの自身の相対Xオフセットを計算する。
    これはボトムアップで実行される。
    """
    node = nodes[node_id]

    if not node.childrenIds:
        # 葉ノードの場合、自身の幅がサブツリーのオフセットとなる
        node.min_subtree_x_offset = -WIDTH / 2
        node.max_subtree_x_offset = WIDTH / 2
        return

    # 子ノードのサブツリーXオフセットを再帰的に計算
    for child_id in node.childrenIds:
        _calculate_subtree_x_offsets(child_id, nodes)

    # 子ノードの配置を決定
    sorted_children_ids = sorted(node.childrenIds, key=lambda c_id: nodes[c_id].offsetInParent)

    # 最初の子供の相対X座標を決定 (仮のスタート位置)
    # 子ノード群の左端を基点とする
    current_x_for_children_cluster = 0.0 
    
    # 各子ノードの親からの相対X座標 (仮のオフセット) を計算
    # これらは、子ノードのサブツリーの左端が前の兄弟ノードの右端+MIN_SPREAD_SPACINGとなるように配置
    
    # 最初の子供のオフセットを計算。
    # このオフセットは、子ノード群全体の左端が0になるように調整するためのもの
    first_child_node = nodes[sorted_children_ids[0]]
    # 最初の子供の中心が、その子ノードのサブツリーの左端の絶対位置から、その子ノードのsubtree_left_offsetを引いた位置になる
    # つまり、子ノード群の左端を0に揃えるためのオフセット
    current_x_for_children_cluster = -first_child_node.min_subtree_x_offset


    child_x_offsets_relative_to_cluster_start: Dict[str, float] = {}

    for i, child_id in enumerate(sorted_children_ids):
        child_node = nodes[child_id]
        
        if i > 0:
            prev_child_id = sorted_children_ids[i-1]
            prev_child_node = nodes[prev_child_id]
            
            # 前の子供のサブツリーの右端 + MIN_SPREAD_SPACING + 自身のサブツリーの左端 が次の子供の開始点
            # current_x_for_children_cluster は、現在の子供のサブツリーの左端が来るべき位置
            current_x_for_children_cluster = (
                child_x_offsets_relative_to_cluster_start[prev_child_id] + 
                prev_child_node.max_subtree_x_offset + 
                MIN_SPREAD_SPACING - 
                child_node.min_subtree_x_offset
            )
            
        child_x_offsets_relative_to_cluster_start[child_id] = current_x_for_children_cluster

    # 子ノード列全体の左端と右端のオフセットを計算 (ノード群の開始点を0とした場合)
    min_overall_child_x = float('inf')
    max_overall_child_x = float('-inf')

    for child_id in sorted_children_ids:
        child_node = nodes[child_id]
        child_center_x_in_cluster = child_x_offsets_relative_to_cluster_start[child_id]
        
        min_overall_child_x = min(min_overall_child_x, child_center_x_in_cluster + child_node.min_subtree_x_offset)
        max_overall_child_x = max(max_overall_child_x, child_center_x_in_cluster + child_node.max_subtree_x_offset)

    # 親ノードのX座標は、子ノードの列の中心になるように調整
    # 子ノードの列の中心が0になるようにオフセットを計算
    center_offset_for_children_cluster = (min_overall_child_x + max_overall_child_x) / 2

    # 各子ノードの最終的な親からの相対Xオフセットを決定し、自身の x_relative_to_parent_center に保存
    for child_id in sorted_children_ids:
        child_node = nodes[child_id]
        child_node.x_relative_to_parent_center = (
            child_x_offsets_relative_to_cluster_start[child_id] - center_offset_for_children_cluster
        )
    
    # 親ノード自身のサブツリー境界を更新
    node.min_subtree_x_offset = min_overall_child_x - center_offset_for_children_cluster
    node.max_subtree_x_offset = max_overall_child_x - center_offset_for_children_cluster


def calculate_node_positions(root_id: str, nodes: Dict[str, Node]):
    """
    各ノードのX, Y座標を計算するメイン関数。
    """
    root_node = nodes[root_id]

    # 1. Y座標の計算 (深さから一意に決まる)
    depth_map: Dict[str, int] = {}
    
    def _calculate_depth(node_id: str, current_depth: int):
        depth_map[node_id] = current_depth
        for child_id in nodes[node_id].childrenIds:
            _calculate_depth(child_id, current_depth + 1)
    
    _calculate_depth(root_id, 0)

    for node_id, node in nodes.items():
        node.y = -depth_map[node_id] * DEPTH_SPACING # 下方向に伸びるようにマイナス

    # 2. X座標の計算
    # まず、各ノードのサブツリー内のXオフセットと、親からの相対Xオフセットを計算 (ボトムアップ)
    _calculate_subtree_x_offsets(root_id, nodes)

    # 次に、ルートノードのX座標を基準に、各ノードの絶対X座標を決定 (トップダウン)
    def _set_final_x_positions(node_id: str, current_parent_x: float):
        node = nodes[node_id]
        
        if node.parentId is None: # ルートノード
            node.x = current_parent_x
        else:
            node.x = current_parent_x + node.x_relative_to_parent_center
        
        for child_id in node.childrenIds:
            _set_final_x_positions(child_id, node.x)

    _set_final_x_positions(root_id, 0.0) # ルートのX座標を0.0として開始

def draw_tree(nodes: Dict[str, Node]):
    """
    計算されたノードの座標に基づいて木構造を描画する。
    """
    fig, ax = plt.subplots(figsize=(12, 8))
    
    # ノードを描画
    for node_id, node in nodes.items():
        # ノードの矩形
        rect = plt.Rectangle(
            (node.x - WIDTH / 2, node.y - HEIGHT / 2),
            WIDTH,
            HEIGHT,
            edgecolor='black',
            facecolor='lightblue',
            linewidth=1.5
        )
        ax.add_patch(rect)
        
        # ノードIDのテキスト
        ax.text(
            node.x,
            node.y,
            node.id,
            ha='center',
            va='center',
            fontsize=10,
            weight='bold'
        )

    # ブランチ（線）を描画
    for node_id, node in nodes.items():
        if node.parentId:
            parent_node = nodes[node.parentId]
            # 親ノードの下辺の中心から子ノードの上辺の中心へ線を引く
            ax.plot(
                [parent_node.x, node.x],
                [parent_node.y - HEIGHT / 2, node.y + HEIGHT / 2],
                color='gray',
                linewidth=1.0,
                zorder=0  # ノードの裏に描画
            )

    ax.set_aspect('equal', adjustable='box')
    ax.autoscale_view()
    ax.invert_yaxis()  # Y軸を反転させて、深さ0が上に来るようにする
    ax.axis('off')  # 軸を非表示にする
    plt.title("Tree Network Topology")
    plt.show()

# メイン処理
if __name__ == "__main__":
    calculate_node_positions('A', node_map)
    draw_tree(node_map)

    # 座標の確認 (オプション)
    print("Calculated Node Positions:")
    for node_id in sorted(node_map.keys()):
        node = node_map[node_id]
        print(f"Node {node.id}: X={node.x:.2f}, Y={node.y:.2f}, ParentXRel={node.x_relative_to_parent_center:.2f}, MinSubtreeX={node.min_subtree_x_offset:.2f}, MaxSubtreeX={node.max_subtree_x_offset:.2f}")
