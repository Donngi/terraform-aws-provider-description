---
name: batch-create-annotated-tf
description: AWS Providerのバージョン差分を自動検出し、変更があったTerraformリソースに対して解説付きテンプレートを一括生成するスキル。前回処理バージョンとの差分のみを処理する。
---

# Batch Create Annotated Terraform Templates (Auto-Diff Version)

AWS Providerのバージョン差分を自動検出し、変更があったリソース（新規追加・属性変更）のみ解説付きテンプレートを**並列で**一括生成する。

## 実行ガイドライン（Claudeへの指示）

### 並列処理の仕様
- **並列度**: 常時MAX 8で実行
- **ループ**: 全件処理が完了するまで繰り返す
- **バッチ処理**: 8件ずつ並列実行し、完了後に次の8件を開始

### 実装パターン
```
RESOURCES = 差分検出された全リソースのリスト
BATCH_SIZE = 8

while RESOURCES が空でない:
    BATCH = RESOURCES から最大8件を取得
    RESOURCES から BATCH を削除

    Task tool で BATCH の全リソースを並列実行（1メッセージで8つのTask呼び出し）

    全Taskの完了を待機

    結果をログに記録
```

### エラー時のみ確認可
- スクリプトの実行エラーが発生した場合のみ、ユーザーに報告・確認してよい

## アーキテクチャ

### バージョン管理ファイル

**ファイル名:** `processed_provider_version.json`  
**配置場所:** プロジェクトルート直下

```json
{
  "format_version": "1.0",
  "last_processed": {
    "version": "6.28.0",
    "timestamp": "2026-01-17T14:30:00Z",
    "total_resources": 1593,
    "processed_resources": 1593,
    "schema_checksum": "sha256:abcd1234..."
  },
  "processing_history": [
    {
      "version": "6.27.0",
      "timestamp": "2026-01-10T10:00:00Z",
      "total_resources": 1590,
      "processed_resources": 15
    }
  ]
}
```

### 処理フロー

```
1. 最新バージョン取得 → lib/01_fetch_latest_version.sh
2. 前回バージョン読み込み → lib/02_load_last_version.sh
3. バージョン比較（同一なら終了）
4. スキーマ準備 → lib/03_prepare_schema.sh
5. 差分検出 → lib/04_detect_changes.sh
6. 並列処理実行（Task tool）
7. 削除リソースのアーカイブ → lib/05_archive_removed.sh
8. バージョン管理ファイル更新 → lib/06_update_version_file.sh
9. 変更ログ生成 → lib/07_generate_changelog.sh
```

## ワークフロー

### Step 1: 最新バージョン取得

```bash
LATEST_VERSION=$(lib/01_fetch_latest_version.sh)
```

**実装:** `lib/01_fetch_latest_version.sh`
- Terraform Registry APIから最新バージョンを取得
- タイムアウト: 10秒
- 出力: バージョン番号（例: `6.28.0`）

### Step 2: 前回バージョン読み込み

```bash
LAST_VERSION=$(lib/02_load_last_version.sh)
```

**実装:** `lib/02_load_last_version.sh`
- `processed_provider_version.json`から前回バージョンを取得
- ファイル破損時は自動復旧（バックアップまたは初期化）
- 出力: バージョン番号または空文字列

### Step 3: バージョン比較

```bash
if [[ "$LATEST_VERSION" == "$LAST_VERSION" && -n "$LAST_VERSION" ]]; then
  echo "✅ No version change detected. Provider version: $LATEST_VERSION"
  exit 0
fi

echo "🔄 Version update detected: ${LAST_VERSION:-'(initial)'} → $LATEST_VERSION"
```

### Step 4: スキーマ準備

```bash
CURRENT_SCHEMA=$(lib/03_prepare_schema.sh "$LATEST_VERSION")
LAST_SCHEMA="tmp/${LAST_VERSION}/schema.json"
```

**実装:** `lib/03_prepare_schema.sh <version>`
- 指定バージョンのスキーマが未取得の場合、取得する
- `terraform init` + `terraform providers schema -json`を実行
- 出力: スキーマファイルのパス

### Step 5: 差分検出

```bash
if [[ -n "$LAST_VERSION" && -f "$LAST_SCHEMA" ]]; then
  CHANGES=$(lib/04_detect_changes.sh "$CURRENT_SCHEMA" "$LAST_SCHEMA")
else
  # 初回実行
  CHANGES=$(lib/04_detect_changes.sh "$CURRENT_SCHEMA")
fi
```

**実装:** `lib/04_detect_changes.sh <current_schema> [last_schema]`

**出力:** JSON形式の差分情報
```json
{
  "added": ["aws_bedrock_agent", "aws_new_service"],
  "changed": ["aws_s3_bucket", "aws_lambda_function"],
  "removed": ["aws_old_service"]
}
```

**差分検出アルゴリズム:**

#### 新規リソース検出
```bash
comm -13 <(前回のリソースリスト | sort) <(現在のリソースリスト | sort)
```
- `comm -13`: 第1列（前回のみ）と第3列（共通）を非表示
- **結果**: 現在のみに存在 = 新規追加リソース

#### 変更リソース検出
```bash
for resource in $COMMON_RESOURCES; do
  CURRENT_HASH=$(jq -c ".provider_schemas[...].resource_schemas[\"$resource\"]" current | sha256sum)
  LAST_HASH=$(jq -c ".provider_schemas[...].resource_schemas[\"$resource\"]" last | sha256sum)
  
  if [[ "$CURRENT_HASH" != "$LAST_HASH" ]]; then
    # 変更されたリソース
  fi
done
```
- リソース定義全体のSHA256ハッシュを比較
- ハッシュ値が異なる = スキーマ定義が変更された

