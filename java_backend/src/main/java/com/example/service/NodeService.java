package com.example.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.dto.Node;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.cloud.firestore.WriteResult;

@Service
public class NodeService {
    private static final Logger logger = LoggerFactory.getLogger(NodeService.class);
    
    private final Firestore firestore;
    private static final String NODES_COLLECTION = "nodes";
    
    @Autowired
    public NodeService(Firestore firestore) {
        this.firestore = firestore;
        logger.info("NodeService initialized with Firestore instance");
    }
    
    public Node getNodeById(String nodeId) throws InterruptedException, ExecutionException {
        logger.info("開始: ノード取得 (ID: {})", nodeId);
        
        DocumentReference docRef = firestore.collection(NODES_COLLECTION).document(nodeId);
        ApiFuture<DocumentSnapshot> future = docRef.get();
        DocumentSnapshot document = future.get();
        
        if (document.exists()) {
            Node node = document.toObject(Node.class);
            logger.info("ノード取得完了: ID={}, Title={}", node.getId(), node.getTitle());
            return node;
        } else {
            logger.warn("ノードが見つかりませんでした: ID={}", nodeId);
            return null;
        }
    }
    
    public Node createNode(Node node) throws InterruptedException, ExecutionException {
        logger.info("開始: ノード作成 (Title: {})", node.getTitle());
        
        if (node.getId() == null || node.getId().isEmpty()) {
            if (node.getParent_id() != null && !node.getParent_id().isEmpty()) {
                int childCount = getChildCountForParent(node.getParent_id());
                node.setId(node.getParent_id() + "-" + (childCount + 1));
            } else {
                node.setId("node-" + UUID.randomUUID().toString().substring(0, 8));
            }
        }

        Date now = new Date();
        node.setCreated_at(now);
        node.setUpdated_at(now);
        
        DocumentReference docRef = firestore.collection(NODES_COLLECTION).document(node.getId());
        ApiFuture<WriteResult> future = docRef.set(node);
        WriteResult result = future.get();
        
        logger.info("ノード作成完了: ID={}, Title={}, 作成時刻={}", 
                   node.getId(), node.getTitle(), result.getUpdateTime());
        
        return node;
    }
    
    public Node updateNode(Node node) throws InterruptedException, ExecutionException {
        logger.info("開始: ノード更新 (ID: {})", node.getId());
        
        node.setUpdated_at(new Date());

        DocumentReference docRef = firestore.collection(NODES_COLLECTION).document(node.getId());
        ApiFuture<WriteResult> future = docRef.set(node);
        WriteResult result = future.get();
        
        logger.info("ノード更新完了: ID={}, 更新時刻={}", node.getId(), result.getUpdateTime());
        
        return node;
    }
    
    public List<Node> createNodes(List<Node> nodes) throws InterruptedException, ExecutionException {
        logger.info("開始: 複数ノード一括作成 (件数: {})", nodes.size());
        
        List<Node> createdNodes = new ArrayList<>();
        
        for (Node node : nodes) {
            Node createdNode = createNode(node);
            createdNodes.add(createdNode);
        }
        
        logger.info("複数ノード一括作成完了 (作成件数: {})", createdNodes.size());
        return createdNodes;
    }
    
    private int getChildCountForParent(String parentId) throws InterruptedException, ExecutionException {
        CollectionReference nodesCollection = firestore.collection(NODES_COLLECTION);
        ApiFuture<QuerySnapshot> future = nodesCollection.whereEqualTo("parent_id", parentId).get();
        QuerySnapshot querySnapshot = future.get();
        return querySnapshot.getDocuments().size();
    }
}
