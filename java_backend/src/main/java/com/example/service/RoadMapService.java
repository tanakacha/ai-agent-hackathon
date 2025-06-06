package com.example.service;

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
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QuerySnapshot;

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
			CollectionReference roadmapsCollection = firestore.collection(ROADMAPS_COLLECTION);
			ApiFuture<QuerySnapshot> future = roadmapsCollection.whereEqualTo("id", map_id).get();
			QuerySnapshot querySnapshot = future.get();
			logger.info("完了: FirestoreからのRoadMapドキュメント取得 (件数: {})", querySnapshot.getDocuments().size());
			if (querySnapshot.getDocuments().isEmpty()) {
				logger.info("ドキュメントが見つかりませんでした");
				return null;
			}
			RoadMap roadMap = querySnapshot.getDocuments().get(0).toObject(RoadMap.class);
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
}
