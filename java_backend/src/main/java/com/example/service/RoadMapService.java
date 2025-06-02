package com.example.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.example.dto.RoadMapResponse;
import com.example.model.Node;
import com.example.model.NodeStyle;
import com.example.model.RoadMap;
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
	Map<String, Node> idToNodeMap = new HashMap<>();

	public RoadMapService(Firestore firestore) {
		this.firestore = firestore;
		logger.info("UserService initialized with Firestore instance");
	}

	public RoadMapResponse getRoadMapResponse(String map_id) {
		RoadMap roadMap = getRoadMap(map_id);
		List<Node> nodes = getNodes(map_id);
		NodeStyle nodeStyle = NodeStyle.createNodeStyle();
		createTree(nodes);
		printTreeStructure(nodes);
		RoadMapResponse rs = new RoadMapResponse(roadMap, nodes, nodeStyle);
		return rs;
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

	public void createTree(List<Node> nodes) {
		// Clear existing map
		idToNodeMap.clear();
		
		// First pass: Create ID to Node mapping
		for (Node node : nodes) {
			idToNodeMap.put(node.getId(), node);
		}
		
		// Find start and goal nodes
		Node startNode = nodes.stream()
			.filter(n -> "start".equals(n.getNode_type()))
			.findFirst()
			.orElse(null);
			
		Node endNode = nodes.stream()
			.filter(n -> "end".equals(n.getNode_type()))
			.findFirst()
			.orElse(null);
		
		// Second pass: Set parent-child relationships and establish order
		for (Node node : nodes) {
			if (node.getChildren_ids() != null) {
				for (String childId : node.getChildren_ids()) {
					Node childNode = idToNodeMap.get(childId);
					if (childNode.getChildren_ids() == null) {
						childNode.setParent_id(node.getId());
					}
				}
			}
		}

		System.out.println("startNode: " + startNode.getId());
		System.out.println("endNode: " + endNode.getId());
	}

	public void printTreeStructure(List<Node> nodes) {
    // idToNodeMap から親IDがnullまたは空文字のルートノードを探す
    Node startNode = nodes.stream()
			.filter(n -> "start".equals(n.getNode_type()))
			.findFirst()
			.orElse(null);
		Node nextStartNode = idToNodeMap.get(startNode.getNext_id());
		logger.info("nextStartNode: " + nextStartNode.getId());
		printNodeRecursively(nextStartNode, 0);
	}

	private void printNodeRecursively(Node node, int depth) {
			String indent = " ".repeat(depth * 2);
			System.out.println(indent + "- " + node.getTitle() + " (ID: " + node.getId() + ") "+" 親ノード: " + node.getParent_id() + " 子ノード: " + node.getChildren_ids());

			// 子ノードは parent_id == node.id のものをidToNodeMapから探す
			List<Node> children = idToNodeMap.values().stream()
					.filter(n -> node.getId().equals(n.getParent_id()))
					.collect(Collectors.toList());

			for (Node child : children) {
					printNodeRecursively(child, depth + 1);
			}
	}

}


