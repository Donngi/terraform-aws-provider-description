---
name: batch-create-annotated-tf
description: AWS Providerのバージョン差分を自動検出し、変更があったTerraformリソースに対して解説付きテンプレートを一括生成するスキル。前回処理バージョンとの差分のみを処理する。
available_tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Task
  - TaskOutput
  - mcp__*
---

# Batch Create Annotated Terraform Templates 

AWS Providerのバージョン差分を自動検出し、変更があったリソース（新規追加・属性変更）のみ解説付きテンプレートを**並列で**一括生成する。

## ツール使用の制約

**絶対に使用禁止:**
- WebSearch
- WebFetch

**使用必須:**
- Task toolで`/terraform-aws-annotated-reference`を呼び出す際も、Web検索は使用されない
- ドキュメント取得は必ずMCPツール経由で行われる
- エラーが発生した場合でも、Web検索にフォールバックしない

## 実行環境の前提条件

親エージェントがファイル書き込みを行うため、サンドボックス無効化は不要。
初回実行時に以下の書き込み権限確認が表示される:
- `.local/` ディレクトリ（状態管理ファイル）
- `terraform-template/` ディレクトリ（生成テンプレート）

## 実行ガイドライン（Claudeへの指示）

### 並列処理の仕様
- **並列度**: 常時MAX 8で実行
- **ループ**: 全件処理が完了するまで繰り返す
- **バッチ処理**: 8件ずつ並列実行し、完了後に次の8件を開始
- **タイムアウト**: 各Taskは5分（300000ms）でタイムアウト
- **チェックポイント**: 処理済みリソースをファイルに記録
- **重複防止**: 処理前に完了リストをチェック
- **起動前ガード**: 既に完了したリソースは起動しない

### 状態管理ファイル
```
.local/{version}/completed_resources.txt  # 処理済みリソース一覧（1行1リソース）
.local/{version}/current_batch.json       # 現在のバッチ状態
```

**注意:** `.local/` はサンドボックス環境でも書き込み可能なディレクトリ。すべての一時ファイル・状態管理ファイルはこのディレクトリに保存する。

**completed_resources.txt の形式:**
```
aws_s3_bucket
aws_lambda_function
aws_iam_role
...
```

**current_batch.json の形式:**
```json
{
  "batch": ["aws_s3_bucket", "aws_lambda_function", ...],
  "task_ids": [
    {"resource": "aws_s3_bucket", "task_id": "abc123"},
    {"resource": "aws_lambda_function", "task_id": "def456"}
  ],
  "status": "starting" | "waiting" | "batch_completed"
}
```

