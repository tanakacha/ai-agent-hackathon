import os
import json
import uuid
from dataclasses import dataclass, asdict
from datetime import datetime
from typing import List, Optional

import firebase_admin
from firebase_admin import credentials, firestore

# ----- Firebase初期化 -----
FIREBASE_CREDENTIALS_PATH = "serviceKey.json"
SAMPLE_DATA_PATH = "sample1.json"

cred = credentials.Certificate(FIREBASE_CREDENTIALS_PATH)
firebase_admin.initialize_app(cred)
db = firestore.client()


@dataclass
class User:
    id: str
    name: str
    ability: List[str]

    def to_dict(self):
        d = asdict(self)
        d['id'] = str(self.id)
        return d


@dataclass
class Map:
    id: str
    user_id: str
    name: str
    objective: str
    deadline: datetime
    created_at: datetime
    updated_at: datetime

    def to_dict(self):
        d = asdict(self)
        d['id'] = str(self.id)
        d['user_id'] = str(self.user_id)
        d['deadline'] = self.deadline.isoformat()
        d['created_at'] = self.created_at.isoformat()
        d['updated_at'] = self.updated_at.isoformat()
        return d


@dataclass
class Node:
    id: str
    map_id: str
    name: str
    node_type: str
    description: str
    child_id: Optional[str]
    to_id: Optional[str]
    created_at: datetime
    updated_at: datetime
    finished_at: Optional[datetime]

    def to_dict(self):
        d = asdict(self)
        d['id'] = str(self.id)
        d['map_id'] = str(self.map_id)
        d['child_id'] = str(self.child_id) if self.child_id else None
        d['to_id'] = str(self.to_id) if self.to_id else None
        d['created_at'] = self.created_at.isoformat()
        d['updated_at'] = self.updated_at.isoformat()
        d['finished_at'] = self.finished_at.isoformat() if self.finished_at else None
        return d


def parse_datetime(dt_str: str) -> datetime:
    return datetime.fromisoformat(dt_str)


def main():
    # JSONファイル読み込み
    with open(SAMPLE_DATA_PATH, "r") as f:
        data = json.load(f)

    # Userオブジェクト作成
    user_data = data['user']
    user = User(
        id=user_data['id'],
        name=user_data['name'],
        ability=user_data['ability']
    )

    # Mapオブジェクト作成
    map_data = data['map']
    map_obj = Map(
        id=(map_data['id']),
        user_id=(map_data['user_id']),
        name=map_data['name'],
        objective=map_data['objective'],
        deadline=parse_datetime(map_data['deadline']),
        created_at=parse_datetime(map_data['created_at']),
        updated_at=parse_datetime(map_data['updated_at']),
    )

    # Nodesリスト作成
    nodes = []
    for node_data in data['nodes']:
        node = Node(
            id=node_data['id'],
            map_id=node_data['map_id'],
            name=node_data['name'],
            node_type=node_data['node_type'],
            description=node_data['description'],
            child_id=node_data['child_id'] if node_data['child_id'] else None,
          	to_id=node_data['to_id'] if node_data['to_id'] else None,
            created_at=parse_datetime(node_data['created_at']),
            updated_at=parse_datetime(node_data['updated_at']),
            finished_at=parse_datetime(node_data['finished_at']) if node_data['finished_at'] else None
        )
        nodes.append(node)

    # Firestoreに書き込み
    # userコレクション（ドキュメントIDは user.id）
    db.collection('users').document(str(user.id)).set(user.to_dict())
    print(f"User {user.id} written.")

    # mapコレクション（ドキュメントIDは map.id）
    db.collection('maps').document(str(map_obj.id)).set(map_obj.to_dict())
    print(f"Map {map_obj.id} written.")

    # nodesコレクション（ドキュメントIDは node.id）
    for node in nodes:
        db.collection('nodes').document(str(node.id)).set(node.to_dict())
        print(f"Node {node.id} written.")


if __name__ == "__main__":
    main()