#### 削除リソース検出
```bash
comm -23 <(前回のリソースリスト | sort) <(現在のリソースリスト | sort)
```
- `comm -23`: 第2列（現在のみ）と第3列（共通）を非表示
- **結果**: 前回のみに存在 = 削除されたリソース

### Step 6: 処理対象の決定と並列処理（MAX 8並列）

```bash
ADDED=$(echo "$CHANGES" | jq -r '.added[]')
CHANGED=$(echo "$CHANGES" | jq -r '.changed[]')
RESOURCES_TO_PROCESS=$(echo -e "${ADDED}\n${CHANGED}" | grep -v '^$' | sort -u)

TOTAL_COUNT=$(echo "$RESOURCES_TO_PROCESS" | wc -l)

if [[ $TOTAL_COUNT -eq 0 ]]; then
  echo "✅ No changes detected in resources."
  exit 0
fi

echo "📋 Processing $TOTAL_COUNT resources..."
```

**並列処理ループ（MAX 8件ずつ）:**

```
BATCH_SIZE = 8
PROCESSED = 0

while PROCESSED < TOTAL_COUNT:
    # 次の8件を取得
    BATCH = RESOURCES_TO_PROCESS[PROCESSED : PROCESSED + 8]
    
    # 1メッセージで最大8つのTask呼び出し（並列実行）
    for resource in BATCH:
        Task(
          subagent_type="general-purpose",
          description="Generate {resource} template",
          prompt="Execute /create-annotated-tf {resource} with provider version {version}"
        )
    
    # 全Taskの完了を待機
    # 結果をログに記録
    
    PROCESSED += len(BATCH)
    echo "Progress: $PROCESSED / $TOTAL_COUNT"
```

**注意:**
- 全てのTask呼び出しを**1つのレスポンス内**で行うことで並列実行される
- ユーザー確認は一切行わない
- エラーが発生しても他のリソースの処理は継続

### Step 7: 削除リソースのアーカイブ

```bash
REMOVED=$(echo "$CHANGES" | jq -c '.removed')
lib/05_archive_removed.sh "$REMOVED"
```

**実装:** `lib/05_archive_removed.sh <removed_resources_json>`
- 削除されたリソースのテンプレートを `terraform-template/archived/` に移動

### Step 8: バージョン管理ファイル更新

```bash
TOTAL_RESOURCES=$(jq -r '.provider_schemas[...].resource_schemas | keys | length' "$CURRENT_SCHEMA")
SCHEMA_CHECKSUM=$(sha256sum "$CURRENT_SCHEMA" | cut -d' ' -f1)

lib/06_update_version_file.sh "$LATEST_VERSION" "$TOTAL_RESOURCES" "$TOTAL_COUNT" "$SCHEMA_CHECKSUM"
```

**実装:** `lib/06_update_version_file.sh <version> <total> <processed> <checksum>`
- `processed_provider_version.json`を更新
- バックアップを自動作成（`.backup`）

### Step 9: 変更ログ生成

```bash
lib/07_generate_changelog.sh "$LATEST_VERSION" "$LAST_VERSION" "$CHANGES"
```

**実装:** `lib/07_generate_changelog.sh <new_version> <old_version> <changes_json>`
- 変更ログを `tmp/{version}/change_log.txt` に生成

**出力例:**
```
Provider Version Update: 6.27.0 → 6.28.0
Generated: 2026-01-17T15:30:00Z

=== Summary ===
New Resources: 3
Changed Resources: 15
Removed Resources: 1
Total Processed: 18

=== New Resources ===
aws_bedrock_agent
...

=== Changed Resources ===
aws_s3_bucket
...

=== Removed Resources (Archived) ===
aws_old_service
```

## 使用例

```bash
# 初回実行（全リソース処理）
/batch-create-annotated-tf

# 2回目以降（差分のみ処理）
/batch-create-annotated-tf

# バージョンに変更がない場合
# → "No version change detected" メッセージが表示され、処理なし
```

## ファイル構成

```
プロジェクトルート/
├── processed_provider_version.json      # バージョン管理ファイル
├── .claude/skills/batch-create-annotated-tf/
│   ├── SKILL.md                         # このファイル
│   └── lib/
│       ├── utils.sh                     # 共通ユーティリティ
│       ├── 01_fetch_latest_version.sh   # Step 1
│       ├── 02_load_last_version.sh      # Step 2
│       ├── 03_prepare_schema.sh         # Step 3
│       ├── 04_detect_changes.sh         # Step 4
│       ├── 05_archive_removed.sh        # Step 5
│       ├── 06_update_version_file.sh    # Step 6
│       └── 07_generate_changelog.sh     # Step 7
├── tmp/
│   └── {version}/
│       ├── providers.tf
│       ├── schema.json
│       └── change_log.txt
└── terraform-template/
    ├── {resource}.tf
    └── archived/
        └── {removed_resource}.tf
```

## 並列処理の利点

| 方式 | 3リソース | 10リソース | 差分18件 |
|------|----------|-----------|---------|
| 直列処理 | 約15分 | 約50分 | 約90分 |
| **並列処理** | **約5分** | **約5-10分** | **約8-12分** |

※ 並列処理により、リソース数が増えても処理時間の増加が緩やかになる。

## 注意事項

- **差分のみ処理:** 前回バージョンから変更があったリソースのみ処理
- **初回実行:** `processed_provider_version.json` が存在しない場合、全リソースを処理
- **並列実行:** 一時的にリソース使用量が増加
- **エラー継続:** エラーが発生しても他のリソースの処理は継続
- **上書き:** 既存テンプレートファイルは上書きされる
- **アーカイブ:** 削除されたリソースのテンプレートは `terraform-template/archived/` に移動
