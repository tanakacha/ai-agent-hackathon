import 'package:flutter_client/common/model/node.dart';

class RoadMap {
  int id;
  String title;
  String objective;
  String profile;
  DateTime deadline;
  DateTime createdAt;
  DateTime updatedAt;
  List<Node> nodes;

  RoadMap({
    required this.id,
    required this.title,
    required this.objective,
    required this.profile,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
    required this.nodes,
  });
}

  // erDiagram
  // 	User{
  //   		UUID id PK "ID"
  //   		String name "ユーザー名"
  //   	}
    	
  //   	Map{
  //        		UUID id PK "ID"
  //        		UUID user_id FK "ユーザーID"
  //        		String title "名前"
  //        		String objective "目標"
  //        		String profile "ロードマップ作成当時の経験値・知識量"
  //        		Date deadline "期限"
  //        		Date created_at "作成時刻"
  //        		Date updated_at "アップデート作成時刻"
  //        	}
    	
  // 	Node{
  // 		UUID id PK "ノードID"
  // 		UUID map_id FK "マップID"
  // 		String title "名前"
  // 		Int duration "所要時間"
  // 		Int progress_rate "進捗(%)"
  // 		String description "詳細"
  // 		String node_type "Start / Goal / Normal / Root"
  // 		String parent_id "親ノードID"
  // 		String children_ids "子ノードIDの配列"
  //         Date due_at "達成目安時刻"
  //         Date finished_at "実際に達成した時刻"
  //         Date created_at "作成時刻"
  //        	Date updated_at "アップデート作成時刻"
   
  // 	}
     	
  //    	User ||--o{ Map : owns
  //     Map  ||--o{ Node : contains
  //     User ||--o{ Node : contains
