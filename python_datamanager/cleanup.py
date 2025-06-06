import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime, timedelta
import argparse

# Firebase初期化
FIREBASE_CREDENTIALS_PATH = "serviceKey.json"

def initialize_firebase():
    cred = credentials.Certificate(FIREBASE_CREDENTIALS_PATH)
    firebase_admin.initialize_app(cred)
    return firestore.client()

def delete_map_and_related_data(db, map_id: str) -> bool:
    """
    指定されたmap_idに関連するすべてのデータを削除
    - マップ自体
    - 関連するすべてのノード
    """
    try:
        # トランザクション内で削除を実行
        transaction = db.transaction()

        @firestore.transactional
        def delete_in_transaction(transaction, map_id):
            # マップに関連するノードを取得
            nodes_ref = db.collection('nodes')
            nodes = nodes_ref.where('map_id', '==', map_id).stream()
            
            # ノードの削除
            for node in nodes:
                node_ref = nodes_ref.document(node.id)
                transaction.delete(node_ref)
            
            # マップの削除
            map_ref = db.collection('maps').document(map_id)
            transaction.delete(map_ref)

        delete_in_transaction(transaction, map_id)
        print(f"Successfully deleted map {map_id} and all related nodes")
        return True
    except Exception as e:
        print(f"Error deleting map {map_id}: {e}")
        return False



def main():
    parser = argparse.ArgumentParser(description='Cleanup Firestore map data')
    parser.add_argument('--delete-map', type=str, help='Delete specific map ID and its related data')
    
    args = parser.parse_args()
    db = initialize_firebase()
    
    if args.delete_map:
        success = delete_map_and_related_data(db, args.delete_map)
        print(f"Map deletion {'successful' if success else 'failed'}")
    


if __name__ == "__main__":
    main() 