### 実装パターン（run_in_background + TaskOutput + チェックポイント）
```
RESOURCES = 差分検出された全リソースのリスト
BATCH_SIZE = 8
TIMEOUT_MS = 300000  # 5分
VERSION = 現在処理中のバージョン

# ===== Compacting後の復元処理（ループ開始前に必ず実行） =====
BATCH_STATE = read(.local/{VERSION}/current_batch.json) または null

if BATCH_STATE != null && BATCH_STATE.status == "waiting":
    # 前のバッチのPhase 2が未完了 → 既存task_idsの結果取得を続行
    COMPLETED = read(.local/{VERSION}/completed_resources.txt) または 空リスト

    for {resource, task_id} in BATCH_STATE.task_ids:
        if resource not in COMPLETED:
            # まだ結果取得していないリソースのみ処理
            result = TaskOutput(task_id, block=true, timeout=TIMEOUT_MS)
            if ファイル生成確認:
                append(resource, .local/{VERSION}/completed_resources.txt)
            else:
                FAILED

    # 復元バッチ完了
    save({status: "batch_completed"}, .local/{VERSION}/current_batch.json)

elif BATCH_STATE != null && BATCH_STATE.status == "starting":
    # Phase 1が未完了 → task_idsが不完全なため、このバッチはスキップ
    # (リソースはcompleted_resources.txtに記録されていないため、次のバッチで再処理される)
    save({status: "batch_completed"}, .local/{VERSION}/current_batch.json)

# ===== 通常のループ処理 =====
while RESOURCES が空でない:
    # 1. 完了済みリソースをロード
    COMPLETED = read(.local/{VERSION}/completed_resources.txt) または 空リスト
    RESOURCES = RESOURCES - COMPLETED  # 差分のみ対象

    if RESOURCES が空:
        break

    # 2. バッチ準備（8件）
    BATCH = RESOURCES から最大8件を取得
    RESOURCES から BATCH を削除

    # 3. バッチ状態を保存（starting）
    save({batch: BATCH, status: "starting"}, .local/{VERSION}/current_batch.json)

    # 4. Phase 1: 全Taskをバックグラウンドで起動
    TASK_IDS = []
    for resource in BATCH:
        task_id = Task(run_in_background=true, ...)
        TASK_IDS.append({resource, task_id})

    # 5. バッチ状態を更新（waiting）
    save({batch: BATCH, task_ids: TASK_IDS, status: "waiting"}, .local/{VERSION}/current_batch.json)

    # 6. Phase 2: TaskOutputで各Taskの結果を取得（タイムアウト付き）
    for {resource, task_id} in TASK_IDS:
        result = TaskOutput(task_id, block=true, timeout=TIMEOUT_MS)
        if ファイル生成確認:
            append(resource, .local/{VERSION}/completed_resources.txt)  # チェックポイント
        else:
            FAILED（タイムアウトまたはエラー）

    # 7. バッチ完了
    save({status: "batch_completed"}, .local/{VERSION}/current_batch.json)

    結果をログに記録
```

### エラー時のみ確認可
- スクリプトの実行エラーが発生した場合のみ、ユーザーに報告・確認してよい
- タイムアウトしたTaskは失敗として記録し、処理を継続する

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
LAST_SCHEMA=".local/${LAST_VERSION}/schema.json"
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

### Step 6: 処理対象の決定と並列処理（MAX 8並列、タイムアウト付き）

#### 6.1 処理対象リストの作成

```bash
ADDED=$(echo "$CHANGES" | jq -r '.added[]')
CHANGED=$(echo "$CHANGES" | jq -r '.changed[]')
RESOURCES_TO_PROCESS=$(echo -e "${ADDED}\n${CHANGED}" | grep -v '^$' | sort -u)
TOTAL_COUNT=$(echo "$RESOURCES_TO_PROCESS" | wc -l | tr -d ' ')

if [[ $TOTAL_COUNT -eq 0 ]]; then
  echo "No changes detected in resources."
  exit 0
fi

echo "Processing $TOTAL_COUNT resources..."
```

#### 6.2 並列処理の実行（run_in_background + TaskOutput + チェックポイント パターン）

**並列処理のルール（Claudeへの指示）:**

**【重要】ループ開始前の復元処理（Compacting対応）:**

0. **バッチ状態の確認**: `.local/{version}/current_batch.json` を読み込み
   - **status == "waiting"** の場合: 前のバッチのPhase 2が未完了
     → 保存されている `task_ids` を使って結果取得を続行（新しいバッチを起動しない）
     → 完了後、status を `batch_completed` に更新してから通常ループへ
   - **status == "starting"** の場合: Phase 1が未完了（task_idsが不完全）
     → status を `batch_completed` に更新（リソースは次のバッチで再処理される）
   - **status == "batch_completed"** または **ファイルなし**: 通常ループを開始

**通常ループ処理:**

