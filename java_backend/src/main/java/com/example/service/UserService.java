package com.example.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.example.model.User;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.cloud.firestore.WriteResult;

/**
 * ユーザー情報を管理するサービスクラス
 * Firestoreとの連携を行い、ユーザーデータのCRUD操作を提供します
 */
@Service
public class UserService {
	private static final Logger logger = LoggerFactory.getLogger(UserService.class);

	// Firestore関連の定数
	private static final String USERS_COLLECTION = "users";
	
	// ドキュメントのフィールド名
	private static final String FIELD_NAME = "name";
	private static final String FIELD_AGE = "age";
	
	// デフォルト値
	private static final String DEFAULT_NAME = "unknown";
	private static final int DEFAULT_AGE = 0;

	private final Firestore firestore;

	public UserService(Firestore firestore) {
		this.firestore = firestore;
		logger.info("UserService initialized with Firestore instance");
	}

	/**
	 * 全ユーザー情報を取得します
	 * @return ユーザー情報のリスト
	 * @throws InterruptedException Firestore操作が中断された場合
	 * @throws ExecutionException Firestore操作が失敗した場合
	 */
	public List<User> getAllUsers() throws InterruptedException, ExecutionException {
		logger.info("開始: 全ユーザー情報の取得");
		try {
			CollectionReference usersCollection = firestore.collection(USERS_COLLECTION);
			logger.debug("Firestoreコレクション参照取得: {}", USERS_COLLECTION);

			List<QueryDocumentSnapshot> documents = getDocumentsFromFirestore(usersCollection);
			logger.debug("取得したドキュメント数: {}", documents.size());

			List<User> users = convertToUserList(documents);
			logger.info("完了: 全ユーザー情報の取得 (取得件数: {})", users.size());
			return users;
		} catch (Exception e) {
			logger.error("ユーザー情報取得中にエラーが発生しました: {}", e.getMessage(), e);
			throw e;
		}
	}

	/**
	 * Firestoreからドキュメントを取得します
	 */
	private List<QueryDocumentSnapshot> getDocumentsFromFirestore(CollectionReference collection) 
			throws InterruptedException, ExecutionException {
		logger.debug("開始: Firestoreからのドキュメント取得");
		try {
			ApiFuture<QuerySnapshot> future = collection.get();
			QuerySnapshot querySnapshot = future.get();
			List<QueryDocumentSnapshot> documents = querySnapshot.getDocuments();
			logger.debug("完了: Firestoreからのドキュメント取得 (件数: {})", documents.size());
			return documents;
		} catch (InterruptedException | ExecutionException e) {
			logger.error("Firestoreからのドキュメント取得中にエラーが発生: {}", e.getMessage(), e);
			throw e;
		}
	}

	/**
	 * ドキュメントのリストをUserオブジェクトのリストに変換します
	 */
	private List<User> convertToUserList(List<QueryDocumentSnapshot> documents) {
		logger.debug("開始: ドキュメントのUserオブジェクトへの変換 (対象件数: {})", documents.size());
		List<User> userList = new ArrayList<>();
		
		for (QueryDocumentSnapshot doc : documents) {
			try {
				User user = createUserFromDocument(doc);
				userList.add(user);
				logger.debug("ユーザー変換完了: ID={}, Name={}, Age={}", 
					user.getId(), user.getName(), user.getAge());
			} catch (Exception e) {
				logger.warn("ドキュメントの変換中にエラー発生 (ID: {}): {}", 
					doc.getId(), e.getMessage());
			}
		}
		
		logger.debug("完了: ドキュメントのUserオブジェクトへの変換 (変換後件数: {})", userList.size());
		return userList;
	}

	/**
	 * 1つのドキュメントからUserオブジェクトを作成します
	 */
	private User createUserFromDocument(QueryDocumentSnapshot doc) {
		logger.trace("開始: ドキュメントからのUserオブジェクト作成 (ID: {})", doc.getId());
		
		String name = getStringValueOrDefault(doc, FIELD_NAME, DEFAULT_NAME);
		int age = getLongValueAsIntOrDefault(doc, FIELD_AGE, DEFAULT_AGE);
		
		User user = new User(doc.getId(), name, age);
		logger.trace("完了: ドキュメントからのUserオブジェクト作成: {}", user);
		return user;
	}

	/**
	 * ドキュメントから文字列フィールドを取得します
	 */
	private String getStringValueOrDefault(QueryDocumentSnapshot doc, String field, String defaultValue) {
		String value = doc.getString(field);
		if (value == null) {
			logger.debug("フィールド {} が null のためデフォルト値を使用: {}", field, defaultValue);
			return defaultValue;
		}
		return value;
	}

	/**
	 * ドキュメントから数値フィールドを取得します
	 */
	private int getLongValueAsIntOrDefault(QueryDocumentSnapshot doc, String field, int defaultValue) {
		Long value = doc.getLong(field);
		if (value == null) {
			logger.debug("フィールド {} が null のためデフォルト値を使用: {}", field, defaultValue);
			return defaultValue;
		}
		return value.intValue();
	}

