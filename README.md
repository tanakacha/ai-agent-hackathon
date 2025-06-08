# ai-agent-hackathon

第2回 AI Agent Hackathon with Google Cloud by Zenn

## Java_Backendの立ち上げ方

このドキュメントでは、Spring Boot アプリケーションの開発環境を立ち上げる手順を説明します。

---

## Gradle のバージョン確認

まず、Gradle が正しくインストールされていることを確認してください。

```sh
gradle --version
```

---

## 環境変数ファイルの配置

環境変数ファイル（`.env`）を以下のディレクトリに配置してください：

```
ai-agent-hackathon/java_backend/.env
```

---

## Google Cloud 認証キーの確認

google cloud cliのGoogle Account認証を行います。
```sh
gcloud config
```

Google Cloud Secret Service Managerがロードされていることを確認します。

```sh
gcloud secrets list --project=ai-hackathon-460510

NAME           CREATED              REPLICATION_POLICY  LOCATIONS
firebase-key   2025-06-04T12:41:36  automatic           -
vertex-ai-key  2025-06-04T13:07:33  automatic           -
```

---

## 開発用サーバーの起動

以下のコマンドをプロジェクトのルートディレクトリ（`ai-agent-hackathon/java_backend`）で実行します。

```sh
./gradlew bootRun
```

Spring Boot アプリケーションが起動し、`http://localhost:8080` でAPIにアクセスできるようになります。