1. **完了済みリソースのロード**: `.local/{version}/completed_resources.txt` を読み込み、既に完了したリソースを除外
2. リソースリストを8件ずつのバッチに分割する
3. **バッチ状態を保存（starting）**: `.local/{version}/current_batch.json` に記録
4. **Phase 1（起動）**: 8件のTaskを `run_in_background: true` で**1メッセージで同時に**起動し、task_idを記録
5. **バッチ状態を更新（waiting）**: task_idを含めて `current_batch.json` を更新
6. **Phase 2（結果取得）**: 各task_idに対して `TaskOutput` を呼び出し、結果を取得
7. **チェックポイント**: 成功したリソースを `completed_resources.txt` に追記
8. **バッチ状態を更新（batch_completed）**: `current_batch.json` を更新
9. 同一バッチのすべての処理が完全に終了するまで待機。処理中にUsage Limitに達すると使用量が無駄となるため、絶対に同一バッチの8 taskが完了するまで次のバッチを起動しない。
10. 全リソースが処理されるまで1-9を繰り返す

**状態管理ファイルの操作:**

```bash
VERSION="..."  # 現在処理中のバージョン
BATCH_FILE=".local/${VERSION}/current_batch.json"
COMPLETED_FILE=".local/${VERSION}/completed_resources.txt"

# ===== 復元処理（ループ開始前に必ず実行） =====
if [[ -f "$BATCH_FILE" ]]; then
    BATCH_STATUS=$(jq -r '.status' "$BATCH_FILE")

    if [[ "$BATCH_STATUS" == "waiting" ]]; then
        # 前のバッチのPhase 2を続行
        # task_idsを読み込み、completed_resources.txtにないリソースの結果を取得
        # → TaskOutput(task_id, block=true, timeout=300000)
        # → 成功したらcompleted_resources.txtに追記
        echo '{"status": "batch_completed"}' > "$BATCH_FILE"

    elif [[ "$BATCH_STATUS" == "starting" ]]; then
        # Phase 1が未完了 → スキップ（次のバッチで再処理）
        echo '{"status": "batch_completed"}' > "$BATCH_FILE"
    fi
fi

# ===== 通常ループ処理 =====
# completed_resources.txt の読み込み
if [[ -f "$COMPLETED_FILE" ]]; then
    COMPLETED_RESOURCES=$(cat "$COMPLETED_FILE")
else
    COMPLETED_RESOURCES=""
fi

# 完了済みリソースを除外
RESOURCES_TO_PROCESS = RESOURCES - COMPLETED_RESOURCES

# バッチ状態の保存（starting）
echo '{"batch": [...], "status": "starting"}' > "$BATCH_FILE"

# バッチ状態の更新（waiting）
echo '{"batch": [...], "task_ids": [...], "status": "waiting"}' > "$BATCH_FILE"

# チェックポイント（成功したリソースを追記）
echo "$resource" >> "$COMPLETED_FILE"

# バッチ完了状態の保存
echo '{"status": "batch_completed"}' > "$BATCH_FILE"
```

**Phase 1: Task起動の形式**

各リソースに対して以下の形式でTask toolを呼び出す（**1メッセージで8件同時**）:

- **subagent_type**: `"general-purpose"`
- **description**: `"Generate {resource_name} template"`
- **prompt**: `"/terraform-aws-annotated-reference {resource_name} provider_version={provider version} output_mode=content"`
- **max_turns**: `50`（十分な処理ステップを確保）
- **run_in_background**: `true`（バックグラウンドで実行）

**Phase 2: TaskOutput による結果取得**

Phase 1で取得した各task_idに対して、TaskOutputを呼び出す:

- **task_id**: Phase 1で返されたtask_id
- **block**: `true`（完了まで待機）
- **timeout**: `300000`（5分 = 300,000ミリ秒）

**Phase 3: コンテンツ抽出とファイル書き込み**

TaskOutputの結果からJSONを抽出し、親エージェントでファイル書き込み:

1. TaskOutput結果から `{"status":` で始まるJSONを検索
2. `status == "success"` なら `content` フィールドを抽出
3. 親エージェントのWriteツールで `terraform-template/{resource}.tf` に書き込み
4. 成功したリソースを `completed_resources.txt` に記録

**実行フロー:**