	public String createUserWithUID(String uid, String email) throws InterruptedException, ExecutionException {
		logger.info("開始: Firebase UIDでユーザー作成 (UID: {})", uid);
		try {
			CollectionReference usersCollection = firestore.collection(USERS_COLLECTION);
			
			DocumentSnapshot existingUser = usersCollection.document(uid).get().get();
			if (existingUser.exists()) {
				logger.info("ユーザーは既に存在します (UID: {})", uid);
				return uid;
			}

			Map<String, Object> userData = new HashMap<>();
			userData.put(FIELD_NAME, email != null ? email.split("@")[0] : DEFAULT_NAME);
			userData.put(FIELD_AGE, DEFAULT_AGE);
			userData.put("email", email);
			
			ApiFuture<WriteResult> writeResult = usersCollection.document(uid).set(userData);
			writeResult.get();
			
			logger.info("完了: Firebase UIDでユーザー作成 (UID: {})", uid);
			return uid;
		} catch (Exception e) {
			logger.error("Firebase UIDでユーザー作成中にエラーが発生しました: {}", e.getMessage(), e);
			throw e;
		}
	}

	public String createUserWithProfile(String uid, String nickname, int age, 
										String userType, int availableHoursPerDay, 
										int availableDaysPerWeek, String experienceLevel) 
										throws InterruptedException, ExecutionException {
		logger.info("開始: プロファイル付きユーザー作成 (UID: {})", uid);
		try {
			CollectionReference usersCollection = firestore.collection(USERS_COLLECTION);
			
			Map<String, Object> profileData = new HashMap<>();
			profileData.put("userType", userType);
			profileData.put("availableHoursPerDay", availableHoursPerDay);
			profileData.put("availableDaysPerWeek", availableDaysPerWeek);
			profileData.put("experienceLevel", experienceLevel);

			Map<String, Object> userData = new HashMap<>();
			userData.put("id", uid);
			userData.put("nickname", nickname);
			userData.put(FIELD_AGE, age);
			userData.put("profile", profileData);
			userData.put("createdAt", new Date());
			userData.put("updatedAt", new Date());
			
			ApiFuture<WriteResult> writeResult = usersCollection.document(uid).set(userData);
			writeResult.get();
			
			logger.info("完了: プロファイル付きユーザー作成 (UID: {}, ニックネーム: {}, 年齢: {})", 
						uid, nickname, age);
			return uid;
		} catch (Exception e) {
			logger.error("プロファイル付きユーザー作成中にエラーが発生しました: {}", e.getMessage(), e);
			throw e;
		}
	}

	public boolean checkUserMapExists(String userId) throws InterruptedException, ExecutionException {
		logger.info("開始: ユーザーのマップ存在確認 (ユーザーID: {})", userId);
		try {
			CollectionReference mapsCollection = firestore.collection("maps");
			ApiFuture<QuerySnapshot> future = mapsCollection.whereEqualTo("user_id", userId).get();
			QuerySnapshot querySnapshot = future.get();
			
			boolean hasMap = !querySnapshot.getDocuments().isEmpty();
			logger.info("完了: ユーザーのマップ存在確認 (ユーザーID: {}, マップ存在: {})", userId, hasMap);
			return hasMap;
		} catch (Exception e) {
			logger.error("ユーザーのマップ存在確認中にエラーが発生しました: {}", e.getMessage(), e);
			throw e;
		}
	}

	public String getUserMapId(String userId) throws InterruptedException, ExecutionException {
		logger.info("開始: ユーザーのマップID取得 (ユーザーID: {})", userId);
		try {
			CollectionReference mapsCollection = firestore.collection("maps");
			ApiFuture<QuerySnapshot> future = mapsCollection.whereEqualTo("user_id", userId).get();
			QuerySnapshot querySnapshot = future.get();
			
			if (!querySnapshot.getDocuments().isEmpty()) {
				String mapId = querySnapshot.getDocuments().get(0).getId();
				logger.info("完了: ユーザーのマップID取得 (ユーザーID: {}, マップID: {})", userId, mapId);
				return mapId;
			}
			
			logger.info("ユーザーのマップが見つかりません (ユーザーID: {})", userId);
			return null;
		} catch (Exception e) {
			logger.error("ユーザーのマップID取得中にエラーが発生しました: {}", e.getMessage(), e);
			throw e;
		}
	}

	public List<Map<String, Object>> getUserMaps(String userId) throws InterruptedException, ExecutionException {
		logger.info("開始: ユーザーのマップ一覧取得 (ユーザーID: {})", userId);
		try {
			CollectionReference mapsCollection = firestore.collection("maps");
			ApiFuture<QuerySnapshot> future = mapsCollection.whereEqualTo("user_id", userId).get();
			QuerySnapshot querySnapshot = future.get();
			
			List<Map<String, Object>> mapsList = new ArrayList<>();
			for (DocumentSnapshot doc : querySnapshot.getDocuments()) {
				if (doc.exists()) {
					Map<String, Object> mapData = new HashMap<>();
					mapData.put("mapId", doc.getId());
					mapData.put("title", doc.getString("title"));
					mapData.put("objective", doc.getString("objective"));
					mapData.put("deadline", doc.getDate("deadline"));
					mapsList.add(mapData);
				}
			}
			
			logger.info("完了: ユーザーのマップ一覧取得 (ユーザーID: {}, マップ数: {})", userId, mapsList.size());
			return mapsList;
		} catch (Exception e) {
			logger.error("ユーザーのマップ一覧取得中にエラーが発生しました: {}", e.getMessage(), e);
			throw e;
		}
	}
}
