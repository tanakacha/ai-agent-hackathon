package com.example.service;

import com.example.dto.RoadmapDocument;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.WriteResult;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import static org.mockito.Mockito.lenient;

import java.util.concurrent.ExecutionException;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class) // JUnit5でMockitoを有効にするためのアノテーション
class RoadmapDocumentServiceTest {

    // --- モック（偽物）の準備 ---
    @Mock // Firestoreの偽物を作成
    private Firestore firestore;

    @Mock // Firestore SDKが内部で使うオブジェクトも、偽物を用意する必要がある
    private CollectionReference collectionReference;
    @Mock
    private DocumentReference documentReference;
    @Mock
    private ApiFuture<DocumentSnapshot> apiFuture;
    @Mock
    private DocumentSnapshot documentSnapshot;
    @Mock
    private ApiFuture<WriteResult> writeApiFuture;
    @Mock
    private WriteResult writeResult;

    // --- テスト対象のクラス ---
    @InjectMocks // @Mockのアノテーションが付いた偽物たちを、このクラスに自動で注入してくれる
    private RoadmapDocumentService roadmapDocumentService;

    // 各テストが実行される前に、このメソッドが一度呼ばれる
    @BeforeEach
    void setUp() {
        // モックの振る舞いを定義する
        // firestore.collection(anyString()) が呼ばれたら、偽物のcollectionReferenceを返すように設定
        lenient().when(firestore.collection(anyString())).thenReturn(collectionReference);
        lenient().when(collectionReference.document(anyString())).thenReturn(documentReference);
    }

    // --- テストケース ---

    @Test
    void findById_ドキュメントが存在する場合_RoadmapDocumentを返す() throws ExecutionException, InterruptedException {
        // --- Given (前提条件の設定) ---
        String roadmapId = "test-map-123";
        RoadmapDocument expectedDocument = new RoadmapDocument();
        expectedDocument.setId(roadmapId);
        expectedDocument.setGoal("テストゴール");

        // documentReference.get() が呼ばれたら...というように、メソッド呼び出しの連鎖を定義していく
        when(documentReference.get()).thenReturn(apiFuture);
        when(apiFuture.get()).thenReturn(documentSnapshot);
        when(documentSnapshot.exists()).thenReturn(true); // ドキュメントは「存在する」フリをする
        when(documentSnapshot.toObject(RoadmapDocument.class)).thenReturn(expectedDocument); // toObjectが呼ばれたら、用意した偽のデータを返す

        // --- When (テスト対象メソッドの実行) ---
        RoadmapDocument actualDocument = roadmapDocumentService.findById(roadmapId);

        // --- Then (結果の検証) ---
        assertThat(actualDocument).isNotNull(); // 結果がnullでないこと
        assertThat(actualDocument.getId()).isEqualTo(roadmapId); // IDが一致すること
        assertThat(actualDocument.getGoal()).isEqualTo("テストゴール"); // 中身が正しいこと

        // サービスが正しいコレクションとドキュメントIDを呼び出したか検証
        verify(firestore).collection("maps");
        verify(collectionReference).document(roadmapId);
    }

    @Test
    void findById_ドキュメントが存在しない場合_nullを返す() throws ExecutionException, InterruptedException {
        // --- Given (前提条件の設定) ---
        String roadmapId = "not-found-id";
        when(documentReference.get()).thenReturn(apiFuture);
        when(apiFuture.get()).thenReturn(documentSnapshot);
        when(documentSnapshot.exists()).thenReturn(false); // ドキュメントは「存在しない」フリをする

        // --- When (テスト対象メソッドの実行) ---
        RoadmapDocument actualDocument = roadmapDocumentService.findById(roadmapId);

        // --- Then (結果の検証) ---
        assertThat(actualDocument).isNull(); // 結果がnullであること
    }

    @Test
    void save_正常なRoadmapDocumentを渡すと_成功する() throws ExecutionException, InterruptedException {
        // --- Given (前提条件の設定) ---
        RoadmapDocument documentToSave = new RoadmapDocument();
        documentToSave.setId("new-map-456");
        documentToSave.setGoal("保存テスト");

        // documentReference.set(...) が呼ばれたときの振る舞いを定義
        when(documentReference.set(any(RoadmapDocument.class))).thenReturn(writeApiFuture);
        when(writeApiFuture.get()).thenReturn(writeResult);

        // --- When (テスト対象メソッドの実行) ---
        RoadmapDocument savedDocument = roadmapDocumentService.save(documentToSave);

        // --- Then (結果の検証) ---
        assertThat(savedDocument).isNotNull();
        assertThat(savedDocument.getId()).isEqualTo("new-map-456");

        // documentReference.set()が、正しいオブジェクトを引数にして呼び出されたか検証
        verify(documentReference).set(documentToSave);
    }
    
    @Test
    void save_IDがnullの場合_IllegalArgumentExceptionをスローする() {
        // --- Given (前提条件の設定) ---
        RoadmapDocument documentWithoutId = new RoadmapDocument(); // IDがnull

        // --- When & Then (実行と例外の検証) ---
        // saveメソッドを実行すると、IllegalArgumentExceptionが投げられることを表明する
        assertThrows(IllegalArgumentException.class, () -> {
            roadmapDocumentService.save(documentWithoutId);
        });
    }
}
