package com.example.service;

import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.example.dto.Node;
import com.example.dto.RoadMap;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.cloud.firestore.WriteResult;

@Service
public class RoadMapService {
	private static final Logger logger = LoggerFactory.getLogger(UserService.class);

	private final Firestore firestore;

	private static final String ROADMAPS_COLLECTION = "maps";
	private static final String NODES_COLLECTION = "nodes";

	public RoadMapService(Firestore firestore) {
		this.firestore = firestore;
		logger.info("UserService initialized with Firestore instance");
	}


	public RoadMap getRoadMap(String map_id) {
		try {
			DocumentReference docRef = firestore.collection(ROADMAPS_COLLECTION).document(map_id);
			ApiFuture<DocumentSnapshot> future = docRef.get();
			DocumentSnapshot document = future.get();
			
			logger.info("完了: FirestoreからのRoadMapドキュメント取得 (ID: {})", map_id);
			
			if (!document.exists()) {
				logger.info("ドキュメントが見つかりませんでした: {}", map_id);
				return null;
			}
			
			RoadMap roadMap = document.toObject(RoadMap.class);
			logger.info("RoadMapオブジェクトの取得完了: ID={}, Title={}", roadMap.getId(), roadMap.getTitle());
			return roadMap;
		} catch (InterruptedException | ExecutionException e) {
			logger.error("ドキュメント取得中にエラーが発生: {}", e.getMessage(), e);
			throw new RuntimeException(e);
		}
	}

	public List<Node> getNodes(String map_id) {
		try {
			CollectionReference nodesCollection = firestore.collection(NODES_COLLECTION);
			ApiFuture<QuerySnapshot> future = nodesCollection.whereEqualTo("map_id", map_id).get();
			QuerySnapshot querySnapshot = future.get();
			logger.info("完了: FirestoreからのNodeドキュメント取得 (件数: {})", querySnapshot.getDocuments().size());
			if (querySnapshot.getDocuments().isEmpty()) {
				logger.info("ドキュメントが見つかりませんでした");
				return null;
			}
			List<Node> nodes = querySnapshot.getDocuments().stream().map(doc -> doc.toObject(Node.class))
					.collect(Collectors.toList());
			logger.info("Nodeオブジェクトの取得完了: ID={}, Title={}", nodes.get(0).getId(), nodes.get(0).getTitle());

			return nodes;
		} catch (InterruptedException | ExecutionException e) {
			logger.error("ドキュメント取得中にエラーが発生: {}", e.getMessage(), e);
			throw new RuntimeException(e);
		}
	}

	public RoadMap createRoadMap(String mapId, String goal, String deadline) throws InterruptedException, ExecutionException {
		logger.info("開始: RoadMap作成 (ID: {})", mapId);
		
		Date now = new Date();
		RoadMap roadMap = new RoadMap();
		roadMap.setId(mapId);
		roadMap.setUser_id("default-user");
		roadMap.setTitle(goal);
		roadMap.setObjective(goal);
		roadMap.setProfile("自動生成されたロードマップ");
		
		try {
			java.time.LocalDate localDate = java.time.LocalDate.parse(deadline);
			roadMap.setDeadline(java.sql.Date.valueOf(localDate));
		} catch (Exception e) {
			roadMap.setDeadline(new Date(System.currentTimeMillis() + 30L * 24 * 60 * 60 * 1000));
		}
		
		roadMap.setCreated_at(now);
		roadMap.setUpdated_at(now);
		
		DocumentReference docRef = firestore.collection(ROADMAPS_COLLECTION).document(mapId);
		ApiFuture<WriteResult> future = docRef.set(roadMap);
		WriteResult result = future.get();
		
		logger.info("RoadMap作成完了: ID={}, 作成時刻={}", mapId, result.getUpdateTime());
		
		return roadMap;
	}

	public RoadMap createRoadMapWithDetails(String mapId, String title, String objective, String profile, String deadline) throws InterruptedException, ExecutionException {
		logger.info("開始: 詳細RoadMap作成 (ID: {})", mapId);
		
		Date now = new Date();
		RoadMap roadMap = new RoadMap();
		roadMap.setId(mapId);
		roadMap.setUser_id("default-user");
		roadMap.setTitle(title);
		roadMap.setObjective(objective);
		roadMap.setProfile(profile);	
		try {
			java.time.LocalDate localDate = java.time.LocalDate.parse(deadline);
			roadMap.setDeadline(java.sql.Date.valueOf(localDate));
		} catch (Exception e) {
			roadMap.setDeadline(new Date(System.currentTimeMillis() + 30L * 24 * 60 * 60 * 1000));
		}
		
		roadMap.setCreated_at(now);
		roadMap.setUpdated_at(now);
		
		DocumentReference docRef = firestore.collection(ROADMAPS_COLLECTION).document(mapId);
		ApiFuture<WriteResult> future = docRef.set(roadMap);
		WriteResult result = future.get();
		
		logger.info("詳細RoadMap作成完了: ID={}, Title={}, 作成時刻={}", mapId, title, result.getUpdateTime());
		
		return roadMap;
	}
}
