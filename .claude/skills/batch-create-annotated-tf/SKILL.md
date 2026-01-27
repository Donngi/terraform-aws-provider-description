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

AWS Providerバージョン差分を自動検出し、変更リソースのみ解説付きテンプレートを**8並列**で一括生成。

## 制約事項

### 絶対禁止
- **WebSearch / WebFetch** - 使用禁止
- エラー時もWeb検索にフォールバックしない

### サブエージェントの制約
- サブエージェント（`/terraform-aws-annotated-reference`）は**Writeツール使用不可**（フックでブロック）
- サブエージェントはJSON形式でテンプレート内容を**テキスト出力**する
- 親エージェントが`extract_and_write.sh`でファイル書き込みを実行

## 処理フロー

```
1. 最新バージョン取得      → lib/01_fetch_latest_version.sh
2. 前回バージョン読込み    → lib/02_load_last_version.sh
3. バージョン比較（同一なら終了）
4. スキーマ準備            → lib/03_prepare_schema.sh
5. 差分検出                → lib/04_detect_changes.sh
6. 並列処理実行（8並列）   → Task tool + TaskOutput
7. 削除リソースアーカイブ  → lib/05_archive_removed.sh
8. バージョンファイル更新  → lib/06_update_version_file.sh
9. 変更ログ生成            → lib/07_generate_changelog.sh
```

## 並列処理仕様

| 項目 | 値 |
|------|-----|
| 並列度 | MAX 8 |
| タイムアウト | 5分（300000ms） |
| チェックポイント | 各リソース完了時 |

### 状態管理ファイル

```
.local/{version}/completed_resources.txt  # 処理済みリソース（1行1リソース）
.local/{version}/current_batch.json       # バッチ状態
.local/{version}/failed_resources.json    # 失敗リソース
```

**current_batch.json の形式:**
```json
{"batch": ["aws_s3_bucket", ...], "task_ids": [...], "status": "starting|waiting|batch_completed"}
```

## 実行パターン

### 復元処理（ループ開始前に必須）

```
if current_batch.json exists:
    if status == "waiting":
        # 前バッチのPhase 2を続行（新バッチを起動しない）
        → 保存されたtask_idsでTaskOutputを呼び出し
        → completed_resources.txtにないリソースのみ処理
    elif status == "starting":
        # Phase 1未完了 → スキップ（次バッチで再処理）

    status = "batch_completed"
```

### 通常ループ

```
while 未処理リソースあり:
    1. completed_resources.txt をロード、完了済みを除外
    2. 8件のバッチを準備
    3. current_batch.json に {status: "starting"} を保存
    4. Phase 1: 8件のTaskを run_in_background=true で1メッセージで同時起動
    5. current_batch.json に {task_ids: [...], status: "waiting"} を保存
    6. Phase 2: 各task_idに対してTaskOutputで結果取得
    7. 成功したリソースを completed_resources.txt に追記
    8. current_batch.json に {status: "batch_completed"} を保存
```

## サブエージェント呼び出し

### Task起動

```
Task(
    subagent_type="general-purpose",
    description="Generate {resource} template",
    prompt="/terraform-aws-annotated-reference {resource} provider_version={version} output_mode=content",
    max_turns=50,
    run_in_background=true
)
```

### 期待されるサブエージェント出力

サブエージェントはJSON形式でテキスト出力（Writeツール不使用）:

```json
{"status":"success","resource":"aws_s3_bucket","provider_version":"6.28.0","content":"...テンプレート全文..."}
```

### 結果処理

```bash
# TaskOutputで完了待機後、シェルスクリプトでJSON抽出・書き込み
lib/extract_and_write.sh ${output_file} terraform-template/${resource}.tf ${resource}
```

## エラーコード

| コード | 理由 | 説明 |
|--------|------|------|
| 0 | success | 成功 |
| 1 | no_json_output | JSONが見つからない |
| 2 | invalid_json | JSONパースエラー |
| 3 | subagent_error | サブエージェントエラー |
| 4 | unknown_status | 不明なstatus |
| 5 | empty_content | contentが空 |
| 6 | write_failed | ファイル書き込み失敗 |
| 7 | invalid_arguments | 引数エラー |
| 8 | output_file_not_found | 出力ファイルなし |

## ファイル構成

```
プロジェクトルート/
├── processed_provider_version.json      # バージョン管理
├── .claude/skills/batch-create-annotated-tf/
│   ├── SKILL.md
│   └── lib/
│       ├── 01_fetch_latest_version.sh
│       ├── 02_load_last_version.sh
│       ├── 03_prepare_schema.sh
│       ├── 04_detect_changes.sh
│       ├── 05_archive_removed.sh
│       ├── 06_update_version_file.sh
│       ├── 07_generate_changelog.sh
│       └── extract_and_write.sh         # JSON抽出・書き込み
├── .local/{version}/
│   ├── schema.json
│   ├── completed_resources.txt
│   ├── current_batch.json
│   └── failed_resources.json
└── terraform-template/
    ├── {resource}.tf
    └── archived/
```

## 処理結果サマリー

全バッチ完了後に報告:

```
📊 Processing Summary:
  Total: {total_count}
  Succeeded: {success_count}
  Failed: {failed_count}
```

失敗リソースは `.local/{version}/failed_resources.json` に記録。

## 注意事項

- **差分のみ処理**: 変更があったリソースのみ
- **初回実行**: 全リソースを処理
- **エラー継続**: 失敗しても他リソースは処理継続
- **タイムアウト**: 5分で無限待機を防止
- **チェックポイント**: 中断・再開に対応
- **状態復元**: Compacting後も進捗を維持