```
処理対象リソース: [r1, r2, r3, ..., rN]
バッチサイズ: 8
タイムアウト: 300000ms (5分)
VERSION: 現在処理中のバージョン

=== 復元処理（ループ開始前に必ず実行） ===
[バッチ状態確認] .local/{VERSION}/current_batch.json を読み込み

if status == "waiting":
  # 前のバッチのPhase 2を続行（新しいバッチを起動しない！）
  → 保存されているtask_idsを使ってTaskOutputを呼び出し
  → completed_resources.txtにないリソースのみ結果取得
  → 完了後、status = "batch_completed"

elif status == "starting":
  # Phase 1未完了 → スキップ
  → status = "batch_completed"

=== 通常ループ開始 ===
[完了済みロード] .local/{VERSION}/completed_resources.txt を読み込み
  → 例: [r1, r2, r3] が既に完了済み
  → 処理対象から除外: [r4, r5, ..., rN]

=== バッチ1: [r4, r5, r6, r7, r8, r9, r10, r11] ===

[バッチ状態保存: starting]
  → current_batch.json = {batch: [...], status: "starting"}

[Phase 1: 起動] 1メッセージで8つのTask呼び出し（run_in_background: true）
  → 即座にtask_idが返る: [id4, id5, id6, id7, id8, id9, id10, id11]
  → 8つのTaskはバックグラウンドで並列実行開始

[バッチ状態保存: waiting]
  → current_batch.json = {batch: [...], task_ids: [...], status: "waiting"}

[Phase 2: 結果取得 + チェックポイント]
  → TaskOutput(id4, block=true, timeout=300000) → 成功 → echo "r4" >> completed_resources.txt
  → TaskOutput(id5, block=true, timeout=300000) → 成功 → echo "r5" >> completed_resources.txt
  → ... (8件すべて、各成功時にチェックポイント)

[バッチ状態保存: batch_completed]
  → current_batch.json = {status: "batch_completed"}

=== バッチ2: [r12, r13, ...] ===
... 以下、全リソース完了まで繰り返し
```

**Compacting後の復元（並列度8を維持するための重要なロジック）:**

Compacting（コンテキスト圧縮）が発生した場合、**新しいバッチを起動する前に**以下の手順で状態を復元:

```
1. current_batch.json を読み込み
2. if status == "waiting":
     # 前のバッチのPhase 2が未完了 → 既存task_idsの結果取得を続行
     # ※新しいバッチを起動しない（重複起動防止）
     for {resource, task_id} in task_ids:
       if resource not in completed_resources.txt:
         TaskOutput(task_id, block=true, timeout=300000)
         if 成功: append to completed_resources.txt
     status = "batch_completed"

3. elif status == "starting":
     # Phase 1が未完了 → task_idsが不完全
     # このバッチのリソースは次のバッチで再処理される
     status = "batch_completed"

4. # 通常ループ開始（completed_resources.txtで重複除外）
```

**なぜこれが重要か:**
- 復元処理なしの場合: Compacting後に新しい8件を起動 → 前の8件もまだ実行中 → 16 agent同時実行
- 復元処理ありの場合: 前のバッチの結果取得を完了してから次のバッチ → 常に8 agent以下

**重要な実装詳細:**

- **ループ開始前に必ず `current_batch.json` をチェック**（最重要）
- Phase 1では**必ず1メッセージで8件のTask呼び出しを行う**（並列起動のため）
- Phase 2のTaskOutput呼び出しは順次でよい（各Taskは既に並列実行中）
- TaskOutputがタイムアウトした場合、そのリソースは失敗として記録し、次へ進む
- **各リソース成功時に即座にチェックポイント** → compacting発生時も進捗を保持

#### 6.3 結果の検証とチェックポイント（Content-Return方式）

**サブエージェントの出力形式:**

バックグラウンドで実行されるサブエージェント（`/terraform-aws-annotated-reference`）は `output_mode=content` により、ファイル書き込みではなくJSON形式でテンプレート内容を返す:

```json
{"status":"success","resource":"aws_s3_bucket","provider_version":"6.28.0","content":"...テンプレート全文..."}
```

親エージェントは Phase 2/3 で以下を行う:
1. TaskOutput結果からJSON（`{"status":` で始まる部分）を抽出
2. `status == "success"` の場合、`content` フィールドを取得
3. 親エージェントのWriteツールで `terraform-template/{resource}.tf` に書き込み
4. 成功したリソースを `completed_resources.txt` に記録

**JSON抽出の注意点:**
- TaskOutputの結果には他のログも含まれる可能性がある
- `{"status":` で始まるJSONを検索して抽出する
- JSONパースに失敗した場合は失敗として扱う

各TaskOutputの結果取得後、JSONを抽出してファイル書き込みを行い、即座にチェックポイント：

```
VERSION="..." # 現在処理中のバージョン
COMPLETED_FILE=".local/${VERSION}/completed_resources.txt"

for {resource, task_id} in TASK_IDS; do
    result = TaskOutput(task_id, block=true, timeout=300000)

    # JSONを抽出（{"status": で始まる部分を検索）
    json = extract_json(result)  # {"status":"success","resource":"...","content":"..."}

    if json != null && json.status == "success":
        # 親エージェントでファイル書き込み
        Write("terraform-template/${resource}.tf", json.content)
        echo "✅ ${resource}"
        SUCCESS_COUNT++
        echo "${resource}" >> "$COMPLETED_FILE"
    else:
        # エラーまたはJSON抽出失敗
        echo "❌ ${resource}"
        FAILED_RESOURCES+=("$resource")
done
```

**チェックポイントの重要性:**
- 各リソースの成功時に即座に `completed_resources.txt` に追記
- Compacting発生時も進捗が保持される
- 次のバッチ開始前ではなく、各リソース完了時にチェックポイント
- **JSONパース失敗は失敗として扱う**

#### 6.4 タイムアウト・エラー時の処理

- **タイムアウト**: TaskOutputが300秒以内に結果を返さない場合、失敗として記録
- **エラー**: Taskがエラーで終了した場合、失敗として記録
- **継続**: 失敗したリソースがあっても、残りのリソースの処理は継続

```
タイムアウト/エラー発生時:
  1. 該当リソースを FAILED_RESOURCES に追加
  2. エラー理由を記録（timeout / error）
  3. 次のTaskOutput呼び出しへ進む
```

#### 6.5 処理結果サマリー

全バッチ完了後に結果を報告：

```
📊 Processing Summary:
  Total: {total_count}
  Succeeded: {success_count}
  Failed: {failed_count}
  Timeout: {timeout_count}
```

失敗したリソースがある場合は `.local/{version}/failed_resources.json` に記録:

```json
{
  "failed": [
    {"resource": "aws_example", "reason": "timeout"},
    {"resource": "aws_other", "reason": "error", "message": "..."}
  ]
}
```

**重要:**
- ユーザー確認は行わない（完了報告とエラー報告のみ）
- 一部が失敗しても他のリソースの処理は継続
- 各Taskは独立して実行されるため、1つの失敗が他に影響しない
- タイムアウトにより無限待機を防止

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
- 変更ログを `.local/{version}/change_log.txt` に生成

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
├── .local/
│   └── {version}/
│       ├── providers.tf                 # Terraform初期化用
│       ├── schema.json                  # スキーマキャッシュ
│       ├── change_log.txt               # 変更ログ
│       ├── completed_resources.txt      # 処理済みリソース一覧（チェックポイント）
│       └── current_batch.json           # 現在のバッチ状態
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
- **タイムアウト:** 各Taskは5分でタイムアウト（無限待機を防止）
- **上書き:** 既存テンプレートファイルは上書きされる
- **アーカイブ:** 削除されたリソースのテンプレートは `terraform-template/archived/` に移動
- **失敗リソース:** タイムアウト・エラーのリソースは `.local/{version}/failed_resources.json` に記録
- **チェックポイント:** 各リソース完了時に `completed_resources.txt` に記録（中断・再開対応）
- **状態復元:** Compacting発生後も `completed_resources.txt` から進捗を復元し重複処理を防止
- **中断・再開:** セッション中断後も途中から処理を再開可能
